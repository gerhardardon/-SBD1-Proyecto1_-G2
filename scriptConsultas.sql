/*1. Mostrar el estudiante con mejor promedio por carrera el cual haya empezado a
estudiar antes del 2022.*/

SELECT e.numero_carnet, e.nombre_completo, e.numero_carrera, AVG(i.nota) AS promedio
FROM Estudiante e
JOIN Inscripcion i ON e.numero_carnet = i.numero_carnet
JOIN Carrera c ON e.numero_carrera = c.numero_carrera
WHERE i.fecha_inscripcion < TO_DATE('2022-01-01', 'YYYY-MM-DD')
GROUP BY e.numero_carnet, e.nombre_completo, e.numero_carrera
HAVING AVG(i.nota) = (
    SELECT MAX(promedio)
    FROM (
        SELECT e.numero_carrera, AVG(i.nota) AS promedio
        FROM Estudiante e
        JOIN Inscripcion i ON e.numero_carnet = i.numero_carnet
        WHERE i.fecha_inscripcion < TO_DATE('2022-01-01', 'YYYY-MM-DD')
        GROUP BY e.numero_carrera
    )
);

/*2. Mostrar los cursos que se imparten en un mismo horario en un ciclo y año
determinado, debe mostrar código de curso, nombre del curso, carrera a la que
pertenece, sección, horario, día, salón, edificio y catedrático que lo imparte.
Remplazar ciclo y año*/

SELECT c.codigo_curso, c.nombre_curso, carr.nombre_carrera, sec.codigo_seccion, h.dia, h.hora_inicio, h.hora_fin, s.codigo_salon, s.codigo_edificio, cat.nombre_completo AS nombre_catedratico
FROM Curso c
JOIN Seccion sec ON c.codigo_curso = sec.codigo_curso
JOIN Horario h ON sec.codigo_seccion = h.codigo_seccion
JOIN Salon s ON h.codigo_salon = s.codigo_salon
JOIN Catedratico cat ON sec.codigo_catedratico = cat.codigo_catedratico
JOIN Carrera carr ON c.codigo_carrera = carr.codigo_carrera
WHERE h.ciclo = 'Ciclo_determinado' AND h.anno = 'Año_determinado';

/*3. Mostrar la información de los cursos pertenecientes a una carrera en específico.
reemplazar Nombre_Carrera_Especifica */

SELECT c.codigo_curso, c.nombre_curso, carr.nombre_carrera, sec.codigo_seccion, h.dia, h.hora_inicio, h.hora_fin, s.codigo_salon, s.codigo_edificio, cat.nombre_completo AS nombre_catedratico
FROM Curso c
JOIN Seccion sec ON c.codigo_curso = sec.codigo_curso
JOIN Horario h ON sec.codigo_seccion = h.codigo_seccion
JOIN Salon s ON h.codigo_salon = s.codigo_salon
JOIN Catedratico cat ON sec.codigo_catedratico = cat.codigo_catedratico
JOIN Carrera carr ON c.codigo_carrera = carr.codigo_carrera
WHERE carr.nombre_carrera = 'Nombre_Carrera_Especifica';


/*4. Mostrarla información de los cursos prerrequisito y post requisito de un curso en
específico.*/
--Consulta 4
SELECT
    post.nombre AS curso_prerrequisito,
    pre.nombre AS curso_post_requisito
FROM
    curso c
LEFT JOIN
    prerrequisito pr ON c.codigo_curso = pr.curso_codigo_curso1
LEFT JOIN
    curso post ON pr.curso_codigo_curso = post.codigo_curso
LEFT JOIN
    prerrequisito po ON c.codigo_curso = po.curso_codigo_curso
LEFT JOIN
    curso pre ON po.curso_codigo_curso1 = pre.codigo_curso
WHERE
    c.codigo_curso = 103;--cambiar al codigo de curso que se desea

/*5. Mostrar los cursos impartidos por un determinado docente, mostrar la información
necesaria para cada curso.*/


/*6. Mostrar las aprobaciones de estudiantes para un determinado curso, se debe
mostrar nombre del estudiante, el código del curso o nombre, el número de carné,
y si aprobó o no.*/


/*7. Dar el nombre del estudiante, promedio, y número de créditos ganados, para los
estudiantes que han cerrado Ingeniería en Ciencias y Sistemas.*/



/*8. Dar el nombre del estudiante nombre de la carrera, promedio y número de créditos
ganados, para los estudiantes que han cerrado en alguna carrera, estén inscritos en
ella o no.*/


/*9. Dar el nombre de los estudiantes que han ganado algún curso con alguno de los
catedráticos que han impartido alguno de los cursos de la carrera de sistemas en
alguno de los planes que se impartieron en el semestre pasado.*/



/*10. Para un estudiante determinado que, ha cerrado en alguna carrera, dar el nombre
de los estudiantes que llevaron con él todos los cursos.*/
