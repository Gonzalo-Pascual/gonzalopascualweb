/* Barra de navegación */

let menuIcon = document.querySelector('#menu-icon');
let navbar = document.querySelector('.navbar');

menuIcon.onclick = () => {
    menuIcon.classList.toggle('bx-x');
    navbar.classList.toggle('active')
}



/* Scroll a la sección seleccionada */

let sections = document.querySelectorAll('section');
let navLinks = document.querySelectorAll('header nav a')

window.onscroll = () => {
    sections.forEach(sec => {
        let top = window.scrollY;
        let offset = sec.offsetTop - 100;
        let height = sec.offsetHeight;
        let id = sec.getAttribute('id');

        if (top >= offset && top < offset + height) {
            navLinks.forEach(links => {
                links.classList.remove('active');
                document.querySelector('header nav a[href*="' + id + '"]').classList.add('active');
            });
        }
    });

    let header = document.querySelector('header');
    header.classList.toggle('sticky', window.scrollY > 100);

    menuIcon.classList.remove('bx-x');
    navbar.classList.remove('active');


}

/* Cambio de tema */
let toggle = document.getElementById('toggle');
toggle.addEventListener('change', (event) => {
    let checked = event.target.checked;
    menuIcon.classList.remove('bx-x');
    navbar.classList.remove('active');
    document.body.classList.toggle('cambiocolor');
    menuIcon.classList.remove('bx-x');
    if (checked) {
        label_toggle.innerHTML = "<i class='bx bx-moon' ></i>";
        logo_color.innerHTML = '<img class="logo" src="imagenes/gverdesinfondo.png" alt="Logo de Gonzalo Pascual">';
        imgyo.innerHTML = '<img class="imgyo" src="imagenes/fotoverde.png" alt="Foto de Gonzalo Pascual">';

    } else {
        label_toggle.innerHTML = "<i class='bx bx-sun' ></i>"
        logo_color.innerHTML = '<img class="logo" src="imagenes/gblancosinfondo.png" alt="Logo de Gonzalo Pascual">';
        imgyo.innerHTML = '<img class="imgyo" src="imagenes/foto.png" alt="Foto de Gonzalo Pascual">';
    }

});


/* Cambio de idioma */

