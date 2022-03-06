IF OBJECT_ID ( 'TR3', 'P' ) IS NOT NULL
	BEGIN
		BEGIN TRANSACTION
			DROP PROCEDURE TR3;
		COMMIT;
	END;
GO

CREATE PROCEDURE TR3		
	@email NVARCHAR(250),
	@codCourse INT OUTPUT
	AS
	BEGIN
		DECLARE @IdEstudiante uniqueidentifier;
		DECLARE @IdTutor uniqueidentifier;
		DECLARE @EmailConfirmed bit;
		DECLARE @CreditsRequired int;
		DECLARE @StudenCredits int;
		SET @IdEstudiante = (select id from BD2.practica1.Usuarios where Email = @email);
		SET @IdTutor = (select TutorId from BD2.practica1.CourseTutor where CourseCodCourse = @codCourse);
		
		SET @EmailConfirmed = (select EmailConfirmed from BD2.practica1.Usuarios where Email = @email);
		
		SET @CreditsRequired = (select CreditsRequired from BD2.practica1.Course where CodCourse = @codCourse);
		SET @StudenCredits = (select Credits from BD2.practica1.ProfileStudent where UserId = @IdEstudiante);

		IF @IdEstudiante IS NOT NULL
			IF @EmailConfirmed = 0
				PRINT 'Email no confirmado, usuario inactivo'
			ELSE
				BEGIN
					IF @StudenCredits >= @CreditsRequired
						BEGIN
							PRINT 'SI ASIGNAR';
							--ASIGNAR ESTUDIANTE
							BEGIN TRANSACTION
								INSERT INTO BD2.practica1.CourseAssignment(StudentId, CourseCodCourse)
								VALUES (@IdEstudiante, @codCourse);
								INSERT INTO BD2.practica1.HistoryLog(Date, Description)
								VALUES ( GETDATE(), 'TR3: Se le asigno el estudiante '+ @email);
							COMMIT;

							--CREAR NOTIFICACION
							BEGIN TRANSACTION
								INSERT INTO BD2.practica1.Notification(UserId, Message, Date)
								VALUES (@IdEstudiante, 'Correo para notificacion de estudiante', GETDATE());
								INSERT INTO BD2.practica1.HistoryLog(Date, Description)
								VALUES ( GETDATE(), 'TR3: Se envio la notificacion al estudiante ');
							COMMIT;

							BEGIN TRANSACTION
								INSERT INTO BD2.practica1.Notification(UserId, Message, Date)
								VALUES (@IdTutor, 'Correo para notificacion de tutor', GETDATE());
								INSERT INTO BD2.practica1.HistoryLog(Date, Description)
								VALUES ( GETDATE(), 'TR3: Se envio la notificacion al tutor ');
							COMMIT;
						END
					ELSE
						PRINT 'No se puede asignar no llega a los creditos requeridos';
				END;
		ELSE
			PRINT('NO SE PUEDE REALIZAR LA OPERACION');
			
	END			

GO 

-- Correo codigo del curso
EXECUTE TR3 'eldertojins@gmail.com', 1;