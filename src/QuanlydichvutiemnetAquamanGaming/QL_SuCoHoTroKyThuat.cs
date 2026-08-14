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

namespace QuanlydichvutiemnetAquamanGaming
{
    public partial class QL_SuCoHoTroKyThuat : Form
    {
        string connectionString = @"Data Source=LAPTOP-FFG392QU;Initial Catalog=QLDVTN;Integrated Security=True";

        public QL_SuCoHoTroKyThuat()
        {
            InitializeComponent();
            LoadSuCo();
        }

        private void LoadSuCo()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT * FROM SUCOKYTHUAT ORDER BY TGYeuCau";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvSuCo.DataSource = dt;

                dgvSuCo.Columns["MaKT"].ReadOnly = true;
                dgvSuCo.Columns["MaMay"].ReadOnly = true;
                dgvSuCo.Columns["MaNV"].ReadOnly = true;
                dgvSuCo.Columns["MaND"].ReadOnly = true;
                dgvSuCo.Columns["TGYeuCau"].ReadOnly = true;
                dgvSuCo.Columns["TrangThaiSC"].ReadOnly = true;

                dgvSuCo.Columns["MoTaVanDe"].ReadOnly = false; // Chỉ cho sửa mô tả
            }
        }

        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            string mota = txtMoTaTimKiem.Text.Trim();
            string trangthai = GetTrangThai();  // Hàm đọc radio button
            DateTime fromDay = dtpFromDay.Value.Date;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query =
                    "SELECT * FROM SUCOKYTHUAT WHERE " +
                    "MoTaVanDe LIKE @mota AND " +
                    "TGYeuCau >= @fromDay AND " +
                    "(TrangThaiSC = @trangthai OR @trangthai = '')";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@mota", "%" + mota + "%");
                cmd.Parameters.AddWithValue("@fromDay", fromDay);
                cmd.Parameters.AddWithValue("@trangthai", trangthai ?? "");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvSuCo.DataSource = dt;

                if (dt.Rows.Count == 0)
                {
                    MessageBox.Show("Không tìm thấy dữ liệu!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
        }

        private string GetTrangThai()
        {
            if (rbChuaXL.Checked) return "Chưa xử lý";
            if (rbDangXL.Checked) return "Đang xử lý";
            if (rbDaXL.Checked) return "Đã xử lý";
            if (rbBaoTri.Checked) return "Bảo trì";
            return "";
        }

        private void btnHienThiTatCa_Click(object sender, EventArgs e)
        {
            txtMoTaTimKiem.Clear();
            rbChuaXL.Checked = rbDangXL.Checked = rbDaXL.Checked = rbBaoTri.Checked = false;
            dtpFromDay.Value = new DateTime(1800, 1, 1);

            LoadSuCo();
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dgvSuCo.Rows)
            {
                if (row.IsNewRow) continue;

                string ma = row.Cells["MaKT"].Value.ToString();
                string mota = row.Cells["MoTaVanDe"].Value?.ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "UPDATE SUCOKYTHUAT SET MoTaVanDe=@mota WHERE MaKT=@ma";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@mota", mota ?? "");
                    cmd.Parameters.AddWithValue("@ma", ma);
                    cmd.ExecuteNonQuery();
                }
            }

            MessageBox.Show($"Đã sửa thành công!", "Thông báo");
            LoadSuCo();
        }

        private void QL_SuCoHoTroKyThuat_Load(object sender, EventArgs e)
        {
            RandomSuCo();
            dtpFromDay.Value = new DateTime(1800, 1, 1);
        }

        private void RandomSuCo()
        {
            string maMay = LayMaMayNgauNhien();
            string moTa = LayMoTaNgauNhien();
            string maKT = SinhMaKT();

            txtThongBaoLon.Text =
                $"Mã sự cố: {maKT}\r\n" +
                $"Mã máy: {maMay}\r\n" +
                $"Mô tả: {moTa}";
        }

        private string LayMaMayNgauNhien()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT MaMay FROM MAYTINH ORDER BY NEWID()";
                SqlCommand cmd = new SqlCommand(query, conn);
                return cmd.ExecuteScalar().ToString();
            }
        }

        private string LayMoTaNgauNhien()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT TOP 1 MoTaVanDe FROM SUCOKYTHUAT WHERE MoTaVanDe IS NOT NULL ORDER BY NEWID()";
                SqlCommand cmd = new SqlCommand(query, conn);

                object kq = cmd.ExecuteScalar();
                if (kq == null || kq.ToString() == "")
                    return "";

                return kq.ToString();
            }
        }

        private string SinhMaKT()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT TOP 1 MaKT FROM SUCOKYTHUAT ORDER BY MaKT DESC";
                SqlCommand cmd = new SqlCommand(query, conn);
                string last = cmd.ExecuteScalar()?.ToString() ?? "KT000";

                int num = int.Parse(last.Substring(2));
                return "KT" + (num + 1).ToString("000");
            }
        }

        private void btnXacNhan_Click(object sender, EventArgs e)
        {
            string text = txtThongBaoLon.Text;

            string maKT = Extract(text, "Mã sự cố:");
            string maMay = Extract(text, "Mã máy:");
            string moTa = Extract(text, "Mô tả:");

            DialogResult dr = MessageBox.Show("Xác nhận lưu yêu cầu hỗ trợ?", "Xác nhận", MessageBoxButtons.YesNo);
            if (dr == DialogResult.No) return;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query =
                    "INSERT INTO SUCOKYTHUAT (MaKT, TGYeuCau, MoTaVanDe, TrangThaiSC, MaMay) " +
                    "VALUES (@ma, GETDATE(), @mota, N'Đang xử lý', @mamay)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ma", maKT);
                cmd.Parameters.AddWithValue("@mota", moTa);
                cmd.Parameters.AddWithValue("@mamay", maMay);

                cmd.ExecuteNonQuery();
            }

            MessageBox.Show("Tạo yêu cầu hỗ trợ thành công!", "Thông báo");
            txtThongBaoLon.Clear();
            RandomSuCo();
            LoadSuCo();
        }

        private string Extract(string src, string key)
        {
            int index = src.IndexOf(key);
            if (index < 0) return "";
            index += key.Length;
            int end = src.IndexOf("\r\n", index);
            if (end < 0) end = src.Length;
            return src.Substring(index, end - index).Trim();
        }

        private void CapNhatTrangThai(string trangthai)
        {
            if (dgvSuCo.SelectedRows.Count == 0)
            {
                MessageBox.Show("Vui lòng chọn dòng!", "Thông báo");
                return;
            }

            foreach (DataGridViewRow row in dgvSuCo.SelectedRows)
            {
                string ma = row.Cells["MaKT"].Value.ToString();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "UPDATE SUCOKYTHUAT SET TrangThaiSC=@tt WHERE MaKT=@ma";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@tt", trangthai);
                    cmd.Parameters.AddWithValue("@ma", ma);
                    cmd.ExecuteNonQuery();
                }
            }

            MessageBox.Show("Cập nhật trạng thái thành công!", "Thông báo");
            LoadSuCo();
        }

        private void btnChuaXL_Click(object sender, EventArgs e)
        {
            CapNhatTrangThai("Chưa xử lý");
        }

        private void btnHoanThanh_Click(object sender, EventArgs e)
        {
            CapNhatTrangThai("Đã xử lý");
        }

        private void btnBaoTri_Click(object sender, EventArgs e)
        {
            CapNhatTrangThai("Bảo trì");
        }

        private void btnQuayLai_Click(object sender, EventArgs e)
        {
            TrangChu f = new TrangChu();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }
    }
}
