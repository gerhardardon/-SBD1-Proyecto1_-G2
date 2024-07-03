/*1. Mostrar el estudiante con mejor promedio por carrera el cual haya empezado a
estudiar antes del 2022.*/
-- Consulta 1
WITH
    estudiantes_promedio AS (
        SELECT
            e.numero_de_carnet,
            e.nombre AS nombre_estudiante,
            AVG(a.nota) AS promedio,
            p.carrera_codigo_carrera
        FROM
            estudiante e
            INNER JOIN inscripcion i ON e.numero_de_carnet = i.estudiante_numero_de_carnet
            INNER JOIN pensum pe ON i.plan_codigo_plan = pe.plan_codigo_plan
            INNER JOIN asignacion a ON i.estudiante_numero_de_carnet = a.estudiante_numero_de_carnet
            INNER JOIN seccion s ON a.seccion_codigo_seccion = s.codigo_seccion
            INNER JOIN curso c ON s.curso_codigo_curso = c.codigo_curso
            INNER JOIN plan p ON pe.plan_codigo_plan = p.codigo_plan
        WHERE
            TO_CHAR (i.fecha_inscripcion, 'YYYY') < '2022'
        GROUP BY
            e.numero_de_carnet,
            e.nombre,
            p.carrera_codigo_carrera
    ),
    mejor_promedio_por_carrera AS (
        SELECT
            p.carrera_codigo_carrera,
            MAX(ep.promedio) AS mejor_promedio
        FROM
            estudiantes_promedio ep
            INNER JOIN plan p ON ep.carrera_codigo_carrera = p.codigo_plan
        GROUP BY
            p.carrera_codigo_carrera
    )
SELECT
    ep.numero_de_carnet,
    ep.nombre_estudiante,
    ep.promedio,
    c.nombre AS nombre_carrera
FROM
    estudiantes_promedio ep
    INNER JOIN mejor_promedio_por_carrera mp ON ep.carrera_codigo_carrera = mp.carrera_codigo_carrera
    INNER JOIN carrera c ON ep.carrera_codigo_carrera = c.codigo_carrera
WHERE
    ep.promedio = mp.mejor_promedio;

/*2. Mostrar los cursos que se imparten en un mismo horario en un ciclo y año
determinado, debe mostrar código de curso, nombre del curso, carrera a la que
pertenece, sección, horario, día, salón, edificio y catedrático que lo imparte.
Remplazar ciclo y año*/
-- Consulta 2
SELECT
    c.codigo_curso,
    c.nombre AS nombre_curso,
    carr.nombre AS nombre_carrera,
    s.codigo_seccion AS seccion,
    p.horario_inicio || ' - ' || p.horario_final AS horario,
    d.dia,
    sa.codigo_salon AS salon,
    e.nombre_edificio AS edificio,
    cat.nombre AS nombre_catedratico
FROM
    curso c
    INNER JOIN pensum pe ON c.codigo_curso = pe.curso_codigo_curso
    INNER JOIN plan pl ON pe.plan_codigo_plan = pl.codigo_plan
    INNER JOIN carrera carr ON pl.carrera_codigo_carrera = carr.codigo_carrera
    INNER JOIN seccion s ON c.codigo_curso = s.curso_codigo_curso
    INNER JOIN horario h ON s.codigo_seccion = h.seccion_codigo_seccion
    INNER JOIN dia d ON h.dia_codigo_dia = d.codigo_dia
    INNER JOIN periodo p ON h.periodo_codigo_periodo = p.codigo_periodo
    INNER JOIN salon sa ON h.salon_codigo_salon = sa.codigo_salon
    INNER JOIN edificio e ON sa.edificio_codigo_edificio = e.codigo_edificio
    INNER JOIN catedratico cat ON s.catedratico_codigo_catedratico = cat.codigo_catedratico
WHERE
    s.ciclo = '1' -- Reemplazar con el ciclo específico
    AND EXTRACT(
        YEAR
        FROM
            s.año
    ) = 2020 -- Extraer el año de la columna s.año y comparar
ORDER BY
    p.horario_inicio,
    d.dia;

