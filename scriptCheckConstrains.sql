ALTER TABLE Inscripcion
ADD CONSTRAINT check_aprobacion_curso
CHECK (
    EXISTS (
        SELECT 1 FROM Pensum P
        WHERE Inscripcion.codigo_carrera = P.codigo_carrera
        AND Inscripcion.codigo_plan = P.codigo_plan
        AND Inscripcion.codigo_curso = P.codigo_curso
        AND Inscripcion.zona >= P.zona_minima
        AND Inscripcion.nota >= P.nota_aprobacion
    )
);

ALTER TABLE Seccion
ADD CONSTRAINT check_promedio
CHECK (
    NOT EXISTS (
        SELECT 1 FROM Seccion S
        WHERE S.codigo_seccion = Seccion.codigo_seccion
        AND (SELECT COUNT(*) FROM Curso C JOIN Inscripcion I ON C.codigo_curso = I.codigo_curso WHERE I.numero_carnet = Seccion.numero_carnet AND I.nota >= P.nota_aprobacion) = 0
    )
);

ALTER TABLE Plan
ADD CONSTRAINT check_cierre_carrera
CHECK (
    EXISTS (
        SELECT 1 FROM Plan P
        WHERE Plan.codigo_plan = Inscripcion.codigo_plan
        AND Plan.codigo_carrera = Inscripcion.codigo_carrera
        AND (SELECT COUNT(*) FROM Pensum WHERE codigo_carrera = Inscripcion.codigo_carrera AND codigo_plan = Inscripcion.codigo_plan AND obligatoriedad = 'O' AND codigo_curso NOT IN (SELECT codigo_curso FROM Inscripcion WHERE numero_carnet = Inscripcion.numero_carnet)) = 0
    )
);

ALTER TABLE Estudiante
ADD CONSTRAINT check_mejor_estudiante
CHECK (
    NOT EXISTS (
        SELECT 1 FROM Inscripcion
        WHERE Inscripcion.numero_carnet = Estudiante.numero_carnet
        AND Inscripcion.nota < (SELECT MAX(nota) FROM Inscripcion WHERE numero_carnet = Estudiante.numero_carnet)
    )
);
