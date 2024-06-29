CREATE TABLE asignacion (
    id_asignacion               INTEGER NOT NULL,
    año                         INTEGER NOT NULL,
    ciclo                       VARCHAR2(100) NOT NULL,
    zona                        INTEGER NOT NULL,
    nota                        INTEGER NOT NULL,
    seccion_codigo_seccion      INTEGER NOT NULL,
    estudiante_numero_de_carnet INTEGER NOT NULL
);

ALTER TABLE asignacion ADD CONSTRAINT asignacion_pk PRIMARY KEY ( id_asignacion );

CREATE TABLE carrera (
    codigo_carrera INTEGER NOT NULL,
    nombre         VARCHAR2(100) NOT NULL
);

ALTER TABLE carrera ADD CONSTRAINT carrera_pk PRIMARY KEY ( codigo_carrera );

CREATE TABLE catedratico (
    codigo_catedratico INTEGER NOT NULL,
    nombre             VARCHAR2(100) NOT NULL,
    sueldo             INTEGER NOT NULL
);

ALTER TABLE catedratico ADD CONSTRAINT catedratico_pk PRIMARY KEY ( codigo_catedratico );

CREATE TABLE curso (
    codigo_curso INTEGER NOT NULL,
    nombre       VARCHAR2(100) NOT NULL
);

ALTER TABLE curso ADD CONSTRAINT curso_pk PRIMARY KEY ( codigo_curso );

CREATE TABLE dia (
    codigo_dia INTEGER NOT NULL,
    dia        VARCHAR2(100) NOT NULL
);

ALTER TABLE dia ADD CONSTRAINT dia_pk PRIMARY KEY ( codigo_dia );

CREATE TABLE edificio (
    codigo_edificio INTEGER NOT NULL,
    nombre_edificio VARCHAR2(100) NOT NULL
);

ALTER TABLE edificio ADD CONSTRAINT edificio_pk PRIMARY KEY ( codigo_edificio );

CREATE TABLE estudiante (
    numero_de_carnet INTEGER NOT NULL,
    nombre           VARCHAR2(30) NOT NULL,
    ingreso_familiar VARCHAR2(100),
    fecha_nacimiento DATE NOT NULL
);

ALTER TABLE estudiante ADD CONSTRAINT estudiante_pk PRIMARY KEY ( numero_de_carnet );

CREATE TABLE horario (
    codigo_horario         INTEGER NOT NULL,
    salon_codigo_salon     INTEGER NOT NULL,
    dia_codigo_dia         INTEGER NOT NULL,
    periodo_codigo_periodo INTEGER NOT NULL,
    seccion_codigo_seccion INTEGER NOT NULL
);

ALTER TABLE horario ADD CONSTRAINT horario_pk PRIMARY KEY ( codigo_horario );

CREATE TABLE inscripcion (
    estudiante_numero_de_carnet INTEGER NOT NULL,
    plan_codigo_plan            INTEGER NOT NULL,
    fecha_inscripcion           DATE NOT NULL
);

ALTER TABLE inscripcion ADD CONSTRAINT inscripcion_pk PRIMARY KEY ( estudiante_numero_de_carnet );

CREATE TABLE pensum (
    codigo             INTEGER NOT NULL,
    obligatoriedad     VARCHAR2(100) NOT NULL,
    creditos_obtenidos INTEGER NOT NULL,
    nota_aprobacion    INTEGER NOT NULL,
    zona_minima        INTEGER NOT NULL,
    plan_codigo_plan   INTEGER NOT NULL,
    curso_codigo_curso INTEGER NOT NULL
);

ALTER TABLE pensum ADD CONSTRAINT pensum_pk PRIMARY KEY ( codigo );

CREATE TABLE periodo (
    codigo_periodo INTEGER NOT NULL,
    horario_inicio VARCHAR2(100) NOT NULL,
    horario_final  VARCHAR2(100) NOT NULL
);

ALTER TABLE periodo ADD CONSTRAINT periodo_pk PRIMARY KEY ( codigo_periodo );

CREATE TABLE plan (
    codigo_plan            INTEGER NOT NULL,
    nombre                 VARCHAR2(100) NOT NULL,
    año_inicio             DATE NOT NULL,
    año_fin                DATE NOT NULL,
    ciclo_inicio           DATE NOT NULL,
    ciclo_fin              DATE NOT NULL,
    creditos_necesarios    INTEGER NOT NULL,
    carrera_codigo_carrera INTEGER NOT NULL
);

