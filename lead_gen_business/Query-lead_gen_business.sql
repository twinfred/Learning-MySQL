SELECT * FROM clients;
SELECT * FROM billing;
SELECT * FROM leads;
SELECT * FROM sites;
-- 1. What query would you run to get the total revenue for March of 2012?
SELECT SUM(amount)
FROM clients
LEFT JOIN billing ON clients.client_id = billing.client_id
WHERE charged_datetime BETWEEN '2012-03-01 00:00:00' AND '2012-04-01 00:00:00';

-- 2. What query would you run to get total revenue collected from the client with an id of 2?
SELECT SUM(amount)
FROM clients
LEFT JOIN billing ON clients.client_id = billing.client_id
WHERE clients.client_id = 2;

-- 3. What query would you run to get all the sites that client=10 owns?
SELECT sites.domain_name
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
WHERE clients.client_id = 10;

-- 4. What query would you run to get total # of sites created per month per year for the client with an id of 1?
-- What about for client=20?
SELECT DATE_FORMAT(sites.created_datetime, '%M') AS month_created, DATE_FORMAT(sites.created_datetime, '%Y') AS year_created, COUNT(sites.created_datetime) AS num_sites_created
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
WHERE clients.client_id = 1
GROUP BY DATE_FORMAT(sites.created_datetime, '%M %Y')
ORDER BY year_created DESC;

-- 5. What query would you run to get the total # of leads generated for each of the sites between January 1, 2011 to February 15, 2011?
SELECT sites.domain_name, COUNT(leads.leads_id) AS lead_count, DATE_FORMAT(created_datetime, '%M %d, %Y') AS date_generated
FROM sites
LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE registered_datetime BETWEEN '2011-01-01 00:00:00' AND '2011-02-16 00:00:00'
GROUP BY sites.domain_name;

-- 6. What query would you run to get a list of client names and the total # of leads we've
-- generated for each of our clients between January 1, 2011 to December 31, 2011?
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, COUNT(leads.leads_id) AS leads_generated
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
GROUP BY sites.domain_name
ORDER BY leads_generated DESC;

-- 7. What query would you run to get a list of client names and the total # of leads we've
-- generated for each client each month between months 1 - 6 of Year 2011?
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, DATE_FORMAT(registered_datetime, '%M %Y') month_year_generated, COUNT(leads.leads_id) AS leads_generated
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE registered_datetime BETWEEN '2011-01-01 00:00:00' AND '2011-07-01 00:00:00'
GROUP BY sites.domain_name
ORDER BY leads_generated DESC;

-- 8. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients' sites
-- between January 1, 2011 to December 31, 2011? Order this query by client id.
-- Come up with a second query that shows all the clients, the site name(s), and the total number of leads generated from each site for all time.
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, sites.domain_name, COUNT(leads.leads_id) AS leads_generated
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE registered_datetime BETWEEN '2011-01-01 00:00:00' AND '2012-12-01 00:00:00'
GROUP BY sites.domain_name
ORDER BY clients.client_id ASC;

SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, sites.domain_name, COUNT(leads.leads_id) AS leads_generated
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
GROUP BY sites.domain_name
ORDER BY clients.client_id ASC;

-- 9. Write a single query that retrieves total revenue collected from each client for each month of the year. Order it by client id.
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, SUM(billing.amount), DATE_FORMAT(billing.charged_datetime, '%M') AS charge_month, DATE_FORMAT(billing.charged_datetime, '%Y') AS charge_year
FROM clients
LEFT JOIN billing ON clients.client_id = billing.client_id
GROUP BY billing.charged_datetime
ORDER BY clients.client_id ASC;

-- 10. Write a single query that retrieves all the sites that each client owns. Group the results so that each row shows a new client.
-- It will become clearer when you add a new field called 'sites' that has all the sites that the client owns. (HINT: use GROUP_CONCAT)
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, GROUP_CONCAT(sites.domain_name separator ', ') AS sites
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
GROUP BY client_name
ORDER BY clients.client_id ASC;