# Resumen SQL/DES

Este directorio contiene un resumen completo de SQL con sintaxis DES (Datalog Educational System).

## Archivos

- `resumen_sql.tex`: Documento fuente LaTeX con el resumen
- `resumen_sql.pdf`: PDF compilado del resumen (2 páginas)

## Contenido del Resumen

El resumen incluye:

1. **Comandos de Sistema DES**: /abolish, /multiline, /duplicates
2. **DDL - Definición de Datos**: CREATE TABLE, PRIMARY KEY
3. **DML - Manipulación de Datos**: INSERT, NULL
4. **Consultas SELECT**: SELECT básico, *, DISTINCT
5. **Operadores Lógicos**: AND, OR, NOT, comparaciones, IS NULL, IN
6. **VISTAS**: CREATE VIEW
7. **Operaciones de Conjuntos**: UNION, INTERSECT, EXCEPT
8. **JOIN**: JOIN implícito, NATURAL JOIN, JOIN explícito
9. **Funciones de Agregación**: SUM, COUNT, AVG, MAX, MIN
10. **GROUP BY y HAVING**
11. **Subconsultas**: Escalares, en IN, en FROM
12. **DIVISION**: Operador específico de DES
13. **Operaciones Aritméticas**
14. **Alias y RENAME**
15. **Consultas Complejas**
16. **Buenas Prácticas**
17. **Orden de Ejecución SQL**
18. **Ejemplos Prácticos**

## Compilación

Para recompilar el PDF desde el código fuente LaTeX:

```bash
pdflatex resumen_sql.tex
```

## Basado en

- PRACTICA 3 (datos.sql): Sintaxis DES utilizada en el curso
- Presentación BD03: Lenguajes de bases de datos SQL
