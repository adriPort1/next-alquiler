/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/ClientSide/javascript.js to edit this template
 */


// lib/db.js
import { createConnection } from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

const { localhost, root, alquilerportatiles } = process.env;

const connection = await createConnection({
  host: localhost,
  user: root,
  password: "",
  database: alquilerportatiles,
});

export default connection;
