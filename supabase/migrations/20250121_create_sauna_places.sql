-- Create the sauna_places table
CREATE TABLE IF NOT EXISTS public.sauna_places (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    wild_location JSONB,
    commercial_location JSONB,
    nearby_service JSONB,
    nearby_activity JSONB,
    checked_in_users JSONB DEFAULT '[]'::jsonb,
    description TEXT,
    img_links JSONB DEFAULT '[]'::jsonb,
    address TEXT,
    commercial_phone TEXT,
    zip_code TEXT,
    sauna_type TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_sauna_places_location 
ON public.sauna_places USING gist (
    ll_to_earth(latitude, longitude)
);

CREATE INDEX IF NOT EXISTS idx_sauna_places_user_id 
ON public.sauna_places(user_id);

-- Enable Row Level Security (RLS)
ALTER TABLE public.sauna_places ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Enable read access for all users" ON public.sauna_places
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users only" ON public.sauna_places
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update for sauna owners" ON public.sauna_places
    FOR UPDATE USING (
        auth.uid() = user_id
    );

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER handle_updated_at
    BEFORE UPDATE ON public.sauna_places
    FOR EACH ROW
    EXECUTE PROCEDURE public.handle_updated_at();
