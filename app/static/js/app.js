
const TOKEN_KEY = "access_token";
const $ = (id) => document.getElementById(id);


// ------------------------------------------------ TOKEN

function getToken() {
    return sessionStorage.getItem(TOKEN_KEY);
}

function setToken(token) {
    if (token) sessionStorage.setItem(TOKEN_KEY, token);
    else sessionStorage.removeItem(TOKEN_KEY);
}

function payload() {
    const token = getToken();
    if (!token) return null;

    try {
        const part = token.split(".")[1]
            .replace(/-/g, "+")
            .replace(/_/g, "/");
        return JSON.parse(atob(part));
    } catch {
        return null;
    }
}


// ------------------------------------------------ API

async function api(path, { method = "GET", body } = {}) {
    const headers = { "Content-Type": "application/json" };
    const token = getToken();

    if (token) headers.Authorization = `Bearer ${token}`;

    const res = await fetch(path, {
        method,
        headers,
        body: body && JSON.stringify(body)
    });

    const data = await res.json().catch(() => ({}));

    if (res.status === 401 && token) {
        setToken(null);
        render();
    }

    if (!res.ok) throw new Error(data.message || `HTTP ${res.status}`);

    return data;
}


// ------------------------------------------------ VISTAS

function show(message, kind = "error") {
    const box = $("message");
    box.textContent = message;
    box.className = `flash flash-${kind}`;
    box.hidden = !message;
}

async function run(action) {
    show("");

    try {
        await action();
    } catch (err) {
        show(err.message);
    }
}

async function render() {
    const user = payload();
    const signedIn = Boolean(user) && user.exp * 1000 > Date.now();

    if (!signedIn) setToken(null);

    $("auth-view").hidden = signedIn;
    $("customers-view").hidden = !signedIn;
    $("logout").hidden = !signedIn;
    $("who").textContent = signedIn ? user.username : "";

    if (signedIn) {
        await loadCustomers();
        await loadTables();
    }
}


// ------------------------------------------------ CLIENTES

async function loadCustomers() {
    const { clientes } = await api("/api/customers");

    $("customer-list").replaceChildren(...clientes.map(customerItem));
    $("count").textContent = `(${clientes.length})`;
    $("empty").hidden = clientes.length > 0;
}

// Boton que ejecuta una accion y actualiza la lista
function button(text, className, action) {
    const b = document.createElement("button");

    b.type = "button";
    b.className = className;
    b.textContent = text;

    b.addEventListener("click", () => run(async () => {
        if (await action()) await loadCustomers();
    }));

    return b;
}

// Construir un elemento de la lista de clientes
function customerItem(customer) {
    const li = document.createElement("li");
    li.className = "todo-item";

    const body = document.createElement("div");
    body.className = "todo-body";

    const name = document.createElement("span");
    name.className = "todo-title";
    name.textContent = `${customer.first_name} ${customer.last_name}`;

    const details = document.createElement("p");
    details.className = "todo-description";
    details.textContent = `${customer.email || "Sin correo"} - ${customer.phone}`;

    body.append(name, details);

    const actions = document.createElement("div");
    actions.className = "todo-actions";

    // Editar cliente
    actions.append(button("Editar", "btn btn-small", () => {
        const first_name = prompt("Nombre", customer.first_name);
        if (first_name === null) return false;

        const last_name = prompt("Apellido", customer.last_name);
        if (last_name === null) return false;

        const email = prompt("Correo", customer.email || "");
        if (email === null) return false;

        const phone = prompt("Teléfono", customer.phone);
        if (phone === null) return false;

        return api(`/api/customers/${customer.id}`, {
            method: "PATCH",
            body: { first_name, last_name, email, phone }
        });
    }));

    // Eliminar cliente
    actions.append(button("Eliminar", "btn btn-small btn-danger", () =>
        confirm("¿Eliminar este cliente?") &&
        api(`/api/customers/${customer.id}`, { method: "DELETE" })
    ));

    li.append(body, actions);
    return li;
}


// ------------------------------------------------ MESAS

async function loadTables() {
    const { mesas } = await api("/api/tables");

    const items = mesas.map((table) => {
        const li = document.createElement("li");
        li.className = "todo-item";

        li.textContent = `Mesa ${table.table_number} -
        Capacidad: ${table.capacity} -
        ${table.is_active ? "Activa" : "Inactiva"}`;

        return li;
    });

    $("table-list").replaceChildren(...items);
    $("table-empty").hidden = mesas.length > 0;
}


// ------------------------------------------------ EVENTOS

function credentials() {
    return {
        username: $("username").value,
        password: $("password").value
    };
}

// Iniciar sesion
async function signIn() {
    const { access_token } = await api("/auth/login", {
        method: "POST",
        body: credentials()
    });

    setToken(access_token);
    $("login-form").reset();
    await render();
}

$("login-form").addEventListener("submit", (event) => {
    event.preventDefault();
    run(signIn);
});

// Registrar usuario
$("register").addEventListener("click", () => run(async () => {
    if (!$("login-form").reportValidity()) return;

    await api("/auth/register", {
        method: "POST",
        body: credentials()
    });

    await signIn();
    show("Cuenta creada correctamente.", "success");
}));

// Registrar cliente
$("create-form").addEventListener("submit", (event) => {
    event.preventDefault();

    const fields = event.target.elements;

    run(async () => {
        await api("/api/customers", {
            method: "POST",
            body: {
                first_name: fields.first_name.value,
                last_name: fields.last_name.value,
                email: fields.email.value,
                phone: fields.phone.value
            }
        });

        event.target.reset();
        await loadCustomers();
        show("Cliente registrado correctamente.", "success");
    });
});

// Cerrar sesion
$("logout").addEventListener("click", () => {
    setToken(null);
    render();
    show("Sesion cerrada.", "success");
});

run(render);
