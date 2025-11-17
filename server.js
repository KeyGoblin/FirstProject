const express = require('express');
const path = require('path');
const mysql = require('mysql2/promise');

const app = express();

// Раздаём статику из папки public (index.html, gif и т.д.)
app.use(express.static(path.join(__dirname, 'public')));

// Подключение к БД MySQL
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',           // свой логин
  password: 'KeyGoblin-25', // свой пароль к MySQL
  database: 'mercedes_db'
});

// ----------- API: рекомендация нового авто -----------
// GET /api/recommend?model=E220&chassis=W211
app.get('/api/recommend', async (req, res) => {
  try {
    const { model, chassis } = req.query;

    if (!model || !chassis) {
      return res.status(400).json({ error: 'model and chassis are required' });
    }

    const [rows] = await pool.query(
      `
      SELECT
        old.series            AS old_series,
        old.model             AS old_model,
        old.chassis_code      AS old_chassis,
        tiv.value_usd         AS trade_in_value,
        newm.series           AS new_series,
        newm.model            AS new_model,
        newm.chassis_code     AS new_chassis,
        newm.price_usd        AS new_price,
        newm.image_url        AS new_image_url,
        (newm.price_usd - tiv.value_usd) AS upgrade_cost
      FROM cars AS old
      JOIN trade_in_values AS tiv ON tiv.car_id = old.id
      JOIN cars AS newm
        ON newm.model = old.model
       AND newm.generation > old.generation
      WHERE old.model = ? AND old.chassis_code = ?
      ORDER BY newm.generation ASC
      LIMIT 1
      `,
      [model, chassis]
    );

    if (rows.length === 0) {
      return res.json(null);
    }

    res.json(rows[0]);
  } catch (err) {
    console.error('Error in /api/recommend:', err);
    res.status(500).json({ error: 'server error' });
  }
});

// ----------- API: альтернатива в бюджет -----------
// GET /api/alternative?budget=20000
app.get('/api/alternative', async (req, res) => {
  try {
    const budget = Number(req.query.budget || 0);

    const [rows] = await pool.query(
      `
      SELECT series, model, chassis_code, price_usd, image_url
      FROM cars
      WHERE price_usd <= ?
      ORDER BY price_usd DESC
      LIMIT 1
      `,
      [budget]
    );

    if (rows.length === 0) {
      return res.json(null);
    }

    res.json(rows[0]);
  } catch (err) {
    console.error('Error in /api/alternative:', err);
    res.status(500).json({ error: 'server error' });
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
