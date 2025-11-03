# Meeting Schedule

Sistema profesional de gestión de reuniones para congregaciones, con panel administrativo, generación de PDFs, envío por WhatsApp y sincronización automática con fechas públicas de JW.org.

## 🚀 Características

- ✅ **Autenticación de usuarios** con Devise (roles: admin/member)
- ✅ **Panel de administración** completo para gestión de usuarios
- ✅ **CRUD de reuniones** con detalles completos
- ✅ **Agenda interactiva** con drag & drop para reordenar items
- ✅ **Generación de PDFs** profesionales de cada reunión
- ✅ **Envío por WhatsApp** con un solo click
- ✅ **Scraper automático** de fechas públicas de JW.org
- ✅ **Diseño moderno** con Tailwind CSS
- ✅ **Tests completos** con RSpec

## 📋 Requisitos

- Ruby 3.1.2
- Rails 7.1.5
- PostgreSQL
- Node.js (para importmap)

## 🛠️ Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd Meeting-Schedule
```

2. **Instalar dependencias**
```bash
bundle install
```

3. **Configurar la base de datos**
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

4. **Iniciar el servidor**
```bash
bin/rails server
```

5. **Acceder a la aplicación**
```
http://localhost:3000
```

## 👤 Credenciales de Prueba

Después de ejecutar `db:seed`, puedes acceder con:

**Administrador:**
- Email: `admin@example.com`
- Contraseña: `password123`

**Miembro:**
- Email: `member@example.com`
- Contraseña: `password123`

## 📱 Uso de la Aplicación

### Para Administradores

1. **Panel de Administración** (`/admin/dashboard`)
   - Ver estadísticas generales
   - Gestionar usuarios (crear, editar, eliminar)
   - Ver próximas reuniones

2. **Gestión de Usuarios** (`/admin/users`)
   - Agregar nuevos usuarios
   - Asignar roles (admin/member)
   - Editar información de usuarios

### Para Todos los Usuarios

1. **Ver Reuniones** (`/meetings`)
   - Lista de todas las reuniones próximas
   - Filtrado automático por fecha

2. **Crear Reunión** (`/meetings/new`)
   - Título, fecha, lugar
   - Tipo de reunión (Entre Semana, Fin de Semana, Asamblea)
   - Notas adicionales

3. **Gestionar Agenda** (`/meetings/:id`)
   - Agregar items a la agenda
   - Reordenar items con drag & drop
   - Especificar hora, duración, rol y asignado
   - Eliminar items

4. **Generar PDF**
   - Click en "Ver PDF" para descargar
   - PDF incluye toda la información de la reunión

5. **Enviar por WhatsApp**
   - Click en "Enviar por WhatsApp"
   - Se abre WhatsApp con el link al PDF

## 🔄 Sincronización con JW.org

El sistema incluye un job para obtener automáticamente las fechas de reuniones desde JW.org:

```bash
# Ejecutar manualmente
bin/rails runner "FetchJwMeetingsJob.perform_now"
```

Para automatizar semanalmente, configura un cron job o usa Sidekiq con un scheduler.

## 🧪 Tests

Ejecutar todos los tests:
```bash
bundle exec rspec
```

Ejecutar solo tests de modelos:
```bash
bundle exec rspec spec/models/
```

## 🎨 Tecnologías Utilizadas

- **Backend:** Ruby on Rails 7.1
- **Base de datos:** PostgreSQL
- **Autenticación:** Devise
- **Frontend:** Tailwind CSS, Stimulus, Turbo
- **Drag & Drop:** SortableJS
- **PDFs:** Prawn
- **Web Scraping:** Nokogiri
- **Tests:** RSpec, FactoryBot, Shoulda Matchers

## 📂 Estructura del Proyecto

```
app/
├── controllers/
│   ├── admin/              # Panel de administración
│   ├── meetings_controller.rb
│   └── schedule_items_controller.rb
├── models/
│   ├── user.rb             # Usuario con roles
│   ├── meeting.rb          # Reunión
│   └── schedule_item.rb    # Item de agenda
├── views/
│   ├── admin/              # Vistas del panel admin
│   ├── meetings/           # Vistas de reuniones
│   └── layouts/            # Layout principal
├── jobs/
│   └── fetch_jw_meetings_job.rb  # Scraper de JW.org
└── javascript/
    └── controllers/
        └── drag_controller.js    # Drag & drop
```

## 🔐 Seguridad

- Autenticación obligatoria para todas las rutas
- Panel de administración solo accesible por admins
- Validaciones en modelos y controladores
- Protección CSRF activa
- Contraseñas encriptadas con bcrypt

## 🚀 Deployment

Para producción, configura:

1. Variables de entorno en `.env`:
```bash
DATABASE_URL=postgresql://...
SECRET_KEY_BASE=...
RAILS_ENV=production
```

2. Precompilar assets:
```bash
bin/rails assets:precompile
```

3. Migrar base de datos:
```bash
bin/rails db:migrate RAILS_ENV=production
```

## 📄 Licencia

MIT License - Ver archivo LICENSE para más detalles.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📧 Contacto

Para preguntas o sugerencias, contacta al equipo de desarrollo.

---

**Nota:** Esta aplicación respeta los términos de uso de JW.org y solo accede a información pública disponible para todos los visitantes.
