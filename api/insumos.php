<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require __DIR__ . '/db.php';

$stmt = $pdo->query("SELECT id, codigo, nombre, categoria, unidad, stock_actual, stock_minimo, precio_unitario, proveedor FROM insumos WHERE activo = 1 ORDER BY categoria, nombre");
echo json_encode($stmt->fetchAll());
?>