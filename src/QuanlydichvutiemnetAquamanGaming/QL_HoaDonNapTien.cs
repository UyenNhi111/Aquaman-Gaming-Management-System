using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.Rebar;

namespace QuanlydichvutiemnetAquamanGaming
{
    public partial class QL_HoaDonNapTien : Form
    {
        private string connectionString="Server=YOUR_SERVER;Database=AquamanGaming;Trusted_Connection=True;"

        decimal soTienNap_global;
        string hinhThuc_global;

        public QL_HoaDonNapTien(decimal soTienNap, string hinhThuc)
        {
            InitializeComponent();
            soTienNap_global = soTienNap;
            hinhThuc_global = hinhThuc;

            TaoHoaDonNapTien();
        }

        private void TaoHoaDonNapTien()
        {
            string maHD = GenerateMaHDN();
            decimal soTienNap = soTienNap_global;
            decimal thanhTien = soTienNap; // không có KM

            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                string insert = @"
            INSERT INTO HOADONNAPTIEN(MaHDN, SoTienNap, HinhThucNT, KhuyenMaiNT, ThanhTienNT)
            VALUES (@MaHDN, @SoTienNap, @HinhThuc, NULL, @ThanhTien)";

                SqlCommand cmd = new SqlCommand(insert, cn);
                cmd.Parameters.AddWithValue("@MaHDN", maHD);
                cmd.Parameters.AddWithValue("@SoTienNap", soTienNap);
                cmd.Parameters.AddWithValue("@HinhThuc", hinhThuc_global);
                cmd.Parameters.AddWithValue("@ThanhTien", thanhTien);
                cmd.ExecuteNonQuery();
            }

            MessageBox.Show("Tạo hóa đơn thành công! Mã: " + maHD);

            LoadDataHD();
        }

        private string GenerateMaHDN()
        {
            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                string sql = "SELECT MAX(MaHDN) FROM HOADONNAPTIEN";
                SqlCommand cmd = new SqlCommand(sql, cn);
                var obj = cmd.ExecuteScalar();

                if (obj == DBNull.Value || obj == null)
                    return "HDN0000001";

                string max = obj.ToString();
                string digits = new string(max.Where(char.IsDigit).ToArray());
                int num = int.Parse(digits) + 1;

                return "HDN" + num.ToString("D7");
            }
        }

        private void btnSearch_Click(object sender, EventArgs e)
        {
            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                cn.Open();
                string sql = "SELECT * FROM HOADONNAPTIEN WHERE 1=1";

                if (!string.IsNullOrWhiteSpace(txtMaHD.Text))
                    sql += " AND MaHDN LIKE @ma";

                if (!string.IsNullOrWhiteSpace(txtSoTien.Text))
                    sql += " AND SoTienNap = @st";

                if (rbTM.Checked)
                    sql += " AND HinhThucNT = N'Tiền mặt'";

                if (rbCK.Checked)
                    sql += " AND HinhThucNT = N'Chuyển khoản'";

                SqlCommand cmd = new SqlCommand(sql, cn);

                if (!string.IsNullOrWhiteSpace(txtMaHD.Text))
                    cmd.Parameters.AddWithValue("@ma", "%" + txtMaHD.Text + "%");

                if (!string.IsNullOrWhiteSpace(txtSoTien.Text))
                    cmd.Parameters.AddWithValue("@st", decimal.Parse(txtSoTien.Text));

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvHoaDon.DataSource = dt;
            }
        }

        private void btnShowAll_Click(object sender, EventArgs e)
        {
            txtMaHD.Text = "";
            txtSoTien.Text = "";
            rbTM.Checked = false;
            rbCK.Checked = false;

            LoadDataHD();
        }

        private void LoadDataHD()
        {
            using (SqlConnection cn = new SqlConnection(connectionString))
            {
                string sql = "SELECT MaHDN, SoTienNap, HinhThucNT, KhuyenMaiNT, ThanhTienNT, MaND, MaKM, MaNV FROM HOADONNAPTIEN ORDER BY MaHDN";
                using (SqlDataAdapter da = new SqlDataAdapter(sql, cn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    dgvHoaDon.DataSource = dt;
                }
            }
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            QL_DangKyTaiKhoan f = new QL_DangKyTaiKhoan();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }
    }
}
