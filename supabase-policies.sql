-- Ejecutar en Supabase SQL Editor.
-- Reemplazar ADMIN_EMAIL_HERE por el correo del usuario administrador de Supabase Auth.

ALTER TABLE public.encuestas_malix ENABLE ROW LEVEL SECURITY;
GRANT INSERT ON public.encuestas_malix TO anon, authenticated;
GRANT SELECT, DELETE ON public.encuestas_malix TO authenticated;

DROP POLICY IF EXISTS "Permitir insertar encuestas" ON public.encuestas_malix;
DROP POLICY IF EXISTS "Solo admin lee encuestas" ON public.encuestas_malix;
DROP POLICY IF EXISTS "Encuestas insert public" ON public.encuestas_malix;
DROP POLICY IF EXISTS "Encuestas select admin" ON public.encuestas_malix;
DROP POLICY IF EXISTS "Encuestas delete admin" ON public.encuestas_malix;

CREATE POLICY "Encuestas insert public"
ON public.encuestas_malix
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

CREATE POLICY "Encuestas select admin"
ON public.encuestas_malix
FOR SELECT
TO authenticated
USING ((auth.jwt() ->> 'email') = 'macasherr@hotmail.com');

CREATE POLICY "Encuestas delete admin"
ON public.encuestas_malix
FOR DELETE
TO authenticated
USING ((auth.jwt() ->> 'email') = 'macasherr@hotmail.com');

DROP POLICY IF EXISTS "Permitir subir fotos" ON storage.objects;
DROP POLICY IF EXISTS "Fotos insert public" ON storage.objects;
DROP POLICY IF EXISTS "Fotos select admin" ON storage.objects;
DROP POLICY IF EXISTS "Fotos delete admin" ON storage.objects;

CREATE POLICY "Fotos insert public"
ON storage.objects
FOR INSERT
TO anon, authenticated
WITH CHECK (bucket_id = 'fotos-encuestas');

CREATE POLICY "Fotos select admin"
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'fotos-encuestas'
  AND (auth.jwt() ->> 'email') = 'macasherr@hotmail.com'
);

CREATE POLICY "Fotos delete admin"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'fotos-encuestas'
  AND (auth.jwt() ->> 'email') = 'macasherr@hotmail.com'
);

GRANT INSERT ON storage.objects TO anon, authenticated;
GRANT SELECT, DELETE ON storage.objects TO authenticated;
