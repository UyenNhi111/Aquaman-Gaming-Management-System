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
    public partial class DangNhap_NV : Form
    {
        int soLanSai = 0;
        string connectionString = @"Data Source=LAPTOP-FFG392QU;Initial Catalog=QLDVTN;Integrated Security=True";

        public DangNhap_NV()
        {
            InitializeComponent();
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnDangNhap_Click(object sender, EventArgs e)
        {
            string ten = txtTenDangNhap.Text.Trim();
            string mk = txtMatKhau.Text.Trim();

            // kiểm tra bỏ trống
            if (ten == "" || mk == "")
            {
                MessageBox.Show("Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // kiểm tra tên đăng nhập có tồn tại không
                string queryUser = "SELECT MatKhau FROM TAIKHOANNHANVIEN WHERE TenDangNhapNV = @ten";
                SqlCommand cmd = new SqlCommand(queryUser, conn);
                cmd.Parameters.AddWithValue("@ten", ten);

                object matKhauDb = cmd.ExecuteScalar();

                if (matKhauDb == null)
                {
                    MessageBox.Show("Tên đăng nhập không tồn tại!", "Lỗi");
                    TangSoLanSai();
                    return;
                }

                // tên có rồi → kiểm tra mật khẩu
                if (mk != matKhauDb.ToString())
                {
                    MessageBox.Show("Sai mật khẩu!", "Lỗi");
                    TangSoLanSai();
                    return;
                }

                // đăng nhập thành công → mở form TrangChu
                MessageBox.Show("Đăng nhập thành công!",
                                "Thành công", MessageBoxButtons.OK, MessageBoxIcon.Information);
                soLanSai = 0;

                TrangChu f = new TrangChu();
                this.Hide();
                f.ShowDialog();
                this.Close();
            }
        }

        private void TangSoLanSai()
        {
            soLanSai++;
            if (soLanSai >= 5)
            {
                MessageBox.Show("Sai 5 lần! Ứng dụng sẽ đóng.",
                                "Cảnh báo", MessageBoxButtons.OK, MessageBoxIcon.Stop);
                this.Close();
            }
        }
    }
}
