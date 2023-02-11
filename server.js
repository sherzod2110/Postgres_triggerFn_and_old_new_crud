import pg from 'pg';
import express from 'express';

const app = express();
app.use(express.json())

const { Pool } = pg;

const pool = new Pool({
    connectionString: 'postgres://postgres:sherzod2110@localhost:5432/n37'
});

app.get('/products', async (req, res) => {   
    const client = await pool.connect();

  const { rows } = await client.query(`
     select * from products;
  `)
  client.release(); 
  res.json(rows)
})

app.get('/arxivGetCreateProducts', async (req, res) => {
    const client = await pool.connect();

  const { rows } = await client.query(`
     select * from arxiv_create_products;
  `)
  client.release();
  res.json(rows)
})

app.get('/arxivGetDeleteProducts', async (req, res) => {
    const client = await pool.connect();

  const { rows } = await client.query(`
     select * from arxiv_delete_products;
  `)
  client.release();
  res.json(rows)
})

app.get('/arxivGetUpdateProducts', async (req, res) => {
    const client = await pool.connect();

  const { rows } = await client.query(`
     select * from arxiv_update_products;
  `)
  client.release();
  res.json(rows)
})

app.post('/postProduct', async (req, res) => {
  const { product_title, product_price } = req.body

    const client = await pool.connect();

  const { rows } = await client.query(`
        insert into products(product_title, product_price) values($1, $2);
  `,[product_title, product_price]) 
  client.release(); 
  res.json(rows)
})

app.delete('/deleteProduct/:id', async (req, res) => {
    const { id } = req.params

  
      const client = await pool.connect();
  
    const { rows } = await client.query(`
         delete from products where product_id = $1 
    `,[id]) 
    client.release(); 
    res.json(rows)
  })

  app.put('/updateProduct/:id', async (req, res) => {
    const { id } = req.params
    const { product_title, product_price } = req.body
  
  
    const client = await pool.connect()
    const { rows } = await client.query('update products set product_title = $1, product_price = $2 where product_id = $3', [product_title, product_price, id])
    client.release()
  
    res.send('ok') 
  })

app.all('/*', (req, res) => {
    res.json(404).json({
        message: req.url + ' not found', 
        status: 404
    })
})

app.listen(9090, console.log(9090))