let toggle_idioma = document.getElementById('toggle_idioma');
toggle_idioma.addEventListener('change', (event) => {
    let checked_idioma = event.target.checked;
    menuIcon.classList.remove('bx-x');
    navbar.classList.remove('active');
    if (checked_idioma) {
        document.documentElement.lang = 'en';
        //NavBar
        casa.innerHTML = 'About me';
        proyectos.innerHTML = 'Proyects';
        formation.innerHTML = 'Experience';
        contact.innerHTML = 'Contact';
        idioma_toggle.innerHTML = "ES<i class='bx bx-chevron-down'></i>"
        contactarme.innerHTML = 'Contact me';
        curriculum.innerHTML = 'See CV';

        //Home
        trabajo.innerHTML = 'Programmer<br>Cybersecurity';
        textosobremi.innerHTML = "Hello! I’m Gonzalo, a professional with a strong interest in continuous learning and development. I am constantly training in new technologies and tools to refine my skills, while staying up to date on relevant threats and industry trends.";

        //Skills
        ciberseguridad.innerHTML = "Cybersecurity"
        hacking.innerHTML = "Ethical Hacking"
        forense.innerHTML = "Forensic"
        blueteam.innerHTML = "Blue Team"
        normativa.innerHTML = "Regulations"
        produccion.innerHTML = "Secure deployment"
        programacion.innerHTML = "Programming"
        herramientastexto.innerHTML = 'Tools';
        hackingtexto.innerHTML = "-Pentest reports<br>-Kali Linux<br>-Nmap / Netcat<br>-Burp Suite<br>-Metasploit"
        forensetexto.innerHTML = "-Expert reports<br>-Chain of custody<br>-Forensic tools<br>-Data recovery<br>-Evidence acquisition"
        blueteamtexto.innerHTML = "-Network and system hardening<br>-Network segmentation<br>-Encryption<br>-Account management"
        normativatexto.innerHTML = "-GDPR<br>-ENS<br>-Budapest Convention<br>-ISO 27000 / 22300<br>-ISO 42001"
        producciontexto.innerHTML = "-Code analysis<br>-Vulnerabilities<br>-SQLI / XSS<br>-SecDevOps<br>-Docker"
        javatexto.innerHTML = "-OOP<br>-Threads<br>-Exception handling<br>-Collections<br>-Swing"
        sqltexto.innerHTML = "-PL/SQL<br>-Advanced queries<br>-Views<br>-Triggers<br>-CRUD"
        pythontexto.innerHTML = "-POO<br>-Data types<br>-Regular expressions<br>-Modules and packages<br>-Exception handling"
        phptexto.innerHTML = "-Forms<br>-Sessions<br>-Error handling<br>-Regular expressions<br>-Security"
        ctexto.innerHTML = "-Arrays<br>-Pointers<br>-Functions<br>-Libraries<br>-Debugging"
        jstexto.innerHTML = "-Functions<br>-Event handling<br>-DOM<br>-Frameworks<br>-JSON"
        linuxtexto.innerHTML = "-Ubuntu Server<br>-Kali Linux<br>-Snort<br>-Shell scripting<br>-Package management"
        windowstexto.innerHTML = "-Windows Server<br>-IIS<br>-CMD/PowerShell<br>-Monitoring and management<br>-Active Directory"
        dockertexto.innerHTML = "-Container management<br>-Development and testing<br>-Version control<br>-CI/CD<br>-Monitoring"
        burpsuitetexto.innerHTML = "-SQL Injection<br>-XSS<br>-HTTP manipulation<br>-Brute force<br>-Code analysis"
        githubtexto.innerHTML = "-Repository management<br>-Version control<br>-Pull requests<br>-Branches<br>-GitHub Pages";

        //Proyectos
        proyectos1.innerHTML = "Proyects"
        ciberseguridad1.innerHTML = "Cybersecurity"
        programacion1.innerHTML = "Programming"
        hackingetico.innerHTML = '<img src="imagenes/hackingeticoingles.png" alt="Ethical Hacking and Pentesting project" loading="lazy">'
        atenea.innerHTML = '<img src="imagenes/ateneaingles.png" alt="Ethical Hacking practices on Atenea" loading="lazy">'
        phishing.innerHTML = '<img src="imagenes/phishingingles.png" alt="Phishing incident analysis" loading="lazy">'
        guitarra.innerHTML = '<img src="imagenes/guitarraingles.png" alt="Guitar store (final project)" loading="lazy">'
        odoo.innerHTML = '<img src="imagenes/odooingles.png" alt="Odoo ERP replica" loading="lazy">'
        bbdd.innerHTML = '<img src="imagenes/bbddingles.png" alt="Hospital database" loading="lazy">'

        //Formación
        formacion1.innerHTML = "Experience"
        ciberseguridad2.innerHTML = "Cybersecurity"
        programacion2.innerHTML = "Programming"
        inetexto.innerHTML = "Pentesting certification that covers recognition techniques, enumeration, vulnerability exploitation, privilege escalation and pivoting among others"
        isc2texto.innerHTML = "Base certification in cybersecurity covering security domains, practices, and laws and regulations."
        master.innerHTML = "Cybersecurity Master"
        mastertexto.innerHTML = "Specializing practically in securing systems, analyzing data, investigating cybercrimes, and developing hacking skills."
        dam.innerHTML = "Degree in DAM"
        damtexto.innerHTML = "Learning to create applications from backend to frontend, improving the user experience."
        robotica.innerHTML = "Robotic course"
        roboticatexto.innerHTML = "Developing programming knowledge, demonstrating my ability to work in a team and organize projects."
        visavetanio.innerHTML = "2025 - Present";
        visavet.innerHTML = "Programmer - VISAVET"
        visavettexto.innerHTML = "Software and secure database development for the management and analysis of scientific information, along with systems administration and comprehensive IT support."




        //contacto
        contact1.innerHTML = "Contact"
        misdatos.innerHTML = 'My info';
        locationtext.innerHTML = 'Madrid, Spain';
        contactarme1.innerHTML = 'Contact me';
        formulario.innerHTML = '<input type="text" name="name" id="nomretexto" class="inputdatos" placeholder="Name" aria-label="Name"><input type="email" name="email" class="inputdatos" placeholder="Email" aria-label="Email"><textarea name="message" placeholder="Message" class="textdatos" cols="30" rows="10" aria-label="Message"></textarea>'
        send.innerHTML = 'Send';
        gracias.innerHTML = 'Thank you for visiting my website!';


    } else {
        document.documentElement.lang = 'es';
        //NavBar
        casa.innerHTML = 'Sobre mi';
        proyectos.innerHTML = 'Proyectos';
        formation.innerHTML = 'Experiencia';
        contact.innerHTML = 'Contacto';
        idioma_toggle.innerHTML = "EN<i class='bx bx-chevron-down'></i>"
        contactarme.innerHTML = 'Contactarme';
        curriculum.innerHTML = 'Ver CV';

        //Home
        trabajo.innerHTML = 'Programación<br>Ciberseguridad';
        textosobremi.innerHTML = "¡Hola! Soy Gonzalo, una persona con gran interés por el aprendizaje y el desarrollo continuo. Me mantengo en constante formación en nuevas tecnologías y herramientas para perfeccionar mis habilidades, así como actualizado sobre amenazas y tendencias relevantes en el sector.";

        //Skills
        ciberseguridad.innerHTML = "Ciberseguridad"
        hacking.innerHTML = "Hacking Ético"
        forense.innerHTML = "Forense"
        blueteam.innerHTML = "Blue Team"
        normativa.innerHTML = "Normativa"
        produccion.innerHTML = "Desarrollo seguro"
        programacion.innerHTML = "Programación"
        herramientastexto.innerHTML = 'Herramientas';
        hackingtexto.innerHTML = "-Informes de pentest<br>-Kali Linux<br>-Nmap / Netcat<br>-Burp Suite<br>-Metasploit"
        forensetexto.innerHTML = "-Informes periciales<br>-Cadena de custodia<br>-Herramientas forenses<br>-Recuperación de datos<br>-Obtención de evidencia"
        blueteamtexto.innerHTML = "-Bastionado de redes y sistemas<br>-Segmentación de redes<br>-Cifrados<br>-Gestión de cuentas"
        normativatexto.innerHTML = "-RGPD<br>-ENS<br>-Convenio de budapest<br>-ISO 27000 / 22300<br>-ISO 42001"
        producciontexto.innerHTML = "-Analisis de código<br>-Vulnerabilidades<br>-SQLI / XSS<br>-SecDevOps<br>-Docker"
        javatexto.innerHTML = "-POO<br>-Threads<br>-Manejo de excepciones<br>-Colecciones<br>-Swing"
        sqltexto.innerHTML = "-PLSQL<br>-Consultas avanzadas<br>-Vistas<br>-Triggers<br>-CRUD"
        pythontexto.innerHTML = "-POO<br>-Tipo de datos<br>-Expresiones regulares<br>-Módulos y paquetes<br>-Manejo de excepciones"
        phptexto.innerHTML = "-Formularios<br>-Sesiones<br>-Manejo de errores<br>-Expresiones regulares<br>-Seguridad"
        ctexto.innerHTML = "-Arrays<br>-Punteros<br>-Funcines<br>-Librerias<br>-Depuracións"
        jstexto.innerHTML = "-Funcines<br>-Manejo de eventos<br>-DOM<br>-Frameworks<br>-JSON"
        linuxtexto.innerHTML = "-Ubuntu Server<br>-Kali Linux<br>-Snort<br>-Shell scripting<br>-Gestion de paquetes"
        windowstexto.innerHTML = "-Windows Server<br>-IIS<br>-CMD/PowerShell<br>-Monitoreo y gestión<br>-Active Directory"
        dockertexto.innerHTML = "-Gestionar contenedores<br>-Desarrollo y pruebas<br>-Control de versiones<br>-CI/CD<br>-Monitorización"
        burpsuitetexto.innerHTML = "-SQL Injectión<br>-XSS<br>-Manipulación HTTP<br>-Fuerza bruta<br>-Análisis de código"
        githubtexto.innerHTML = "-Gestión de repositorios<br>-Control de versiones<br>-Pull requests<br>-Branches<br>-GitHub Pages";


        //Proyectos
        proyectos1.innerHTML = "Proyectos"
        ciberseguridad1.innerHTML = "Ciberseguridad"
        programacion1.innerHTML = "Programación"
        hackingetico.innerHTML = '<img src="imagenes/hackingetico.png" alt="Proyecto de Hacking Ético y Pentesting" loading="lazy">'
        atenea.innerHTML = '<img src="imagenes/atenea.png" alt="Prácticas de Hacking Ético en Atenea" loading="lazy">'
        phishing.innerHTML = '<img src="imagenes/phishing.png" alt="Análisis de incidente de phishing" loading="lazy">'
        guitarra.innerHTML = '<img src="imagenes/guitarra.png" alt="Tienda de guitarras (TFG)" loading="lazy">'
        odoo.innerHTML = '<img src="imagenes/odoo.png" alt="Réplica del ERP Odoo" loading="lazy">'
        bbdd.innerHTML = '<img src="imagenes/bbdd.png" alt="Base de datos de un hospital" loading="lazy">'

        //Formación
        formacion1.innerHTML = "Experiencia"
        ciberseguridad2.innerHTML = "Ciberseguridad"
        programacion2.innerHTML = "Programación"
        inetexto.innerHTML = "Certificación de pentesting que cubre técnicas de reconocimiento, enumeración, explotación de vulnerabilidades, escalado de privilegios y pivoting entre otras"
        isc2texto.innerHTML = "Certificación base de ciberseguridad que abarca dominios de seguridad, prácticas y leyes y regulaciones"
        master.innerHTML = "Master en Ciberseguridad"
        mastertexto.innerHTML = "Especializandome de forma práctica en proteger sistemas, analizar datos, investigar ciberdelitos y desarrollar habilidades de hacking."
        dam.innerHTML = "Grado en DAM"
        damtexto.innerHTML = "Aprendiendo a crear aplicaciones desde backend hasta frontend mejorando la experiencia de usuario."
        robotica.innerHTML = "Curso de Robótica"
        roboticatexto.innerHTML = "Desarrollando conocimientos de programación, demostrando mi capacidad de trabajar en equipo, organizar proyectos y resolver problemas."
        visavetanio.innerHTML = "2025 - Actualidad";
        visavet.innerHTML = "Programador - VISAVET"
        visavettexto.innerHTML = "Desarrollo software y bases de datos seguras para la gestión y análisis de información científica, junto con la administración de sistemas y soporte informático integral."

        //contacto
        contact1.innerHTML = "Contacto"
        misdatos.innerHTML = 'Mis datos';
        locationtext.innerHTML = 'Madrid, España';
        contactarme1.innerHTML = 'Contactarme';
        formulario.innerHTML = '<input type="text" name="name" id="nomretexto" class="inputdatos" placeholder="Nombre" aria-label="Nombre"><input type="email" name="email" class="inputdatos" placeholder="Correo electronico" aria-label="Correo electrónico"><textarea name="message" placeholder="Mensaje" class="textdatos" cols="30" rows="10" aria-label="Mensaje"></textarea>'
        send.innerHTML = 'Enviar';
        gracias.innerHTML = '¡Gracias por visitar mi sitio Web!';


    }

});


document.getElementById('anio').textContent = new Date().getFullYear();
