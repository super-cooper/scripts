let db = new Mongo().getDB('admin');
db.createUser({
    user: 'admin', 
    pwd: 'password', 
    roles: ["userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase", { role: "root", db: "admin" }]
});