/*3. Mostrar la información de los cursos pertenecientes a una carrera en específico.
reemplazar Nombre_Carrera_Especifica */
SELECT
    c.codigo_curso,
    c.nombre AS nombre_curso,
    ca.nombre AS nombre_carrera
FROM
    curso c
    JOIN pensum p ON c.codigo_curso = p.curso_codigo_curso
    JOIN carrera ca ON p.plan_codigo_plan = ca.codigo_carrera
WHERE
    ca.nombre = 'Sistemas';

/*4. Mostrarla información de los cursos prerrequisito y post requisito de un curso en
específico.*/
--Consulta 4
SELECT
    post.nombre AS curso_prerrequisito,
    pre.nombre AS curso_post_requisito
FROM
    curso c
    LEFT JOIN prerrequisito pr ON c.codigo_curso = pr.curso_codigo_curso1
    LEFT JOIN curso post ON pr.curso_codigo_curso = post.codigo_curso
    LEFT JOIN prerrequisito po ON c.codigo_curso = po.curso_codigo_curso
    LEFT JOIN curso pre ON po.curso_codigo_curso1 = pre.codigo_curso
WHERE
    c.codigo_curso = 103;

--cambiar al codigo de curso que se desea
/*5. Mostrar los cursos impartidos por un determinado docente, mostrar la información
necesaria para cada curso.*/
SELECT
    c.nombre AS nombre_curso,
    s.año,
    s.ciclo,
    ct.nombre AS nombre_catedratico
FROM
    curso c
    JOIN seccion s ON c.codigo_curso = s.curso_codigo_curso
    JOIN catedratico ct ON s.catedratico_codigo_catedratico = ct.codigo_catedratico
WHERE
    ct.nombre = 'Ing. Marco Pérez';

/*6. Mostrar las aprobaciones de estudiantes para un determinado curso, se debe
mostrar nombre del estudiante, el código del curso o nombre, el número de carné,
y si aprobó o no.*/
SELECT
    e.nombre AS nombre_estudiante,
    e.numero_de_carnet,
    c.codigo_curso,
    c.nombre AS nombre_curso,
    CASE
        WHEN a.nota >= 61 THEN 'Aprobó'
        ELSE 'No Aprobó'
    END AS estado_aprobacion
FROM
    asignacion a
    JOIN estudiante e ON a.estudiante_numero_de_carnet = e.numero_de_carnet
    JOIN seccion s ON a.seccion_codigo_seccion = s.codigo_seccion
    JOIN curso c ON s.curso_codigo_curso = c.codigo_curso
    JOIN pensum p ON c.codigo_curso = p.curso_codigo_curso
WHERE
    c.codigo_curso = 1;

/*7. Dar el nombre del estudiante, promedio, y número de créditos ganados, para los
estudiantes que han cerrado Ingeniería en Ciencias y Sistemas.*/
SELECT
    e.nombre AS nombre_estudiante,
    AVG(a.nota) AS promedio,
    SUM(p.creditos_obtenidos) AS creditos_ganados
FROM
    estudiante e
JOIN
    asignacion a ON e.numero_de_carnet = a.estudiante_numero_de_carnet
JOIN
    seccion s ON a.seccion_codigo_seccion = s.codigo_seccion
JOIN
    pensum p ON s.curso_codigo_curso = p.curso_codigo_curso
JOIN
    plan pl ON p.plan_codigo_plan = pl.codigo_plan
JOIN
    carrera c ON pl.carrera_codigo_carrera = c.codigo_carrera
WHERE
    c.nombre = 'Ingeniería en Sistemas'
GROUP BY
    e.nombre,
    pl.creditos_necesarios
HAVING
    SUM(p.creditos_obtenidos) >= pl.creditos_necesarios;


commit;



/*8. Dar el nombre del estudiante nombre de la carrera, promedio y número de créditos
ganados, para los estudiantes que han cerrado en alguna carrera, estén inscritos en
ella o no.*/
SELECT
    e.nombre AS nombre_estudiante,
    c.nombre AS nombre_carrera,
    AVG(a.nota) AS promedio,
    SUM(p.creditos_obtenidos) AS creditos_ganados
