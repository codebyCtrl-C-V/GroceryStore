const User = require("../models/User");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const dotenv = require("dotenv");

dotenv.config();

class UserController {
  //[post] /login
  async login(req, res) {
    const { email, password } = req.body;

    try {
      // Kiểm tra user có tồn tại không
      const user = await User.findOne({ where: { email } });
      if (!user) {
        return res.status(401).json({ status: "error", message: "Sai email hoặc mật khẩu" });
      }

      // Kiểm tra mật khẩu
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        return res.status(401).json({ status: "error", message: "Sai email hoặc mật khẩu" });
      }

      // Tạo Access Token
      const accessToken = jwt.sign(
        { id: user.id, email: user.email, role: user.role, name: user.name },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES || '15m' }
      );

      // Tạo Refresh Token
      const refreshSecret = process.env.JWT_REFRESH_SECRET || process.env.JWT_SECRET;
      const refreshToken = jwt.sign(
        { id: user.id },
        refreshSecret,
        { expiresIn: process.env.JWT_REFRESH_EXPIRES || '7d' }
      );

      // Lưu Refresh Token vào Database
      user.refreshToken = refreshToken;
      await user.save();

      // (Optional) Vẫn có thể lưu refresh token vào cookie nếu muốn
      res.cookie("refreshToken", refreshToken, {
        httpOnly: true,
        maxAge: 7 * 24 * 60 * 60 * 1000,
      });

      return res.json({
        status: "success",
        data: {
          user: { id: user.id, name: user.name, email: user.email, role: user.role },
          accessToken,
          refreshToken
        }
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ status: "error", message: "Lỗi server" });
    }
  }

  //[post] /register
  async register(req, res) {
    const { name, email, password, repassword } = req.body;

    if (password !== repassword) {
      return res.status(400).json({ status: "error", message: "Mật khẩu nhập lại không khớp" });
    }

    try {
      const existingUser = await User.findOne({ where: { email } });
      if (existingUser) {
        return res.status(400).json({ status: "error", message: "Email đã tồn tại" });
      }

      const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS) || 10;
      const hashedPassword = await bcrypt.hash(password, saltRounds);

      const newUser = await User.create({
        name,
        email,
        password: hashedPassword,
      });

      return res.status(201).json({ status: "success", message: "Đăng ký thành công" });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ status: "error", message: "Lỗi server" });
    }
  }

  //[post] /refresh-token
  async refreshToken(req, res) {
    const { refreshToken } = req.body;
    const token = refreshToken || req.cookies.refreshToken;

    if (!token) {
      return res.status(401).json({ status: "error", message: "Không tìm thấy Refresh Token" });
    }

    try {
      const refreshSecret = process.env.JWT_REFRESH_SECRET || process.env.JWT_SECRET;
      const decoded = jwt.verify(token, refreshSecret);

      const user = await User.findByPk(decoded.id);
      if (!user || user.refreshToken !== token) {
        return res.status(403).json({ status: "error", message: "Refresh Token không hợp lệ" });
      }

      // Tạo Access Token mới
      const newAccessToken = jwt.sign(
        { id: user.id, email: user.email, role: user.role, name: user.name },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES || '15m' }
      );

      return res.json({
        status: "success",
        data: { accessToken: newAccessToken }
      });
    } catch (error) {
      console.error("Refresh token error:", error);
      return res.status(403).json({ status: "error", message: "Refresh Token hết hạn hoặc không hợp lệ" });
    }
  }

  //[post] /logout
  async logout(req, res) {
    try {
      // Clear token from DB if user is logged in
      if (req.user && req.user.id) {
        await User.update({ refreshToken: null }, { where: { id: req.user.id } });
      } else {
        // If not authenticated via req.user, try to clear by looking up token
        const token = req.body.refreshToken || req.cookies.refreshToken;
        if (token) {
           await User.update({ refreshToken: null }, { where: { refreshToken: token } });
        }
      }
      
      res.clearCookie("refreshToken");
      res.clearCookie("token"); // clear old token cookie just in case
      return res.json({ status: "success", message: "Đăng xuất thành công" });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ status: "error", message: "Lỗi server" });
    }
  }

  //[get] /profile
  async profile(req, res) {
    try {
      const user = await User.findByPk(req.user.id, {
        attributes: { exclude: ['password', 'refreshToken'] }
      });
      return res.json({ status: "success", data: user });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ status: "error", message: "Lỗi server" });
    }
  }

  //[post] /profile
  async updateProfile(req, res) {
    const { name, phone, address } = req.body;
    try {
      await User.update(
        { name, phone, address },
        { where: { id: req.user.id } }
      );
      return res.json({ status: "success", message: "Cập nhật thông tin thành công!" });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ status: "error", message: "Lỗi server" });
    }
  }

  //[post] /profile/change-password
  async changePassword(req, res) {
    const { oldpass, newpass, renewpass } = req.body;
    try {
      const user = await User.findByPk(req.user.id);
      const isMatch = await bcrypt.compare(oldpass, user.password);
      if (!isMatch) {
        return res.status(400).json({ status: "error", message: "Mật khẩu cũ không chính xác" });
      }

      if (newpass !== renewpass) {
        return res.status(400).json({ status: "error", message: "Mật khẩu mới không khớp" });
      }

      const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS) || 10;
      const hashedPassword = await bcrypt.hash(newpass, saltRounds);

      await User.update(
        { password: hashedPassword },
        { where: { id: req.user.id } }
      );

      return res.json({ status: "success", message: "Đổi mật khẩu thành công!" });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ status: "error", message: "Lỗi server" });
    }
  }
}

module.exports = new UserController();
