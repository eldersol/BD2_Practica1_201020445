BEGIN TRANSACTION
	delete from BD2.practica1.UsuarioRole;
	delete from BD2.practica1.Roles;
	delete from BD2.practica1.TFA;
	delete from BD2.practica1.TutorProfile;
	delete from BD2.practica1.ProfileStudent;
	delete from BD2.practica1.UsuarioRole;
	delete from BD2.practica1.Notification;
	delete from BD2.practica1.CourseTutor;
	delete from BD2.practica1.Usuarios;
	delete from BD2.practica1.Course;
	delete from BD2.practica1.HistoryLog;
COMMIT;

BEGIN TRANSACTION
	INSERT INTO BD2.practica1.Roles(Id, RoleName)
	VALUES (NEWID(), 'Estudiante');

	INSERT INTO BD2.practica1.Roles(Id, RoleName)
	VALUES (NEWID(), 'Tutor');
COMMIT;

BEGIN TRANSACTION
	INSERT INTO BD2.practica1.Course(CodCourse, Name, CreditsRequired)
	VALUES (1, 'MATEMATICA 1', '4');

	INSERT INTO BD2.practica1.Course(CodCourse, Name, CreditsRequired)
	VALUES (2, 'Fisica 1', '5');
	
	INSERT INTO BD2.practica1.Course(CodCourse, Name, CreditsRequired)
	VALUES (3, 'Programacion 1', '6');
COMMIT;