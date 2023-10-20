
-- EXOS FACILES AJOUTÉ

-- Liste des titres de films
 SELECT title FROM film


-- Nombre de films par catégorie revoir :
SELECT category.name, COUNT(film_category.film_id) 
FROM film
JOIN film_category ON film.film_id = film_category.film_id 
JOIN category ON film_category.category_id = category.category_id
GROUP BY film_category.category_id
;

-- CORRECTION :


-- Liste des films dont la durée est supérieure à 120 minutes
SELECT title, film."length" 
FROM film
WHERE film."length" > 119
;
-- CORRECTION :



-- Liste des films de catégorie "Action" ou "Comedy"
SELECT c.category_id, title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id 
JOIN category c ON fc.category_id = c.category_id
WHERE fc.category_id = "1"

-- CORRECTION :
;


-- Nombre total de films (définissez l'alias 'nombre de film' pour la valeur calculée)
SELECT COUNT(film_id) AS total_films
FROM film
;

-- CORRECTION :


-- Les notes moyennes par catégorie
SELECT c.name, ROUND(AVG(f.rental_rate), 2)
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id 
JOIN category c ON fc.category_id = c.category_id
GROUP BY fc.category_id
;

-- CORRECTION :



-- SUITE EXOS :


-- Liste des 10 films les plus loués. (SELECT, JOIN, GROUP BY, ORDER BY, LIMIT)
SELECT f.title, COUNT(r.rental_id) AS total_rental_by_films 
FROM rental r 
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY total_rental_by_films DESC
LIMIT 10
;

-- CORRECTION :


-- Acteurs ayant joué dans le plus grand nombre de films. (JOIN, GROUP BY, ORDER BY, LIMIT)
SELECT a.first_name, a.last_name, f.film_id
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id 
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY a.first_name , a.last_name
ORDER BY fa.film_id DESC
LIMIT 10
;

-- CORRECTION :


-- (ajout exo) Revenu total généré par mois
SELECT SUM(p.amount) AS total_incomes, STRFTIME("%Y-%m", p.payment_date) AS sorted_by_month
FROM payment p
GROUP BY sorted_by_month
;

-- CORRECTION :



-- Revenu total généré par chaque magasin par mois pour l'année en cours. (JOIN, SUM, GROUP BY, DATE functions)
SELECT s2.store_id, SUM(p.amount), STRFTIME("%Y", p.payment_date) AS years
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
JOIN store s2 ON s.staff_id = s2.manager_staff_id 
WHERE years = '2006'
GROUP BY years, p.staff_id
;

-- (modif exo) Revenu total généré par chaque magasin par mois pour l'année 2005. (JOIN, SUM, GROUP BY, DATE functions)
SELECT s2.store_id, SUM(p.amount) AS sum_stores, STRFTIME("%Y-%m", p.payment_date) AS sorted_by_month_and_year
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
JOIN store s2 ON s.staff_id = s2.manager_staff_id
WHERE sorted_by_month_and_year LIKE "2005-__"
GROUP BY sorted_by_month_and_year, p.staff_id
ORDER BY s2.store_id
;

-- CORRECTION :



-- Les clients les plus fidèles, basés sur le nombre de locations. (SELECT, COUNT, GROUP BY, ORDER BY)
SELECT r.rental_id, r.customer_id
FROM rental r 
GROUP BY r.customer_id
ORDER BY r.rental_id DESC
;

-- CORRECTION :



-- (Amélioré avec le nom des clients)
SELECT r.rental_id, r.customer_id, c.first_name, c.last_name 
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY r.customer_id
ORDER BY r.rental_id DESC
;

-- CORRECTION :



-- Films qui n'ont pas été loués au cours des 6 derniers mois. (LEFT JOIN, WHERE, DATE functions, Sub-query) 
SELECT f.title, COUNT(r.rental_id) AS total_not_rental 
FROM rental r 
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE f.film_id IS NULL (
	SELECT f.film_id
	FROM rental
	WHERE rental_date > DATE('2006-02-14', '-6 months')
); 
-- => PAS TROUVÉ, À REVOIR !
-- test
--SELECT payment_id, amount, payment_date 
--FROM payment p
--WHERE payment_date > DATE('2006-02-14', '-6 months');

-- CORRECTION :



-- Le revenu total de chaque membre du personnel à partir des locations. (JOIN, GROUP BY, ORDER BY, SUM)
SELECT s.staff_id, s.first_name, SUM(p.amount) AS total_incomes_staff 
FROM rental r 
LEFT JOIN payment p ON r.rental_id = p.rental_id
LEFT JOIN staff s ON p.staff_id = s.staff_id
GROUP BY s.staff_id
ORDER BY total_incomes_staff
;

-- CORRECTION :



-- Catégories de films les plus populaires parmi les clients. (JOIN, GROUP BY, ORDER BY, LIMIT)
SELECT c.name, COUNT(r.rental_id) AS nb_rental_by_cat
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id  
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id 
JOIN rental r ON i.inventory_id = r.inventory_id 
JOIN customer c2 ON r.customer_id = c2.customer_id
GROUP BY c.name
ORDER BY nb_rental_by_cat DESC
;

-- CORRECTION :



-- Durée moyenne entre la location d'un film et son retour. (SELECT, AVG, DATE functions)
SELECT ROUND(AVG(JULIANDAY(return_date) - JULIANDAY(rental_date))) AS moyenne
FROM rental
;

-- CORRECTION :




-- Acteurs qui ont joué ensemble dans le plus grand nombre de films. Afficher l'acteur 1, l'acteur 2 et le nombre de films en commun. 
-- Trier les résultats par ordre décroissant. Attention aux répétitons. (JOIN, GROUP BY, ORDER BY, Self-join)
SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title
FROM film_actor AS fa1
-- voir pour démarrer de 'film_actor' pluôt, et faire un LEFT JOIN avec 'actor' et un RIGHT JOIN ou si marche par JOIN vers 'film'.
-- Bref on se met sur la TABLE du centre plutôt. Puis on poursuit avec un OUTER JOIN vers film_actor => fa1 et fa2 du coup
-- Voir si GROUP et ORDER peuvent se placer après ou voir comment faire pour mettre avant.
LEFT JOIN actor a ON fa1.actor_id = a.actor_id
RIGHT JOIN film f ON fa1.film_id = f.film_id
JOIN film_actor AS fa2 ON fa1.film_id = fa2.film_id 
GROUP BY a.actor_id
ORDER BY f.film_id ASC
;
-- => PAS TROUVÉ, À REVOIR !

-- CORRECTION :



-- Bonus 1 :
-- Clients qui ont loué des films mais n'ont pas fait au moins une location dans les 30 jours qui suivent. 
-- (JOIN, WHERE, DATE functions, Sub-query)
SELECT c.customer_id, r.rental_id
FROM customer c 
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_id IS (
	SELECT rental_id
	FROM rental
	WHERE rental_date > DATE('2006-02-14', '-30 days')
);

-- CORRECTION :


-- Refaite la même question pour un interval de 15 jours pour le mois d'août 2005.
SELECT c.customer_id, r.rental_id
FROM customer c 
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_id IS (
	SELECT rental_id
	FROM rental
	WHERE rental_date > DATE('2005-08', '-15 days')
);

-- COORECTION :


-- BONUS FINAL : altérer votre BDD avec les requêtes suivantes :
--Ajoutez un nouveau film dans la base de données. Ce film est intitulé "Sunset Odyssey", est sorti en 2023, dure 125 minutes et appartient à la catégorie "Drama".
-- sinon faire sur 'film_category'
INSERT INTO film (film_id, title, release_year, language_id, 'length', last_update)
VALUES (1001, 'Sunset Odyssey', 2023, 1, 125, DATE('now'));

INSERT INTO film_category (film_id, category_id, last_update)
VALUES (1001, 7, DATE('now'));

--Mettez à jour le film intitulé "Sunset Odyssey" pour qu'il appartienne à la catégorie (j'ai changé) "Action"
UPDATE film_category 
SET category_id  = 1
WHERE film_id = 1001;
--DELETE FROM film WHERE title = 'Sunset Odyssey';










