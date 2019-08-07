let db = new Mongo().getDB('admin');
db.createUser({
    user: 'admin', 
    pwd: 'password', 
    roles: [
        {role: "userAdminAnyDatabase", db: "admin"}
    ]
});
