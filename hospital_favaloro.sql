-- MariaDB dump 10.19  Distrib 10.4.22-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: hospital_favaloro
-- ------------------------------------------------------
-- Server version	10.4.22-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `especialidades`
--

DROP TABLE IF EXISTS `especialidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `especialidades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `activa` tinyint(1) DEFAULT 1,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `especialidades`
--

LOCK TABLES `especialidades` WRITE;
/*!40000 ALTER TABLE `especialidades` DISABLE KEYS */;
INSERT INTO `especialidades` VALUES (1,'Traumatología','Lesiones y enfermedades del sistema musculoesquelético',1,'2026-05-11 23:35:31'),(2,'Neurología','Enfermedades del sistema nervioso central y periférico',1,'2026-05-11 23:35:31'),(3,'Oncología','Diagnóstico y tratamiento del cáncer',1,'2026-05-11 23:35:31'),(4,'Ginecología','Salud femenina y obstetricia',1,'2026-05-11 23:35:31'),(5,'Oftalmología','Enfermedades de los ojos y la visión',1,'2026-05-11 23:35:31'),(6,'Otorrinolaringología','Enfermedades de oído, nariz y garganta',1,'2026-05-11 23:35:31'),(7,'Endocrinología','Trastornos hormonales y metabólicos',1,'2026-05-11 23:35:31'),(8,'Gastroenterología','Enfermedades del sistema digestivo',1,'2026-05-11 23:35:31'),(9,'Reumatología','Enfermedades autoinmunes y articulares',1,'2026-05-11 23:35:31'),(10,'Urología','Sistema urinario y reproductivo masculino',1,'2026-05-11 23:35:31'),(11,'Psiquiatría','Salud mental y trastornos psiquiátricos',1,'2026-05-11 23:35:31'),(12,'Hematología','Enfermedades de la sangre y médula ósea',1,'2026-05-11 23:35:31'),(13,'Nefrología','Enfermedades de los riñones',1,'2026-05-11 23:35:31'),(14,'Neumología','Enfermedades del sistema respiratorio',1,'2026-05-11 23:35:31'),(15,'Infectología','Enfermedades infecciosas y tropicales',1,'2026-05-11 23:35:31'),(16,'Cirugía General','Procedimientos quirúrgicos del abdomen y tejidos blandos',1,'2026-05-11 23:35:31'),(17,'Anestesiología','Sedación y control del dolor en cirugías',1,'2026-05-11 23:35:31'),(18,'Nutrición','Trastornos nutricionales y alimentación clínica',1,'2026-05-11 23:35:31'),(19,'Medicina del Trabajo','Salud ocupacional y enfermedades laborales',1,'2026-05-11 23:35:31'),(20,'Geriatría','Atención médica integral del adulto mayor',1,'2026-05-11 23:35:31'),(21,'Cardiología','Enfermedades del corazón',1,'2026-05-11 23:45:25'),(22,'Clínica Médica','Atención integral del adulto',1,'2026-05-11 23:45:25'),(23,'Dermatología','Enfermedades de la piel',1,'2026-05-11 23:45:25'),(24,'Pediatría','Atención de niños y adolescentes',1,'2026-05-11 23:45:25');
/*!40000 ALTER TABLE `especialidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_clinico`
--

DROP TABLE IF EXISTS `historial_clinico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `historial_clinico` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `turno_id` int(11) NOT NULL,
  `paciente_id` int(11) NOT NULL,
  `medico_id` int(11) NOT NULL,
  `fecha_consulta` date NOT NULL,
  `diagnostico` text NOT NULL,
  `tratamiento` text DEFAULT NULL,
  `receta` text DEFAULT NULL,
  `proxima_cita` date DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `turno_id` (`turno_id`),
  KEY `paciente_id` (`paciente_id`),
  KEY `medico_id` (`medico_id`),
  CONSTRAINT `historial_clinico_ibfk_1` FOREIGN KEY (`turno_id`) REFERENCES `turnos` (`id`),
  CONSTRAINT `historial_clinico_ibfk_2` FOREIGN KEY (`paciente_id`) REFERENCES `pacientes` (`id`),
  CONSTRAINT `historial_clinico_ibfk_3` FOREIGN KEY (`medico_id`) REFERENCES `medicos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_clinico`
--

LOCK TABLES `historial_clinico` WRITE;
/*!40000 ALTER TABLE `historial_clinico` DISABLE KEYS */;
INSERT INTO `historial_clinico` VALUES (51,51,1,1,'2026-05-20','Hipertension arterial estadio 1','Reduccion de sodio y actividad fisica moderada','Enalapril 10mg - 1 comprimido por dia en ayunas',NULL,'2026-05-12 00:00:21'),(52,52,2,2,'2026-05-20','Control pediatrico anual','Sin novedades, desarrollo normal','No requiere medicacion',NULL,'2026-05-12 00:00:21'),(53,53,3,3,'2026-05-20','Gastritis cronica','Dieta blanda, evitar picantes y alcohol','Omeprazol 20mg - 1 capsula antes del desayuno por 30 dias',NULL,'2026-05-12 00:00:21'),(54,54,4,4,'2026-05-20','Rinitis alergica','Evitar exposicion a alergenos','Loratadina 10mg - 1 comprimido por dia',NULL,'2026-05-12 00:00:21'),(55,55,5,5,'2026-05-20','Dermatitis seborreica','Higiene con jabon neutro','Ketoconazol shampoo - uso bisemanal por 4 semanas',NULL,'2026-05-12 00:00:21'),(56,56,6,6,'2026-05-20','Lumbalgia mecanica','Reposo relativo y fisioterapia','Ibuprofeno 400mg - 1 comprimido cada 8hs por 5 dias',NULL,'2026-05-12 00:00:21'),(57,57,7,7,'2026-05-20','Infeccion urinaria baja','Hidratacion abundante','Ciprofloxacina 500mg - 1 comprimido cada 12hs por 7 dias',NULL,'2026-05-12 00:00:21'),(58,58,8,8,'2026-05-20','Otitis media aguda','Calor local en oido','Amoxicilina 500mg - 1 capsula cada 8hs por 7 dias',NULL,'2026-05-12 00:00:21'),(59,59,9,9,'2026-05-20','Esguince de tobillo grado 1','Reposo y hielo local 20 minutos cada 4hs','Ibuprofeno 600mg - 1 comprimido cada 8hs por 5 dias',NULL,'2026-05-12 00:00:21'),(60,60,10,10,'2026-05-20','Cervicalgia tensional','Ejercicios de estiramiento cervical','Diclofenac 50mg - 1 comprimido cada 12hs por 5 dias',NULL,'2026-05-12 00:00:21'),(61,61,11,11,'2026-05-21','Migraña cronica','Reducir estres y mejorar higiene del sueno','Sumatriptan 50mg - tomar al inicio del dolor',NULL,'2026-05-12 00:00:21'),(62,62,12,12,'2026-05-21','Anemia ferropenica leve','Dieta rica en hierro','Sulfato ferroso 325mg - 1 comprimido por dia con vitamina C',NULL,'2026-05-12 00:00:21'),(63,63,13,13,'2026-05-21','Linfoma en estudio','Derivacion a oncologia para biopsia','Pendiente resultado de estudios',NULL,'2026-05-12 00:00:21'),(64,64,14,14,'2026-05-21','Cancer de mama estadio 2','Inicio de quimioterapia adyuvante','Protocolo AC-T segun oncologia',NULL,'2026-05-12 00:00:21'),(65,65,15,15,'2026-05-21','Control ginecologico anual','Papanicolaou y colposcopia realizados','No requiere medicacion',NULL,'2026-05-12 00:00:21'),(66,66,16,16,'2026-05-21','Embarazo 12 semanas','Control prenatal normal','Acido folico 5mg - 1 comprimido por dia',NULL,'2026-05-12 00:00:21'),(67,67,17,17,'2026-05-21','Conjuntivitis bacteriana','Limpieza ocular con suero fisiologico','Tobramicina colirio - 1 gota cada 4hs por 7 dias',NULL,'2026-05-12 00:00:21'),(68,68,18,18,'2026-05-21','Glaucoma cronico simple','Control de presion intraocular mensual','Timolol 0.5% colirio - 1 gota cada 12hs',NULL,'2026-05-12 00:00:21'),(69,69,19,19,'2026-05-21','Sinusitis aguda','Lavados nasales con suero fisiologico','Amoxicilina 875mg - 1 comprimido cada 12hs por 10 dias',NULL,'2026-05-12 00:00:21'),(70,70,20,20,'2026-05-21','Hipotiroidismo primario','Control de TSH en 3 meses','Levotiroxina 100mcg - 1 comprimido en ayunas',NULL,'2026-05-12 00:00:21'),(71,71,1,21,'2026-05-22','Diabetes tipo 2 compensada','Dieta hipocalorica y ejercicio aerobico','Metformina 850mg - 1 comprimido con almuerzo y cena',NULL,'2026-05-12 00:00:21'),(72,72,2,22,'2026-05-22','Colon irritable','Dieta baja en FODMAP','Mebeverina 135mg - 1 comprimido 20 minutos antes de las comidas',NULL,'2026-05-12 00:00:21'),(73,73,3,23,'2026-05-22','Artritis reumatoidea','Fisioterapia y proteccion articular','Metotrexato 7.5mg - 1 vez por semana con acido folico',NULL,'2026-05-12 00:00:21'),(74,74,4,24,'2026-05-22','Insuficiencia renal cronica estadio 2','Dieta hipoprotéica y control de presion','Enalapril 5mg - 1 comprimido por dia',NULL,'2026-05-12 00:00:21'),(75,75,5,25,'2026-05-22','Asma bronquial leve','Evitar desencadenantes y humo','Salbutamol inhalador - 2 puffs ante broncoespasmo',NULL,'2026-05-12 00:00:21'),(76,76,6,26,'2026-05-22','Lupus eritematoso sistemico','Proteccion solar y control reumatologico','Hidroxicloroquina 200mg - 1 comprimido por dia',NULL,'2026-05-12 00:00:21'),(77,77,7,27,'2026-05-22','Litiasis renal','Hidratacion 2 litros diarios y dieta baja en oxalatos','Tamsulosina 0.4mg - 1 comprimido por dia',NULL,'2026-05-12 00:00:21'),(78,78,8,28,'2026-05-22','Hiperplasia prostatica benigna','Control urologico semestral','Finasteride 5mg - 1 comprimido por dia',NULL,'2026-05-12 00:00:21'),(79,79,9,29,'2026-05-22','Trastorno de ansiedad generalizada','Psicoterapia cognitivo conductual','Sertralina 50mg - 1 comprimido por dia por la manana',NULL,'2026-05-12 00:00:21'),(80,80,10,30,'2026-05-22','Depresion mayor episodio moderado','Psicoterapia y seguimiento psiquiatrico mensual','Escitalopram 10mg - 1 comprimido por dia',NULL,'2026-05-12 00:00:21'),(81,81,11,99,'2026-05-23','Bronquitis aguda','Reposo e hidratacion','Amoxicilina 500mg - 1 capsula cada 8hs por 7 dias',NULL,'2026-05-12 00:00:21'),(82,82,12,100,'2026-05-23','Neumonia leve ambulatoria','Reposo domiciliario y control en 48hs','Azitromicina 500mg - 1 comprimido por dia por 5 dias',NULL,'2026-05-12 00:00:21'),(83,83,13,101,'2026-05-23','COVID-19 leve','Aislamiento 5 dias y antipireticos','Paracetamol 1g - 1 comprimido cada 6hs si fiebre',NULL,'2026-05-12 00:00:21'),(84,84,14,102,'2026-05-23','Dengue sin signos de alarma','Hidratacion y reposo estricto','Paracetamol 500mg - no usar ibuprofeno ni aspirina',NULL,'2026-05-12 00:00:21'),(85,85,15,103,'2026-05-23','Hernia inguinal derecha','Programar cirugia electiva','Ibuprofeno 400mg para el dolor hasta la cirugia',NULL,'2026-05-12 00:00:21'),(86,86,16,104,'2026-05-23','Apendicitis aguda','Internacion urgente para apendicectomia','Ceftriaxona 1g IV preoperatorio',NULL,'2026-05-12 00:00:21'),(87,87,17,105,'2026-05-23','Fractura de muneca izquierda','Inmovilizacion con yeso por 4 semanas','Ibuprofeno 600mg - 1 comprimido cada 8hs',NULL,'2026-05-12 00:00:21'),(88,88,18,106,'2026-05-23','Luxacion de hombro derecho','Reduccion bajo sedacion y cabestrillo 3 semanas','Ketorolac 10mg - 1 comprimido cada 8hs por 5 dias',NULL,'2026-05-12 00:00:21'),(89,89,19,107,'2026-05-23','Obesidad grado 1','Plan nutricional hipocalorico 1500kcal','Suplemento proteico y multivitaminico diario',NULL,'2026-05-12 00:00:21'),(90,90,20,108,'2026-05-23','Desnutricion leve','Dieta hipercalorica e hiperproteica','Suplemento Ensure - 2 unidades por dia',NULL,'2026-05-12 00:00:21'),(91,91,1,109,'2026-05-26','Enfermedad profesional por stress','Reduccion de carga laboral y tecnicas de relajacion','Clonazepam 0.5mg - 1 comprimido antes de dormir',NULL,'2026-05-12 00:00:21'),(92,92,2,110,'2026-05-26','Hipoacusia laboral bilateral','Uso obligatorio de proteccion auditiva','Derivacion a otorrinolaringologia',NULL,'2026-05-12 00:00:21'),(93,93,3,111,'2026-05-26','Deterioro cognitivo leve','Estimulacion cognitiva y actividad social','Donepezilo 5mg - 1 comprimido por dia',NULL,'2026-05-12 00:00:21'),(94,94,4,112,'2026-05-26','Osteoporosis severa','Suplementacion y ejercicio de impacto','Alendronato 70mg - 1 comprimido semanal en ayunas',NULL,'2026-05-12 00:00:21'),(95,95,5,113,'2026-05-26','Hipercolesterolemia','Dieta baja en grasas saturadas','Atorvastatina 20mg - 1 comprimido por noche',NULL,'2026-05-12 00:00:21'),(96,96,6,114,'2026-05-26','Control pediatrico 2 anos','Desarrollo psicomotor acorde a la edad','Vitamina D 400 UI - gotas diarias',NULL,'2026-05-12 00:00:21'),(97,97,7,115,'2026-05-26','Leucemia mieloide cronica','Inicio de tratamiento con inhibidores de tirosina quinasa','Imatinib 400mg - 1 comprimido por dia con comida',NULL,'2026-05-12 00:00:21'),(98,98,8,116,'2026-05-26','Trombocitopenia inmune','Observacion y control hematologico semanal','Prednisona 1mg/kg/dia por 4 semanas',NULL,'2026-05-12 00:00:21'),(99,99,9,117,'2026-05-26','Insuficiencia renal aguda','Internacion para hidratacion IV y monitorizacion','Furosemida 40mg IV segun diuresis',NULL,'2026-05-12 00:00:21'),(100,100,10,118,'2026-05-26','Sindrome nefrotico','Dieta hiposodicae hipoprotéica','Prednisona 60mg por dia por 8 semanas',NULL,'2026-05-12 00:00:21');
/*!40000 ALTER TABLE `historial_clinico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insumos`
--

DROP TABLE IF EXISTS `insumos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `insumos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `categoria` enum('medicamento','material','equipo','otro') NOT NULL,
  `unidad` varchar(30) NOT NULL,
  `stock_actual` decimal(10,2) DEFAULT 0.00,
  `stock_minimo` decimal(10,2) DEFAULT 0.00,
  `precio_unitario` decimal(10,2) DEFAULT NULL,
  `proveedor` varchar(150) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insumos`
--

LOCK TABLES `insumos` WRITE;
/*!40000 ALTER TABLE `insumos` DISABLE KEYS */;
INSERT INTO `insumos` VALUES (1,'MED001','Enalapril 10mg','medicamento','comprimido',500.00,100.00,15.50,'Laboratorio Bago',1,'2026-05-11 23:53:01'),(2,'MED002','Ibuprofeno 400mg','medicamento','comprimido',800.00,150.00,8.00,'Roemmers',1,'2026-05-11 23:53:01'),(3,'MED003','Amoxicilina 500mg','medicamento','capsula',300.00,80.00,22.00,'Laboratorio Bago',1,'2026-05-11 23:53:01'),(4,'MED004','Paracetamol 500mg','medicamento','comprimido',1200.00,200.00,6.50,'Roemmers',1,'2026-05-11 23:53:01'),(5,'MED005','Metformina 850mg','medicamento','comprimido',400.00,100.00,18.00,'Beta',1,'2026-05-11 23:53:01'),(6,'MED006','Omeprazol 20mg','medicamento','capsula',600.00,120.00,12.00,'Laboratorio Bago',1,'2026-05-11 23:53:01'),(7,'MED007','Losartan 50mg','medicamento','comprimido',350.00,80.00,20.00,'Roemmers',1,'2026-05-11 23:53:01'),(8,'MED008','Atorvastatina 20mg','medicamento','comprimido',280.00,60.00,35.00,'Pfizer',1,'2026-05-11 23:53:01'),(9,'MED009','Levotiroxina 100mcg','medicamento','comprimido',200.00,50.00,45.00,'Montpellier',1,'2026-05-11 23:53:01'),(10,'MED010','Alprazolam 0.5mg','medicamento','comprimido',150.00,40.00,28.00,'Roemmers',1,'2026-05-11 23:53:01'),(11,'MED011','Claritromicina 500mg','medicamento','comprimido',180.00,50.00,55.00,'Abbott',1,'2026-05-11 23:53:01'),(12,'MED012','Dexametasona 4mg','medicamento','ampolla',120.00,30.00,85.00,'Laboratorio Bago',1,'2026-05-11 23:53:01'),(13,'MED013','Adrenalina 1mg','medicamento','ampolla',80.00,20.00,120.00,'Sidus',1,'2026-05-11 23:53:01'),(14,'MED014','Morfina 10mg','medicamento','ampolla',60.00,15.00,200.00,'Laboratorio Bago',1,'2026-05-11 23:53:01'),(15,'MED015','Solucion Fisiologica 500ml','medicamento','frasco',250.00,50.00,350.00,'Laboratorio Rivero',1,'2026-05-11 23:53:01'),(16,'MED016','Dextrosa 5% 500ml','medicamento','frasco',180.00,40.00,380.00,'Laboratorio Rivero',1,'2026-05-11 23:53:01'),(17,'MED017','Heparina 5000 UI','medicamento','ampolla',90.00,25.00,150.00,'Roche',1,'2026-05-11 23:53:01'),(18,'MED018','Insulina Glargina','medicamento','unidad',70.00,20.00,4500.00,'Sanofi',1,'2026-05-11 23:53:01'),(19,'MED019','Salbutamol Inhalador','medicamento','unidad',110.00,30.00,1200.00,'GlaxoSmithKline',1,'2026-05-11 23:53:01'),(20,'MED020','Ondansetron 8mg','medicamento','comprimido',200.00,50.00,42.00,'Roemmers',1,'2026-05-11 23:53:01'),(21,'MAT001','Guantes descartables T/M','material','caja x100',45.00,10.00,1800.00,'MedSupply',1,'2026-05-11 23:53:01'),(22,'MAT002','Guantes descartables T/L','material','caja x100',38.00,10.00,1800.00,'MedSupply',1,'2026-05-11 23:53:01'),(23,'MAT003','Jeringas 5ml','material','unidad',1200.00,200.00,45.00,'MedSupply',1,'2026-05-11 23:53:01'),(24,'MAT004','Jeringas 10ml','material','unidad',900.00,150.00,55.00,'MedSupply',1,'2026-05-11 23:53:01'),(25,'MAT005','Agujas 21G','material','caja x100',60.00,15.00,950.00,'MedSupply',1,'2026-05-11 23:53:01'),(26,'MAT006','Gasas esteriles','material','paquete',300.00,60.00,120.00,'Proveedor ABC',1,'2026-05-11 23:53:01'),(27,'MAT007','Vendas elasticas 10cm','material','unidad',150.00,30.00,280.00,'Proveedor ABC',1,'2026-05-11 23:53:01'),(28,'MAT008','Apositos adhesivos','material','caja x50',80.00,20.00,650.00,'Proveedor ABC',1,'2026-05-11 23:53:01'),(29,'MAT009','Cateter IV 18G','material','unidad',400.00,80.00,180.00,'BD Medical',1,'2026-05-11 23:53:01'),(30,'MAT010','Cateter IV 20G','material','unidad',350.00,70.00,180.00,'BD Medical',1,'2026-05-11 23:53:01'),(31,'MAT011','Mascaras quirurgicas','material','caja x50',120.00,25.00,800.00,'MedSupply',1,'2026-05-11 23:53:01'),(32,'MAT012','Barbijos N95','material','caja x20',55.00,15.00,2400.00,'MedSupply',1,'2026-05-11 23:53:01'),(33,'MAT013','Cofia descartable','material','bolsa x100',40.00,10.00,600.00,'MedSupply',1,'2026-05-11 23:53:01'),(34,'MAT014','Camisolin descartable','material','unidad',200.00,50.00,350.00,'MedSupply',1,'2026-05-11 23:53:01'),(35,'MAT015','Tubo de oxigeno','material','unidad',15.00,4.00,8500.00,'AirLiquide',1,'2026-05-11 23:53:01'),(36,'MAT016','Sonda nasogastrica 16Fr','material','unidad',60.00,15.00,420.00,'BD Medical',1,'2026-05-11 23:53:01'),(37,'MAT017','Bolsa para orina 2L','material','unidad',180.00,40.00,220.00,'BD Medical',1,'2026-05-11 23:53:01'),(38,'MAT018','Equipo de sutura','material','unidad',90.00,20.00,750.00,'Proveedor ABC',1,'2026-05-11 23:53:01'),(39,'MAT019','Esparadrapo 5cm x 5m','material','unidad',110.00,25.00,180.00,'Proveedor ABC',1,'2026-05-11 23:53:01'),(40,'MAT020','Alcohol en gel 500ml','material','frasco',200.00,50.00,450.00,'Proveedor ABC',1,'2026-05-11 23:53:01'),(41,'EQ001','Tensiómetro digital','equipo','unidad',8.00,2.00,35000.00,'Omron',1,'2026-05-11 23:53:01'),(42,'EQ002','Oximetro de pulso','equipo','unidad',15.00,3.00,18000.00,'MedTech',1,'2026-05-11 23:53:01'),(43,'EQ003','Electrocardiografo 12 der','equipo','unidad',3.00,1.00,280000.00,'GE Healthcare',1,'2026-05-11 23:53:01'),(44,'EQ004','Desfibrilador','equipo','unidad',5.00,2.00,450000.00,'Philips',1,'2026-05-11 23:53:01'),(45,'EQ005','Respirador mecanico','equipo','unidad',4.00,1.00,800000.00,'Draeger',1,'2026-05-11 23:53:01'),(46,'EQ006','Bomba de infusion','equipo','unidad',12.00,3.00,120000.00,'BD Medical',1,'2026-05-11 23:53:01'),(47,'EQ007','Glucometro','equipo','unidad',20.00,5.00,15000.00,'Accu-Chek',1,'2026-05-11 23:53:01'),(48,'EQ008','Laringoscopio','equipo','unidad',6.00,2.00,45000.00,'MedTech',1,'2026-05-11 23:53:01'),(49,'EQ009','Ecografo portatil','equipo','unidad',2.00,1.00,1200000.00,'Mindray',1,'2026-05-11 23:53:01'),(50,'EQ010','Monitor de signos vitales','equipo','unidad',7.00,2.00,350000.00,'Philips',1,'2026-05-11 23:53:01');
/*!40000 ALTER TABLE `insumos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicos`
--

DROP TABLE IF EXISTS `medicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medicos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `legajo` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `matricula` varchar(30) NOT NULL,
  `especialidad_id` int(11) NOT NULL,
  `disponibilidad` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`disponibilidad`)),
  `activo` tinyint(1) DEFAULT 1,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `legajo` (`legajo`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `matricula` (`matricula`),
  KEY `especialidad_id` (`especialidad_id`),
  CONSTRAINT `medicos_ibfk_1` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidades` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicos`
--

LOCK TABLES `medicos` WRITE;
/*!40000 ALTER TABLE `medicos` DISABLE KEYS */;
INSERT INTO `medicos` VALUES (1,'M003','Ricardo','Mendez','22111222','rmendez@favaloro.com','1234','1144001111','MN41230',1,NULL,1,'2026-05-11 23:43:24'),(2,'M004','Sofia','Villanueva','29333444','svillanueva@favaloro.com','1234','1144002222','MN52341',1,NULL,1,'2026-05-11 23:43:24'),(3,'M005','Martin','Pereyra','25444555','mpereyra@favaloro.com','1234','1144003333','MN38901',2,NULL,1,'2026-05-11 23:43:24'),(4,'M006','Claudia','Ferreira','31555666','cferreira@favaloro.com','1234','1144004444','MN61234',2,NULL,1,'2026-05-11 23:43:24'),(5,'M007','Valentina','Castro','33666777','vcastro@favaloro.com','1234','1144005555','MN63450',3,NULL,1,'2026-05-11 23:43:24'),(6,'M008','Ignacio','Salinas','26777888','isalinas@favaloro.com','1234','1144006666','MN44567',3,NULL,1,'2026-05-11 23:43:24'),(7,'M009','Florencia','Romero','30888999','fromero@favaloro.com','1234','1144007777','MN58923',4,NULL,1,'2026-05-11 23:43:34'),(8,'M010','Diego','Navarro','27999000','dnavarro@favaloro.com','1234','1144008888','MN47812',4,NULL,1,'2026-05-11 23:43:34'),(9,'M011','Gonzalo','Herrera','24000111','gherrera@favaloro.com','1234','1144009999','MN39876',5,NULL,1,'2026-05-11 23:43:34'),(10,'M012','Natalia','Suarez','32111222','nsuarez@favaloro.com','1234','1144010000','MN62345',5,NULL,1,'2026-05-11 23:43:34'),(11,'M013','Sebastian','Rios','28222333','srios@favaloro.com','1234','1144011111','MN49001',6,NULL,1,'2026-05-11 23:43:34'),(12,'M014','Andrea','Molina','35333444','amolina@favaloro.com','1234','1144012222','MN65432',6,NULL,1,'2026-05-11 23:43:34'),(13,'M015','Hernan','Quiroga','23444555','hquiroga@favaloro.com','1234','1144013333','MN37654',7,NULL,1,'2026-05-11 23:43:40'),(14,'M016','Patricia','Aguirre','36555666','paguirre@favaloro.com','1234','1144014444','MN67890',7,NULL,1,'2026-05-11 23:43:40'),(15,'M017','Marcela','Ibanez','29666777','mibanez@favaloro.com','1234','1144015555','MN51234',8,NULL,1,'2026-05-11 23:43:40'),(16,'M018','Luciana','Paredes','34777888','lparedes@favaloro.com','1234','1144016666','MN64321',8,NULL,1,'2026-05-11 23:43:40'),(17,'M019','Fernando','Acosta','26888999','facosta@favaloro.com','1234','1144017777','MN45678',9,NULL,1,'2026-05-11 23:43:40'),(18,'M020','Gabriela','Medina','31000111','gmedina@favaloro.com','1234','1144018888','MN60987',9,NULL,1,'2026-05-11 23:43:40'),(19,'M021','Pablo','Vega','24111222','pvega@favaloro.com','1234','1144019999','MN40123',10,NULL,1,'2026-05-11 23:43:47'),(20,'M022','Carolina','Soto','37222333','csoto@favaloro.com','1234','1144020000','MN68901',10,NULL,1,'2026-05-11 23:43:47'),(21,'M023','Alejandro','Bravo','25333444','abravo@favaloro.com','1234','1144021111','MN43210',11,NULL,1,'2026-05-11 23:43:47'),(22,'M024','Romina','Cabrera','38444555','rcabrera@favaloro.com','1234','1144022222','MN70123',11,NULL,1,'2026-05-11 23:43:47'),(23,'M025','Nicolas','Sandoval','27555666','nsandoval@favaloro.com','1234','1144023333','MN47890',12,NULL,1,'2026-05-11 23:43:47'),(24,'M026','Veronica','Rojas','32666777','vrojas@favaloro.com','1234','1144024444','MN62109',12,NULL,1,'2026-05-11 23:43:47'),(25,'M027','Gustavo','Figueroa','23777888','gfigueroa@favaloro.com','1234','1144025555','MN38765',13,NULL,1,'2026-05-11 23:43:57'),(26,'M028','Daniela','Moreno','36888999','dmoreno@favaloro.com','1234','1144026666','MN66543',13,NULL,1,'2026-05-11 23:43:57'),(27,'M029','Sergio','Nunez','28000111','snunez@favaloro.com','1234','1144027777','MN50012',14,NULL,1,'2026-05-11 23:43:57'),(28,'M030','Monica','Delgado','33111222','mdelgado@favaloro.com','1234','1144028888','MN63456',14,NULL,1,'2026-05-11 23:43:57'),(29,'M031','Eduardo','Vargas','25222333','evargas@favaloro.com','1234','1144029999','MN44321',15,NULL,1,'2026-05-11 23:43:57'),(30,'M032','Silvana','Campos','38333444','scampos@favaloro.com','1234','1144030000','MN69234',15,NULL,1,'2026-05-11 23:43:57'),(99,'M037','Leandro','Alvarez','22888999','lalvarez@favaloro.com','1234','1144035555','MN37890',14,NULL,1,'2026-05-11 23:48:19'),(100,'M038','Karina','Vera','35000111','kvera@favaloro.com','1234','1144036666','MN66012',14,NULL,1,'2026-05-11 23:48:19'),(101,'M039','Matias','Coronel','29111222','mcoronel@favaloro.com','1234','1144037777','MN52678',15,NULL,1,'2026-05-11 23:48:19'),(102,'M040','Jimena','Ruiz','36222333','jruiz@favaloro.com','1234','1144038888','MN67123',15,NULL,1,'2026-05-11 23:48:19'),(103,'M041','Omar','Leal','24333444','oleal@favaloro.com','1234','1144039999','MN41567',16,NULL,1,'2026-05-11 23:48:19'),(104,'M042','Adriana','Montes','37444555','amontes@favaloro.com','1234','1144040000','MN68234',16,NULL,1,'2026-05-11 23:48:19'),(105,'M043','Hugo','Serrano','25555666','hserrano@favaloro.com','1234','1144041111','MN44890',17,NULL,1,'2026-05-11 23:48:19'),(106,'M044','Valeria','Palacios','38666777','vpalacios@favaloro.com','1234','1144042222','MN70456',17,NULL,1,'2026-05-11 23:48:19'),(107,'M045','Bruno','Carrizo','27777888','bcarrizo@favaloro.com','1234','1144043333','MN49234',18,NULL,1,'2026-05-11 23:48:19'),(108,'M046','Mariana','Ojeda','32888999','mojeda@favaloro.com','1234','1144044444','MN62890',18,NULL,1,'2026-05-11 23:48:19'),(109,'M047','Claudio','Ibarra','23000112','cibarra@favaloro.com','1234','1144045555','MN38012',19,NULL,1,'2026-05-11 23:48:19'),(110,'M048','Susana','Fuentes','36111223','sfuentes@favaloro.com','1234','1144046666','MN66789',19,NULL,1,'2026-05-11 23:48:19'),(111,'M049','Jorge','Maldonado','28222334','jmaldonado@favaloro.com','1234','1144047777','MN51345',20,NULL,1,'2026-05-11 23:48:19'),(112,'M050','Norma','Cardozo','33333445','ncardozo@favaloro.com','1234','1144048888','MN63901',20,NULL,1,'2026-05-11 23:48:19'),(113,'M001','Alberto','Rossi','20123456','doc@favaloro.com','1234','1145001234','MN55432',21,NULL,1,'2026-05-11 23:49:06'),(114,'M002','Elena','Paz','27654321','elenap@favaloro.com','1234','1145009876','MN60112',24,NULL,1,'2026-05-11 23:49:06'),(115,'M033','Ramiro','Espinoza','26444555','respinoza@favaloro.com','1234','1144031111','MN46789',12,NULL,1,'2026-05-11 23:49:06'),(116,'M034','Laura','Benitez','39555666','lbenitez@favaloro.com','1234','1144032222','MN71345',12,NULL,1,'2026-05-11 23:49:06'),(117,'M035','Ariel','Gutierrez','27666777','agutierrez@favaloro.com','1234','1144033333','MN48901',13,NULL,1,'2026-05-11 23:49:06'),(118,'M036','Cecilia','Ponce','34777889','cponce@favaloro.com','1234','1144034444','MN65678',13,NULL,1,'2026-05-11 23:49:06');
/*!40000 ALTER TABLE `medicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimientos_insumos`
--

DROP TABLE IF EXISTS `movimientos_insumos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movimientos_insumos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `insumo_id` int(11) NOT NULL,
  `tipo` enum('entrada','salida','ajuste') NOT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  `stock_previo` decimal(10,2) NOT NULL,
  `stock_posterior` decimal(10,2) NOT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `medico_id` int(11) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `insumo_id` (`insumo_id`),
  KEY `medico_id` (`medico_id`),
  CONSTRAINT `movimientos_insumos_ibfk_1` FOREIGN KEY (`insumo_id`) REFERENCES `insumos` (`id`),
  CONSTRAINT `movimientos_insumos_ibfk_2` FOREIGN KEY (`medico_id`) REFERENCES `medicos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientos_insumos`
--

LOCK TABLES `movimientos_insumos` WRITE;
/*!40000 ALTER TABLE `movimientos_insumos` DISABLE KEYS */;
INSERT INTO `movimientos_insumos` VALUES (1,1,'salida',30.00,500.00,470.00,'Receta turno 51 - Hipertension arterial',1,'2026-05-20 11:30:00'),(2,21,'salida',2.00,500.00,498.00,'Guantes consulta turno 51',1,'2026-05-20 11:30:00'),(3,21,'salida',2.00,498.00,496.00,'Guantes consulta turno 52',2,'2026-05-20 12:30:00'),(4,28,'salida',1.00,300.00,299.00,'Aposito consulta turno 52',2,'2026-05-20 12:30:00'),(5,6,'salida',30.00,600.00,570.00,'Receta turno 53 - Gastritis cronica',3,'2026-05-20 13:30:00'),(6,21,'salida',2.00,496.00,494.00,'Guantes consulta turno 53',3,'2026-05-20 13:30:00'),(7,21,'salida',2.00,494.00,492.00,'Guantes consulta turno 54',4,'2026-05-20 14:30:00'),(8,21,'salida',2.00,492.00,490.00,'Guantes consulta turno 55',5,'2026-05-20 15:30:00'),(9,26,'salida',3.00,400.00,397.00,'Gasas consulta turno 55',5,'2026-05-20 15:30:00'),(10,2,'salida',15.00,800.00,785.00,'Receta turno 56 - Lumbalgia mecanica',6,'2026-05-20 16:30:00'),(11,21,'salida',2.00,490.00,488.00,'Guantes consulta turno 56',6,'2026-05-20 16:30:00'),(12,21,'salida',2.00,488.00,486.00,'Guantes consulta turno 57',7,'2026-05-20 17:30:00'),(13,23,'salida',1.00,500.00,499.00,'Jeringa extraccion turno 57',7,'2026-05-20 17:30:00'),(14,25,'salida',1.00,600.00,599.00,'Aguja extraccion turno 57',7,'2026-05-20 17:30:00'),(15,3,'salida',21.00,300.00,279.00,'Receta turno 58 - Otitis media aguda',8,'2026-05-20 18:30:00'),(16,21,'salida',2.00,486.00,484.00,'Guantes consulta turno 58',8,'2026-05-20 18:30:00'),(17,2,'salida',15.00,785.00,770.00,'Receta turno 59 - Esguince tobillo',9,'2026-05-20 19:30:00'),(18,27,'salida',1.00,200.00,199.00,'Venda elastica turno 59',9,'2026-05-20 19:30:00'),(19,21,'salida',2.00,484.00,482.00,'Guantes consulta turno 59',9,'2026-05-20 19:30:00'),(20,21,'salida',2.00,482.00,480.00,'Guantes consulta turno 60',10,'2026-05-20 20:30:00'),(21,21,'salida',2.00,480.00,478.00,'Guantes consulta turno 61',11,'2026-05-21 11:30:00'),(22,21,'salida',2.00,478.00,476.00,'Guantes consulta turno 62',12,'2026-05-21 12:30:00'),(23,23,'salida',2.00,499.00,497.00,'Jeringas extraccion turno 62',12,'2026-05-21 12:30:00'),(24,25,'salida',2.00,599.00,597.00,'Agujas extraccion turno 62',12,'2026-05-21 12:30:00'),(25,21,'salida',2.00,476.00,474.00,'Guantes consulta turno 63',13,'2026-05-21 13:30:00'),(26,23,'salida',2.00,497.00,495.00,'Jeringas biopsia turno 63',13,'2026-05-21 13:30:00'),(27,26,'salida',5.00,397.00,392.00,'Gasas biopsia turno 63',13,'2026-05-21 13:30:00'),(28,21,'salida',4.00,474.00,470.00,'Guantes turno 64 - quimioterapia',14,'2026-05-21 14:30:00'),(29,29,'salida',2.00,150.00,148.00,'Cateter IV turno 64',14,'2026-05-21 14:30:00'),(30,15,'salida',2.00,250.00,248.00,'Solucion fisiologica turno 64',14,'2026-05-21 14:30:00'),(31,21,'salida',2.00,470.00,468.00,'Guantes turno 65',15,'2026-05-21 15:30:00'),(32,26,'salida',2.00,392.00,390.00,'Gasas turno 65',15,'2026-05-21 15:30:00'),(33,21,'salida',2.00,468.00,466.00,'Guantes turno 66',16,'2026-05-21 16:30:00'),(34,23,'salida',1.00,495.00,494.00,'Jeringa extraccion turno 66',16,'2026-05-21 16:30:00'),(35,21,'salida',2.00,466.00,464.00,'Guantes turno 67',17,'2026-05-21 17:30:00'),(36,26,'salida',2.00,390.00,388.00,'Gasas limpieza ocular turno 67',17,'2026-05-21 17:30:00'),(37,21,'salida',2.00,464.00,462.00,'Guantes turno 68',18,'2026-05-21 18:30:00'),(38,3,'salida',20.00,279.00,259.00,'Receta turno 69 - Sinusitis aguda',19,'2026-05-21 19:30:00'),(39,21,'salida',2.00,462.00,460.00,'Guantes turno 69',19,'2026-05-21 19:30:00'),(40,9,'salida',30.00,200.00,170.00,'Receta turno 70 - Hipotiroidismo',20,'2026-05-21 20:30:00'),(41,21,'salida',2.00,460.00,458.00,'Guantes turno 70',20,'2026-05-21 20:30:00'),(42,5,'salida',60.00,400.00,340.00,'Receta turno 71 - Diabetes tipo 2',21,'2026-05-22 11:30:00'),(43,21,'salida',2.00,458.00,456.00,'Guantes turno 71',21,'2026-05-22 11:30:00'),(44,21,'salida',2.00,456.00,454.00,'Guantes turno 72',22,'2026-05-22 12:30:00'),(45,21,'salida',2.00,454.00,452.00,'Guantes turno 73',23,'2026-05-22 13:30:00'),(46,23,'salida',1.00,494.00,493.00,'Jeringa turno 73',23,'2026-05-22 13:30:00'),(47,25,'salida',1.00,597.00,596.00,'Aguja turno 73',23,'2026-05-22 13:30:00'),(48,1,'salida',30.00,470.00,440.00,'Receta turno 74 - Insuficiencia renal',24,'2026-05-22 14:30:00'),(49,21,'salida',2.00,452.00,450.00,'Guantes turno 74',24,'2026-05-22 14:30:00'),(50,19,'salida',1.00,110.00,109.00,'Receta turno 75 - Asma bronquial',25,'2026-05-22 15:30:00'),(51,21,'salida',2.00,450.00,448.00,'Guantes turno 75',25,'2026-05-22 15:30:00'),(52,21,'salida',2.00,448.00,446.00,'Guantes turno 76',26,'2026-05-22 16:30:00'),(53,23,'salida',1.00,493.00,492.00,'Jeringa extraccion turno 76',26,'2026-05-22 16:30:00'),(54,21,'salida',2.00,446.00,444.00,'Guantes turno 77',27,'2026-05-22 17:30:00'),(55,23,'salida',1.00,492.00,491.00,'Jeringa extraccion turno 77',27,'2026-05-22 17:30:00'),(56,21,'salida',2.00,444.00,442.00,'Guantes turno 78',28,'2026-05-22 18:30:00'),(57,21,'salida',2.00,442.00,440.00,'Guantes turno 79',29,'2026-05-22 19:30:00'),(58,21,'salida',2.00,440.00,438.00,'Guantes turno 80',30,'2026-05-22 20:30:00'),(59,3,'salida',21.00,259.00,238.00,'Receta turno 81 - Bronquitis aguda',99,'2026-05-23 11:30:00'),(60,21,'salida',2.00,438.00,436.00,'Guantes turno 81',99,'2026-05-23 11:30:00'),(61,21,'salida',2.00,436.00,434.00,'Guantes turno 82',100,'2026-05-23 12:30:00'),(62,23,'salida',1.00,491.00,490.00,'Jeringa turno 82',100,'2026-05-23 12:30:00'),(63,4,'salida',10.00,1200.00,1190.00,'Receta turno 83 - COVID-19',101,'2026-05-23 13:30:00'),(64,32,'salida',2.00,100.00,98.00,'Barbijos N95 turno 83',101,'2026-05-23 13:30:00'),(65,21,'salida',2.00,434.00,432.00,'Guantes turno 83',101,'2026-05-23 13:30:00'),(66,4,'salida',10.00,1190.00,1180.00,'Receta turno 84 - Dengue',102,'2026-05-23 14:30:00'),(67,21,'salida',2.00,432.00,430.00,'Guantes turno 84',102,'2026-05-23 14:30:00'),(68,23,'salida',2.00,490.00,488.00,'Jeringas extraccion turno 84',102,'2026-05-23 14:30:00'),(69,2,'salida',10.00,770.00,760.00,'Receta turno 85 - Hernia inguinal',103,'2026-05-23 15:30:00'),(70,21,'salida',2.00,430.00,428.00,'Guantes turno 85',103,'2026-05-23 15:30:00'),(71,21,'salida',4.00,428.00,424.00,'Guantes cirugia turno 86',104,'2026-05-23 16:30:00'),(72,29,'salida',2.00,148.00,146.00,'Cateter IV turno 86',104,'2026-05-23 16:30:00'),(73,15,'salida',2.00,248.00,246.00,'Solucion fisiologica turno 86',104,'2026-05-23 16:30:00'),(74,26,'salida',10.00,388.00,378.00,'Gasas cirugia turno 86',104,'2026-05-23 16:30:00'),(75,38,'salida',1.00,50.00,49.00,'Equipo sutura turno 86',104,'2026-05-23 16:30:00'),(76,2,'salida',15.00,760.00,745.00,'Receta turno 87 - Fractura muneca',105,'2026-05-23 17:30:00'),(77,27,'salida',2.00,199.00,197.00,'Vendas turno 87',105,'2026-05-23 17:30:00'),(78,21,'salida',2.00,424.00,422.00,'Guantes turno 87',105,'2026-05-23 17:30:00'),(79,21,'salida',4.00,422.00,418.00,'Guantes turno 88',106,'2026-05-23 18:30:00'),(80,23,'salida',2.00,488.00,486.00,'Jeringas sedacion turno 88',106,'2026-05-23 18:30:00'),(81,15,'salida',1.00,246.00,245.00,'Solucion fisiologica turno 88',106,'2026-05-23 18:30:00'),(82,21,'salida',2.00,418.00,416.00,'Guantes turno 89',107,'2026-05-23 19:30:00'),(83,21,'salida',2.00,416.00,414.00,'Guantes turno 90',108,'2026-05-23 20:30:00'),(84,23,'salida',1.00,486.00,485.00,'Jeringa extraccion turno 90',108,'2026-05-23 20:30:00'),(85,21,'salida',2.00,414.00,412.00,'Guantes turno 91',109,'2026-05-26 11:30:00'),(86,21,'salida',2.00,412.00,410.00,'Guantes turno 92',110,'2026-05-26 12:30:00'),(87,21,'salida',2.00,410.00,408.00,'Guantes turno 93',111,'2026-05-26 13:30:00'),(88,21,'salida',2.00,408.00,406.00,'Guantes turno 94',112,'2026-05-26 14:30:00'),(89,23,'salida',1.00,485.00,484.00,'Jeringa densitometria turno 94',112,'2026-05-26 14:30:00'),(90,8,'salida',30.00,280.00,250.00,'Receta turno 95 - Hipercolesterolemia',113,'2026-05-26 15:30:00'),(91,21,'salida',2.00,406.00,404.00,'Guantes turno 95',113,'2026-05-26 15:30:00'),(92,21,'salida',2.00,404.00,402.00,'Guantes turno 96',114,'2026-05-26 16:30:00'),(93,28,'salida',1.00,299.00,298.00,'Aposito turno 96',114,'2026-05-26 16:30:00'),(94,21,'salida',4.00,402.00,398.00,'Guantes turno 97 - Leucemia',115,'2026-05-26 17:30:00'),(95,29,'salida',1.00,146.00,145.00,'Cateter IV turno 97',115,'2026-05-26 17:30:00'),(96,15,'salida',1.00,245.00,244.00,'Solucion fisiologica turno 97',115,'2026-05-26 17:30:00'),(97,21,'salida',2.00,398.00,396.00,'Guantes turno 98',116,'2026-05-26 18:30:00'),(98,23,'salida',2.00,484.00,482.00,'Jeringas extraccion turno 98',116,'2026-05-26 18:30:00'),(99,25,'salida',2.00,596.00,594.00,'Agujas extraccion turno 98',116,'2026-05-26 18:30:00'),(100,21,'salida',4.00,396.00,392.00,'Guantes turno 99 - internacion',117,'2026-05-26 19:30:00'),(101,29,'salida',2.00,145.00,143.00,'Cateter IV turno 99',117,'2026-05-26 19:30:00'),(102,15,'salida',3.00,244.00,241.00,'Solucion fisiologica turno 99',117,'2026-05-26 19:30:00'),(103,16,'salida',2.00,180.00,178.00,'Dextrosa turno 99',117,'2026-05-26 19:30:00'),(104,21,'salida',2.00,392.00,390.00,'Guantes turno 100',118,'2026-05-26 20:30:00'),(105,23,'salida',2.00,482.00,480.00,'Jeringas extraccion turno 100',118,'2026-05-26 20:30:00'),(106,15,'salida',1.00,241.00,240.00,'Solucion fisiologica turno 100',118,'2026-05-26 20:30:00');
/*!40000 ALTER TABLE `movimientos_insumos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacientes`
--

DROP TABLE IF EXISTS `pacientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pacientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dni` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `sexo` enum('M','F','X') NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `domicilio` varchar(255) DEFAULT NULL,
  `obra_social` varchar(100) DEFAULT NULL,
  `nro_afiliado` varchar(50) DEFAULT NULL,
  `grupo_sanguineo` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') DEFAULT NULL,
  `alergias` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacientes`
--

LOCK TABLES `pacientes` WRITE;
/*!40000 ALTER TABLE `pacientes` DISABLE KEYS */;
INSERT INTO `pacientes` VALUES (1,'35100200','Maria','Garcia','1990-05-15','F','paciente@gmail.com','1234','1155001111','Av. Corrientes 1234, CABA','OSDE','12345-01','O+','Penicilina',1,'2026-05-11 23:50:08'),(2,'28900100','Carlos','Lopez','1978-11-30','M','carlos.l@gmail.com','1234','1155002222','Sarmiento 800, CABA','Swiss Medical','67890-02','A+',NULL,1,'2026-05-11 23:50:08'),(3,'40300400','Luciana','Torres','2000-03-22','F','lu.torres@gmail.com','1234','1155003333','Rivadavia 500, CABA','Galeno','11122-03','B-','Ibuprofeno',1,'2026-05-11 23:50:08'),(4,'33456789','Diego','Fernandez','1985-07-10','M','dfernandez@gmail.com','1234','1155004444','Av. Santa Fe 2100, CABA','OSDE','22233-04','A-',NULL,1,'2026-05-11 23:50:08'),(5,'29876543','Valeria','Romero','1982-12-05','F','vromero@gmail.com','1234','1155005555','Tucuman 350, CABA','Medife','33344-05','B+','Aspirina',1,'2026-05-11 23:50:08'),(6,'38111222','Lucas','Martinez','1998-09-18','M','lmartinez@gmail.com','1234','1155006666','Lavalle 1500, CABA','IOMA','44455-06','O-',NULL,1,'2026-05-11 23:50:08'),(7,'25678901','Claudia','Benitez','1975-04-25','F','cbenitez@gmail.com','1234','1155007777','Av. Callao 900, CABA','Swiss Medical','55566-07','AB+','Latex',1,'2026-05-11 23:50:08'),(8,'31234567','Marcos','Gutierrez','1988-01-30','M','mgutierrez@gmail.com','1234','1155008888','Maipu 600, CABA','Galeno','66677-08','A+',NULL,1,'2026-05-11 23:50:08'),(9,'27890123','Natalia','Perez','1980-08-14','F','nperez@gmail.com','1234','1155009999','Av. de Mayo 800, CABA','OSDE','77788-09','O+','Penicilina',1,'2026-05-11 23:50:08'),(10,'36543210','Rodrigo','Sanchez','1995-06-22','M','rsanchez@gmail.com','1234','1155010000','Florida 200, CABA','Medife','88899-10','B+',NULL,1,'2026-05-11 23:50:08'),(11,'24321098','Patricia','Molina','1972-02-17','F','pmolina@gmail.com','1234','1155011111','Av. Rivadavia 3400, CABA','IOMA','99900-11','A-','Ibuprofeno',1,'2026-05-11 23:50:08'),(12,'39876541','Andres','Vargas','2001-10-08','M','avargas@gmail.com','1234','1155012222','Corrientes 4500, CABA','Swiss Medical','10011-12','AB-',NULL,1,'2026-05-11 23:50:08'),(13,'26789012','Silvina','Castro','1977-03-19','F','scastro@gmail.com','1234','1155013333','Av. Cabildo 1200, CABA','Galeno','11122-13','O+',NULL,1,'2026-05-11 23:50:08'),(14,'32109876','Fernando','Diaz','1991-11-27','M','fdiaz@gmail.com','1234','1155014444','Viamonte 700, CABA','OSDE','22233-14','B-','Penicilina',1,'2026-05-11 23:50:08'),(15,'28654321','Monica','Herrera','1983-05-31','F','mherrera@gmail.com','1234','1155015555','Av. Belgrano 2200, CABA','Medife','33344-15','A+',NULL,1,'2026-05-11 23:50:08'),(16,'37012345','Sebastian','Ruiz','1996-08-04','M','sruiz@gmail.com','1234','1155016666','Paraguay 1100, CABA','IOMA','44455-16','O-','Aspirina',1,'2026-05-11 23:50:08'),(17,'23456789','Laura','Mendez','1970-01-12','F','lmendez@gmail.com','1234','1155017777','Av. Pueyrredon 800, CABA','Swiss Medical','55566-17','B+',NULL,1,'2026-05-11 23:50:08'),(18,'35678901','Pablo','Acosta','1993-07-29','M','pacosta@gmail.com','1234','1155018888','Reconquista 400, CABA','Galeno','66677-18','AB+',NULL,1,'2026-05-11 23:50:08'),(19,'29012345','Gabriela','Vega','1986-04-16','F','gvega@gmail.com','1234','1155019999','Av. Entre Rios 1500, CABA','OSDE','77788-19','A-','Latex',1,'2026-05-11 23:50:08'),(20,'34567890','Nicolas','Moreno','1994-12-03','M','nmoreno@gmail.com','1234','1155020000','Suipacha 300, CABA','Medife','88899-20','O+',NULL,1,'2026-05-11 23:50:08');
/*!40000 ALTER TABLE `pacientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `turnos`
--

DROP TABLE IF EXISTS `turnos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `turnos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `medico_id` int(11) NOT NULL,
  `especialidad_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `estado` enum('pendiente','confirmado','cancelado','realizado') DEFAULT 'pendiente',
  `observaciones` text DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `medico_id` (`medico_id`,`fecha`,`hora`),
  KEY `paciente_id` (`paciente_id`),
  KEY `especialidad_id` (`especialidad_id`),
  CONSTRAINT `turnos_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `pacientes` (`id`),
  CONSTRAINT `turnos_ibfk_2` FOREIGN KEY (`medico_id`) REFERENCES `medicos` (`id`),
  CONSTRAINT `turnos_ibfk_3` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidades` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turnos`
--

LOCK TABLES `turnos` WRITE;
/*!40000 ALTER TABLE `turnos` DISABLE KEYS */;
INSERT INTO `turnos` VALUES (51,1,1,21,'2026-05-20','08:00:00','realizado',NULL,'2026-05-11 23:52:01'),(52,2,2,21,'2026-05-20','09:00:00','realizado',NULL,'2026-05-11 23:52:01'),(53,3,3,22,'2026-05-20','10:00:00','realizado',NULL,'2026-05-11 23:52:01'),(54,4,4,22,'2026-05-20','11:00:00','realizado',NULL,'2026-05-11 23:52:01'),(55,5,5,23,'2026-05-20','12:00:00','realizado',NULL,'2026-05-11 23:52:01'),(56,6,6,23,'2026-05-20','13:00:00','realizado',NULL,'2026-05-11 23:52:01'),(57,7,7,24,'2026-05-20','14:00:00','realizado',NULL,'2026-05-11 23:52:01'),(58,8,8,24,'2026-05-20','15:00:00','realizado',NULL,'2026-05-11 23:52:01'),(59,9,9,1,'2026-05-20','16:00:00','realizado',NULL,'2026-05-11 23:52:01'),(60,10,10,1,'2026-05-20','17:00:00','realizado',NULL,'2026-05-11 23:52:01'),(61,11,11,2,'2026-05-21','08:00:00','realizado',NULL,'2026-05-11 23:52:01'),(62,12,12,2,'2026-05-21','09:00:00','realizado',NULL,'2026-05-11 23:52:01'),(63,13,13,3,'2026-05-21','10:00:00','realizado',NULL,'2026-05-11 23:52:01'),(64,14,14,3,'2026-05-21','11:00:00','realizado',NULL,'2026-05-11 23:52:01'),(65,15,15,4,'2026-05-21','12:00:00','realizado',NULL,'2026-05-11 23:52:01'),(66,16,16,4,'2026-05-21','13:00:00','realizado',NULL,'2026-05-11 23:52:01'),(67,17,17,5,'2026-05-21','14:00:00','realizado',NULL,'2026-05-11 23:52:01'),(68,18,18,5,'2026-05-21','15:00:00','realizado',NULL,'2026-05-11 23:52:01'),(69,19,19,6,'2026-05-21','16:00:00','realizado',NULL,'2026-05-11 23:52:01'),(70,20,20,6,'2026-05-21','17:00:00','realizado',NULL,'2026-05-11 23:52:01'),(71,1,21,7,'2026-05-22','08:00:00','realizado',NULL,'2026-05-11 23:52:01'),(72,2,22,7,'2026-05-22','09:00:00','realizado',NULL,'2026-05-11 23:52:01'),(73,3,23,8,'2026-05-22','10:00:00','realizado',NULL,'2026-05-11 23:52:01'),(74,4,24,8,'2026-05-22','11:00:00','realizado',NULL,'2026-05-11 23:52:01'),(75,5,25,9,'2026-05-22','12:00:00','realizado',NULL,'2026-05-11 23:52:01'),(76,6,26,9,'2026-05-22','13:00:00','realizado',NULL,'2026-05-11 23:52:01'),(77,7,27,10,'2026-05-22','14:00:00','realizado',NULL,'2026-05-11 23:52:01'),(78,8,28,10,'2026-05-22','15:00:00','realizado',NULL,'2026-05-11 23:52:01'),(79,9,29,11,'2026-05-22','16:00:00','realizado',NULL,'2026-05-11 23:52:01'),(80,10,30,11,'2026-05-22','17:00:00','realizado',NULL,'2026-05-11 23:52:01'),(81,11,99,14,'2026-05-23','08:00:00','realizado',NULL,'2026-05-11 23:52:01'),(82,12,100,14,'2026-05-23','09:00:00','realizado',NULL,'2026-05-11 23:52:01'),(83,13,101,15,'2026-05-23','10:00:00','realizado',NULL,'2026-05-11 23:52:01'),(84,14,102,15,'2026-05-23','11:00:00','realizado',NULL,'2026-05-11 23:52:01'),(85,15,103,16,'2026-05-23','12:00:00','realizado',NULL,'2026-05-11 23:52:01'),(86,16,104,16,'2026-05-23','13:00:00','realizado',NULL,'2026-05-11 23:52:01'),(87,17,105,17,'2026-05-23','14:00:00','realizado',NULL,'2026-05-11 23:52:01'),(88,18,106,17,'2026-05-23','15:00:00','realizado',NULL,'2026-05-11 23:52:01'),(89,19,107,18,'2026-05-23','16:00:00','realizado',NULL,'2026-05-11 23:52:01'),(90,20,108,18,'2026-05-23','17:00:00','realizado',NULL,'2026-05-11 23:52:01'),(91,1,109,19,'2026-05-26','08:00:00','realizado',NULL,'2026-05-11 23:52:01'),(92,2,110,19,'2026-05-26','09:00:00','realizado',NULL,'2026-05-11 23:52:01'),(93,3,111,20,'2026-05-26','10:00:00','realizado',NULL,'2026-05-11 23:52:01'),(94,4,112,20,'2026-05-26','11:00:00','realizado',NULL,'2026-05-11 23:52:01'),(95,5,113,21,'2026-05-26','12:00:00','realizado',NULL,'2026-05-11 23:52:01'),(96,6,114,24,'2026-05-26','13:00:00','realizado',NULL,'2026-05-11 23:52:01'),(97,7,115,12,'2026-05-26','14:00:00','realizado',NULL,'2026-05-11 23:52:01'),(98,8,116,12,'2026-05-26','15:00:00','realizado',NULL,'2026-05-11 23:52:01'),(99,9,117,13,'2026-05-26','16:00:00','realizado',NULL,'2026-05-11 23:52:01'),(100,10,118,13,'2026-05-26','17:00:00','realizado',NULL,'2026-05-11 23:52:01');
/*!40000 ALTER TABLE `turnos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-11 21:21:46
