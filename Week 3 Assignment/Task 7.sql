WITH Numbers AS (
    SELECT 2 AS num
    UNION ALL
    SELECT num + 1
    FROM Numbers
    WHERE num < 10
),
Primes AS (
    SELECT num
    FROM Numbers n
    WHERE NOT EXISTS (
        SELECT 1
        FROM Numbers m
        WHERE m.num < n.num
        AND n.num % m.num = 0
    )
)
SELECT STRING_AGG(CAST(num AS VARCHAR), '&') AS primes
FROM Primes
OPTION (MAXRECURSION 0);