ALTER TABLE plan ADD CONSTRAINT plan_pk PRIMARY KEY ( codigo_plan );

CREATE TABLE prerrequisito (
    codigo              INTEGER NOT NULL,
    carrera             VARCHAR2(100) NOT NULL,
    plan                VARCHAR2(100) NOT NULL,
    curso_codigo_curso  INTEGER NOT NULL,
    curso_codigo_curso1 INTEGER NOT NULL
);

ALTER TABLE prerrequisito ADD CONSTRAINT prerrequisito_pk PRIMARY KEY ( codigo );

CREATE TABLE salon (
    codigo_salon             INTEGER NOT NULL,
    capacidad                INTEGER NOT NULL,
    edificio_codigo_edificio INTEGER NOT NULL
);

ALTER TABLE salon ADD CONSTRAINT salon_pk PRIMARY KEY ( codigo_salon );

CREATE TABLE seccion (
    codigo_seccion                 INTEGER NOT NULL,
    año                            DATE NOT NULL,
    ciclo                          VARCHAR2(100),
    curso_codigo_curso             INTEGER NOT NULL,
    catedratico_codigo_catedratico INTEGER NOT NULL
);

ALTER TABLE seccion ADD CONSTRAINT seccion_pk PRIMARY KEY ( codigo_seccion );

ALTER TABLE asignacion
    ADD CONSTRAINT asignacion_estudiante_fk FOREIGN KEY ( estudiante_numero_de_carnet )
        REFERENCES estudiante ( numero_de_carnet );

ALTER TABLE asignacion
    ADD CONSTRAINT asignacion_seccion_fk FOREIGN KEY ( seccion_codigo_seccion )
        REFERENCES seccion ( codigo_seccion );

ALTER TABLE horario
    ADD CONSTRAINT horario_dia_fk FOREIGN KEY ( dia_codigo_dia )
        REFERENCES dia ( codigo_dia );

ALTER TABLE horario
    ADD CONSTRAINT horario_periodo_fk FOREIGN KEY ( periodo_codigo_periodo )
        REFERENCES periodo ( codigo_periodo );

ALTER TABLE horario
    ADD CONSTRAINT horario_salon_fk FOREIGN KEY ( salon_codigo_salon )
        REFERENCES salon ( codigo_salon );

ALTER TABLE horario
    ADD CONSTRAINT horario_seccion_fk FOREIGN KEY ( seccion_codigo_seccion )
        REFERENCES seccion ( codigo_seccion );

ALTER TABLE inscripcion
    ADD CONSTRAINT inscripcion_estudiante_fk FOREIGN KEY ( estudiante_numero_de_carnet )
        REFERENCES estudiante ( numero_de_carnet );

ALTER TABLE inscripcion
    ADD CONSTRAINT inscripcion_plan_fk FOREIGN KEY ( plan_codigo_plan )
        REFERENCES plan ( codigo_plan );

ALTER TABLE pensum
    ADD CONSTRAINT pensum_curso_fk FOREIGN KEY ( curso_codigo_curso )
        REFERENCES curso ( codigo_curso );

ALTER TABLE pensum
    ADD CONSTRAINT pensum_plan_fk FOREIGN KEY ( plan_codigo_plan )
        REFERENCES plan ( codigo_plan );

ALTER TABLE plan
    ADD CONSTRAINT plan_carrera_fk FOREIGN KEY ( carrera_codigo_carrera )
        REFERENCES carrera ( codigo_carrera );

ALTER TABLE prerrequisito
    ADD CONSTRAINT prerrequisito_curso_fk FOREIGN KEY ( curso_codigo_curso )
        REFERENCES curso ( codigo_curso );

ALTER TABLE prerrequisito
    ADD CONSTRAINT prerrequisito_curso_fkv1 FOREIGN KEY ( curso_codigo_curso1 )
        REFERENCES curso ( codigo_curso );

ALTER TABLE salon
    ADD CONSTRAINT salon_edificio_fk FOREIGN KEY ( edificio_codigo_edificio )
        REFERENCES edificio ( codigo_edificio );

ALTER TABLE seccion
    ADD CONSTRAINT seccion_catedratico_fk FOREIGN KEY ( catedratico_codigo_catedratico )
        REFERENCES catedratico ( codigo_catedratico );

ALTER TABLE seccion
    ADD CONSTRAINT seccion_curso_fk FOREIGN KEY ( curso_codigo_curso )
        REFERENCES curso ( codigo_curso );