FROM
    estudiante e
JOIN
    asignacion a ON e.numero_de_carnet = a.estudiante_numero_de_carnet
JOIN
    seccion s ON a.seccion_codigo_seccion = s.codigo_seccion
JOIN
    pensum p ON s.curso_codigo_curso = p.curso_codigo_curso
JOIN
    plan pl ON p.plan_codigo_plan = pl.codigo_plan
JOIN
    carrera c ON pl.carrera_codigo_carrera = c.codigo_carrera
GROUP BY
    e.nombre,
    c.nombre,
    pl.creditos_necesarios
HAVING
    SUM(p.creditos_obtenidos) >= pl.creditos_necesarios;


/*9. Dar el nombre de los estudiantes que han ganado algún curso con alguno de los
catedráticos que han impartido alguno de los cursos de la carrera de sistemas en
alguno de los planes que se impartieron en el semestre pasado.*/
WITH catedraticos_sistemas AS (
    SELECT DISTINCT
        s.catedratico_codigo_catedratico
    FROM
        seccion s
    JOIN
        curso c ON s.curso_codigo_curso = c.codigo_curso
    JOIN
        pensum p ON c.codigo_curso = p.curso_codigo_curso
    JOIN
        plan pl ON p.plan_codigo_plan = pl.codigo_plan
    JOIN
        carrera ca ON pl.carrera_codigo_carrera = ca.codigo_carrera
    WHERE
        ca.nombre = 'Ingeniería en Sistemas'
        AND s.año BETWEEN DATE '2021-01-01' AND DATE '2021-06-30'
)
SELECT DISTINCT
    e.nombre AS nombre_estudiante
FROM
    estudiante e
JOIN
    asignacion a ON e.numero_de_carnet = a.estudiante_numero_de_carnet
JOIN
    seccion s ON a.seccion_codigo_seccion = s.codigo_seccion
JOIN
    catedraticos_sistemas cs ON s.catedratico_codigo_catedratico = cs.catedratico_codigo_catedratico
WHERE
    a.nota >= 61;


/*10. Para un estudiante determinado que, ha cerrado en alguna carrera, dar el nombre
de los estudiantes que llevaron con él todos los cursos.*/
-- Paso 1: Identificar los cursos que el estudiante específico ha completado
WITH cursos_del_estudiante AS (
    SELECT
        a.seccion_codigo_seccion,
        s.curso_codigo_curso
    FROM
        asignacion a
    JOIN
        seccion s ON a.seccion_codigo_seccion = s.codigo_seccion
    WHERE
        a.estudiante_numero_de_carnet = 1001
        AND a.nota >= 61  -- Suponiendo que 60 es la nota mínima para aprobar el curso
),
-- Paso 2: Obtener la lista de estudiantes que hayan completado cada uno de los cursos del estudiante específico
estudiantes_que_completaron_cursos AS (
    SELECT
        a.estudiante_numero_de_carnet,
        a.seccion_codigo_seccion,
        s.curso_codigo_curso
    FROM
        asignacion a
    JOIN
        seccion s ON a.seccion_codigo_seccion = s.codigo_seccion
    JOIN
        cursos_del_estudiante cde ON s.curso_codigo_curso = cde.curso_codigo_curso
    WHERE
        a.nota >= 61
)
-- Paso 3: Contar cuántos cursos en común tienen los estudiantes con el estudiante específico
SELECT
    e.nombre AS nombre_estudiante
FROM
    estudiante e
JOIN
    (SELECT
        e2.estudiante_numero_de_carnet,
        COUNT(e2.curso_codigo_curso) AS cursos_en_comun
     FROM
        estudiantes_que_completaron_cursos e2
     GROUP BY
        e2.estudiante_numero_de_carnet
     HAVING
        COUNT(e2.curso_codigo_curso) = (SELECT COUNT(*) FROM cursos_del_estudiante)
    ) ec ON e.numero_de_carnet = ec.estudiante_numero_de_carnet
WHERE
    e.numero_de_carnet <> 1001;  -- Excluir al estudiante específico