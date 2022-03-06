IF OBJECT_ID ( 'TR2', 'P' ) IS NOT NULL
	BEGIN
		BEGIN TRANSACTION
			DROP PROCEDURE TR2;
		COMMIT;
	END;
GO

CREATE PROCEDURE TR2		
	@email NVARCHAR(250),
	@codCourse INT OUTPUT
	AS
	BEGIN
		DECLARE @IdUsuario uniqueidentifier;
		DECLARE @EmailConfirmed bit;
		DECLARE @IdRole uniqueidentifier;		
		SET @IdUsuario = (select id from BD2.practica1.Usuarios where Email = @email);
		SET @EmailConfirmed = (select EmailConfirmed from BD2.practica1.Usuarios where Email = @email);
		SET @IdRole = (select id from BD2.practica1.Roles where RoleName = 'Tutor');

		IF @IdUsuario IS NOT NULL
			IF @EmailConfirmed = 0
				PRINT 'Email no confirmado, usuario inactivo'
			ELSE
				BEGIN
					--CREAR ROL DE TUTOR
					BEGIN TRANSACTION
						INSERT INTO BD2.practica1.UsuarioRole(RoleId, UserId, IsLatestVersion)
						VALUES (@IdRole, @IdUsuario, 0);	
						INSERT INTO BD2.practica1.HistoryLog(Date, Description)
						VALUES ( GETDATE(), 'TR2: Creacion de tutor '+ @email);
					COMMIT;

					--CREAR PERFIL DE TUTOR
					BEGIN TRANSACTION
						INSERT INTO BD2.practica1.TutorProfile(UserId, TutorCode)
						VALUES (@IdUsuario, '123');	
						INSERT INTO BD2.practica1.HistoryLog(Date, Description)
						VALUES ( GETDATE(), 'TR2: Creacion de perfil para '+ @email);
					COMMIT;

					--ASIGNAR CURSO
					BEGIN TRANSACTION
						INSERT INTO BD2.practica1.CourseTutor(TutorId, CourseCodCourse)
						VALUES (@IdUsuario, 1);
						INSERT INTO BD2.practica1.HistoryLog(Date, Description)
						VALUES ( GETDATE(), 'TR2: Se le asigno el curso al tutor ' + @email);
					COMMIT;

					--CREAR NOTIFICACION
					BEGIN TRANSACTION
						INSERT INTO BD2.practica1.Notification(UserId, Message, Date)
						VALUES (@IdUsuario, 'Correo para notificacion de usuario', GETDATE());	
						INSERT INTO BD2.practica1.HistoryLog(Date, Description)
						VALUES ( GETDATE(), 'TR2: Se le envio notificacion al tutor '+ @email);
					COMMIT;
				END;
		ELSE
			PRINT('NO SE PUEDE REALIZAR LA OPERACION');
	END			

GO 

EXECUTE TR2 'maestro1@gmail.com', 1;