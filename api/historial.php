<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require __DIR__ . '/db.php';

$stmt = $pdo->prepare("SELECT hc.id, hc.fecha_consulta, hc.diagnostico, hc.tratamiento, hc.receta, CONCAT(m.nombre,' ',m.apellido) AS medico, e.nombre AS especialidad FROM historial_clinico hc JOIN medicos m ON hc.medico_id = m.id JOIN turnos t ON hc.turno_id = t.id JOIN especialidades e ON t.especialidad_id = e.id WHERE hc.paciente_id = ? ORDER BY hc.fecha_consulta DESC");
$stmt->execute([$_GET['paciente_id']]);
echo json_encode($stmt->fetchAll());
?>