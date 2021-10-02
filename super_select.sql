--Решал такое на курсе, хочу показать, что могу в крутые SQL запросы, а то мне не верят почему-то. В конце концов всегда можно погуглить.
--Менеджер авиаперевозчика готовит ресерч. Он хочет выявить связь между числом полётов, типом самолётов и календарём всяких музыкальных фестивалей. 
--Нужно помочь собрать нужные данные.

--Описание данных
/*В вашем распоряжении база данных об авиаперевозках.
Таблица airports — информация об аэропортах:

    airport_code — трёхбуквенный код аэропорта
    airport_name — название аэропорта
    city — город
    timezone — временная зона

Таблица aircrafts — информация о самолётах:

    aircraft_code — код модели самолёта
    model — модель самолёта
    range — дальность полёта

Таблица tickets — информация о билетах:

    ticket_no — уникальный номер билета
    passenger_id — персональный идентификатор пассажира
    passenger_name — имя и фамилия пассажира

Таблица flights — информация о рейсах:

    flight_id — уникальный идентификатор рейса
    departure_airport — аэропорт вылета
    departure_time — дата и время вылета
    arrival_airport — аэропорт прилёта
    arrival_time — дата и время прилёта
    aircraft_code — id самолёта

Таблица ticket_flights — стыковая таблица «рейсы-билеты»

    ticket_no — номер билета
    flight_id — идентификатор рейса

Таблица festivals — информация о фестивалях

    festival_id — уникальный номер фестиваля
    festival_date — дата проведения фестиваля
    festival_city — город проведения фестиваля
    festival_name — название фестиваля */

/*В какой то момент ставят задачу:
Для каждой недели с 23 июля по 30 сентября 2018 года посчитайте билеты, которые купили на рейсы в Москву (номер недели week_number и количество билетов ticket_amount). Получите таблицу:

    - с количеством купленных за неделю билетов;
    - отметкой, проходил ли в эту неделю фестиваль;
    - название фестиваля festival_name;
    - номер недели week_number.

Выводите столбцы в таком порядке: - week_number - ticket_amount - festival_week - festival_name.
*/

-- В итоге выполнил вот так:

SELECT
    T.week_number,
    T.ticket_amount,
    T.festival_week,
    T.festival_name

FROM (
    
    (
        SELECT
            EXTRACT(week FROM flights.departure_time) AS week_number,
            COUNT(ticket_flights.ticket_no) AS ticket_amount
        FROM
            airports
            INNER JOIN flights ON airports.airport_code = flights.arrival_airport
            INNER JOIN ticket_flights ON flights.flight_id = ticket_flights.flight_id
        WHERE
            airports.city = 'Москва'
            AND CAST(flights.departure_time AS date) BETWEEN '2018-07-23' AND '2018-09-30'
        GROUP BY
            week_number) as t
    
    
    LEFT JOIN (
        SELECT
            festival_name,
            EXTRACT(week FROM festivals.festival_date) AS festival_week
        FROM
            festivals
        WHERE
            festival_city = 'Москва'
            AND CAST(festivals.festival_date AS date) BETWEEN '2018-07-23' AND '2018-09-30') t2 ON t.week_number = t2.festival_week
        ) AS T;
