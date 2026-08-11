const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const User = sequelize.define("User", {
    id: { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true },
    name: { type: DataTypes.STRING, allowNull: false },
    email: { type: DataTypes.STRING, allowNull: false, unique: true },
    password: { type: DataTypes.STRING },
    phone: { type: DataTypes.STRING },
    address: { type: DataTypes.TEXT },
    role: { type: DataTypes.ENUM("customer", "admin"), defaultValue: "customer" },
    refreshToken: { type: DataTypes.TEXT },
    fcmToken: { type: DataTypes.STRING },
}, { tableName: "users", timestamps: true });

module.exports = User;
