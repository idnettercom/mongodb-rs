## MongoDB Replica Set
```
chmod +x install.sh
```

## Membuat user MongoDB
```
db.createUser(
  {
    user: 'admin',
    pwd: 'ktsnd',
    roles: [ { role: 'root', db: 'admin' } ]
  }
);
```

## Inisiasi
```
rs.initiate()
```

atau

```
rs.initiate({
  _id: "myrs",
  members: [
    { _id: 0, host: "mongodb-01:27017" },
    { _id: 1, host: "mongodb-02:27017" }
  ]
})
```


## Add
```
rs.add("mongodb-03:27017")
```
