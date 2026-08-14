using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace QuanlydichvutiemnetAquamanGaming
{
    public partial class DangNhap_ND : Form
    {
        private int soLanSai = 0;   // đếm số lần sai

        string connectionString = @"Data Source=LAPTOP-FFG392QU;Initial Catalog=QLDVTN;Integrated Security=True";

        public DangNhap_ND()
        {
            InitializeComponent();
        }

        private void btnDangNhap_Click(object sender, EventArgs e)
        {
            string username = txtTenDangNhap.Text.Trim();
            string password = txtMatKhau.Text.Trim();

            // 1. Kiểm tra có để trống không
            if (username == "")
            {
                MessageBox.Show("Tên đăng nhập không được để trống!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtTenDangNhap.Focus();
                return;
            }
            if (password == "")
            {
                MessageBox.Show("Mật khẩu không được để trống!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtMatKhau.Focus();
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 2. Kiểm tra tên đăng nhập có tồn tại không
                string queryUser = "SELECT MaTK, TenDangNhap, MatKhau FROM TAIKHOAN WHERE TenDangNhap = @TenDangNhap";

                SqlCommand cmd = new SqlCommand(queryUser, conn);
                cmd.Parameters.AddWithValue("@TenDangNhap", username);

                SqlDataReader reader = cmd.ExecuteReader();

                if (!reader.HasRows)
                {
                    soLanSai++;
                    MessageBox.Show("Tên đăng nhập không tồn tại!", "Lỗi");

                    KiemTraQua5Lan();
                    return;
                }

                // 3. Nếu tồn tại → đọc mật khẩu
                string mkTrongDB = "";
                while (reader.Read())
                {
                    mkTrongDB = reader["MatKhau"].ToString();
                }
                reader.Close();

                // 4. So sánh mật khẩu
                if (password != mkTrongDB)
                {
                    soLanSai++;
                    MessageBox.Show("Mật khẩu không chính xác!", "Lỗi");

                    KiemTraQua5Lan();
                    return;
                }

                // 5. Đúng → đăng nhập thành công
                MessageBox.Show("Đăng nhập thành công! Mời bạn sử dụng máy tính.",
                                "Thành công", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void KiemTraQua5Lan()
        {
            if (soLanSai >= 5)
            {
                MessageBox.Show("Bạn đã nhập sai 5 lần! Máy tính sẽ tự động tắt.",
                                "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Stop);
                this.Close();
            }
        }
    }
}
