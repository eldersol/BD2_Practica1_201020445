IF OBJECT_ID ( 'TR1', 'P' ) IS NOT NULL
	BEGIN
		BEGIN TRANSACTION
			DROP PROCEDURE TR1;
		COMMIT;
	END;
GO

CREATE PROCEDURE TR1		
	@firstname NVARCHAR(250),
	@lastname NVARCHAR(250),
	@email NVARCHAR(100),
	@password NVARCHAR(100),
	@credits NVARCHAR(1024) OUTPUT

	AS
	BEGIN
		DECLARE @IdUser uniqueidentifier;
		SET @IdUser = NEWID();
		DECLARE @IdRole uniqueidentifier;
		SET @IdRole = (select id from BD2.practica1.Roles where RoleName = 'Estudiante');

		IF (SELECT Email FROM BD2.practica1.Usuarios where Email = @email) IS NULL	
			BEGIN
				--CREAR USUARIO
				BEGIN TRANSACTION
					INSERT INTO BD2.practica1.Usuarios(Id, Firstname, Lastname, Email, DateOfBirth, Password, LastChanges, EmailConfirmed)
					VALUES (@IdUser, @firstname, @lastname, @email, GETDATE(), @password, GETDATE(), 1);
					INSERT INTO BD2.practica1.HistoryLog(Date, Description)
					VALUES ( GETDATE(), 'TR1: Creacion de usuario '+ @firstname);
				COMMIT;

				--CREAR ROL DE ESTUDIANTE
				BEGIN TRANSACTION					
					INSERT INTO BD2.practica1.UsuarioRole(RoleId, UserId, IsLatestVersion)
					VALUES (@IdRole, @IdUser, 1);	
					INSERT INTO BD2.practica1.HistoryLog(Date, Description)
					VALUES ( GETDATE(), 'TR1: Creacion de rol para '+ @firstname);
				COMMIT;

				--CREAR NOTIFICACION
				BEGIN TRANSACTION
					INSERT INTO BD2.practica1.Notification(UserId, Message, Date)
					VALUES (@IdUser, 'Correo para notificacion de usuario', GETDATE());	
					INSERT INTO BD2.practica1.HistoryLog(Date, Description)
					VALUES ( GETDATE(), 'TR1: Creacion de notificacion para el usuario '+ @firstname);
				COMMIT;

				--CREAR PERFIL DE ESTUDIANTE
				BEGIN TRANSACTION
					INSERT INTO BD2.practica1.ProfileStudent(UserId, Credits)
					VALUES (@IdUser, @credits);
					INSERT INTO BD2.practica1.HistoryLog(Date, Description)
					VALUES ( GETDATE(), 'TR1: Se creo perfil de estudiante para '+ @firstname);
				COMMIT;

				--CREAR FACTOR DE AUTENTICACION
				BEGIN TRANSACTION
					INSERT INTO BD2.practica1.TFA(UserId, Status, LastUpdate)
					VALUES (@IdUser, 0, GETDATE());
					INSERT INTO BD2.practica1.HistoryLog(Date, Description)
					VALUES ( GETDATE(), 'TR1: Se modifico el factor de autenticacion para el usuario '+ @firstname);
				COMMIT;

			END;
		ELSE
			PRINT('NO SE PUEDE REALIZAR LA OPERACION');
	END			

GO 

-- nombre apellido correo contraseña creditos
EXECUTE TR1 'ELDER','Tojin', 'eldertojins@gmail.com','123','20';
EXECUTE TR1 'Carlos','Lopez', 'maestro1@gmail.com','123','50';