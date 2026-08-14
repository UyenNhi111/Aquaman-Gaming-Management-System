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
using static System.Windows.Forms.VisualStyles.VisualStyleElement.Tab;

namespace QuanlydichvutiemnetAquamanGaming
{
    public partial class QL_ThongTinNguoiDung : Form
    {
        string connectionString="Server=YOUR_SERVER;Database=AquamanGaming;Trusted_Connection=True;"

        public QL_ThongTinNguoiDung()
        {
            InitializeComponent();
        }

        private void btnQuayLai_Click(object sender, EventArgs e)
        {
            TrangChu f = new TrangChu();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }

        private void QL_ThongTinNguoiDung_Load(object sender, EventArgs e)
        {
            dtpTuNgay.Value = new DateTime(1800, 1, 1);
            dtpDenNgay.Value = DateTime.Now;
            LoadData();
            dgvNguoiDung.Columns["MaND"].ReadOnly = true;
        }

        private void LoadData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM NGUOIDUNG ORDER BY MaND";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                dgvNguoiDung.DataSource = dt;
            }
        }

        private string TaoMaTuDong()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string query = "SELECT TOP 1 MaND FROM NGUOIDUNG ORDER BY MaND DESC";
                SqlCommand cmd = new SqlCommand(query, conn);
                object result = cmd.ExecuteScalar();

                if (result == null)
                {
                    return "ND000001";
                }
                else
                {
                    string maCu = result.ToString();         // ND000015
                    int so = int.Parse(maCu.Substring(2));    // 15
                    so++;
                    return "ND" + so.ToString("D6");
                }
            }
        }

        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            string hoten = txtHoTen.Text.Trim();
            string sdt = txtSDT.Text.Trim();
            string gioitinh = rdoNam.Checked ? "Nam" : (rdoNu.Checked ? "Nữ" : "");
            DateTime tuNgay = dtpTuNgay.Value;
            DateTime denNgay = dtpDenNgay.Value;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query =
                "SELECT * FROM NGUOIDUNG WHERE " +
                "HoTen LIKE @hoten AND " +
                "SDT LIKE @sdt AND " +
                "NgaySinh BETWEEN @tu AND @den ";

                if (gioitinh != "")
                {
                    query += " AND GioiTinh = @gioitinh ";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@hoten", "%" + hoten + "%");
                cmd.Parameters.AddWithValue("@sdt", "%" + sdt + "%");
                cmd.Parameters.AddWithValue("@tu", tuNgay);
                cmd.Parameters.AddWithValue("@den", denNgay);
                if (gioitinh != "") cmd.Parameters.AddWithValue("@gioitinh", gioitinh);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                dgvNguoiDung.DataSource = dt;

                if (dt.Rows.Count == 0)
                {
                    MessageBox.Show("Không tìm thấy dữ liệu!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            int countThem = 0; // Đếm số dòng thêm thành công

            foreach (DataGridViewRow row in dgvNguoiDung.Rows)
            {
                if (row.IsNewRow) continue;

                // Nếu MaND rỗng => dòng mới cần thêm
                if (string.IsNullOrEmpty(row.Cells["MaND"].Value?.ToString()))
                {
                    string hoten = row.Cells["HoTen"].Value?.ToString()?.Trim();
                    string sdt = row.Cells["SDT"].Value?.ToString()?.Trim();
                    string gioiTinh = row.Cells["GioiTinh"].Value?.ToString()?.Trim();
                    DateTime ngaySinh;

                    if (!DateTime.TryParse(row.Cells["NgaySinh"].Value?.ToString(), out ngaySinh))
                        ngaySinh = DateTime.Now; // Mặc định ngày hiện tại

                    if (string.IsNullOrEmpty(hoten) || string.IsNullOrEmpty(sdt))
                    {
                        MessageBox.Show("Họ tên và SĐT là bắt buộc! Dòng này sẽ bị bỏ qua.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        LoadData(); // Load lại dgv để bỏ dòng lỗi
                        return;
                    }

                    string ma = TaoMaTuDong(); // Hàm tự tăng mã

                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        string query = "INSERT INTO NGUOIDUNG (MaND, HoTen, GioiTinh, NgaySinh, SDT) " +
                                       "VALUES (@ma, @hoten, @gioitinh, @ngay, @sdt)";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@ma", ma);
                        cmd.Parameters.AddWithValue("@hoten", hoten);
                        cmd.Parameters.AddWithValue("@gioitinh", gioiTinh);
                        cmd.Parameters.AddWithValue("@ngay", ngaySinh);
                        cmd.Parameters.AddWithValue("@sdt", sdt);
                        cmd.ExecuteNonQuery();
                    }

                    countThem++;
                }
            }

            if (countThem > 0)
            {
                MessageBox.Show($"Đã thêm thành công {countThem} dòng!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadData(); // Reload lại dgv
            }
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dgvNguoiDung.Rows)
            {
                if (row.IsNewRow) continue;

                string ma = row.Cells["MaND"].Value?.ToString();
                if (string.IsNullOrEmpty(ma)) continue; // Bỏ qua dòng mới chưa có MaND

                string hoten = row.Cells["HoTen"].Value?.ToString()?.Trim();
                string sdt = row.Cells["SDT"].Value?.ToString()?.Trim();
                string gioiTinh = row.Cells["GioiTinh"].Value?.ToString()?.Trim();
                DateTime ngaySinh;

                if (!DateTime.TryParse(row.Cells["NgaySinh"].Value?.ToString(), out ngaySinh))
                {
                    MessageBox.Show($"Dòng MaND={ma} bị bỏ qua vì Ngày sinh không hợp lệ!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    continue; // Bỏ qua nếu ngày không hợp lệ
                }    

                if (string.IsNullOrEmpty(hoten) || string.IsNullOrEmpty(sdt))
                {
                    MessageBox.Show($"Dòng MaND={ma} bị bỏ qua vì thiếu Họ tên hoặc SĐT!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    continue;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "UPDATE NGUOIDUNG SET HoTen=@hoten, GioiTinh=@gioiTinh, NgaySinh=@ngay, SDT=@sdt WHERE MaND=@ma";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@hoten", hoten);
                    cmd.Parameters.AddWithValue("@gioiTinh", gioiTinh);
                    cmd.Parameters.AddWithValue("@ngay", ngaySinh);
                    cmd.Parameters.AddWithValue("@sdt", sdt);
                    cmd.Parameters.AddWithValue("@ma", ma);

                    cmd.ExecuteNonQuery();
                }
            }

            MessageBox.Show($"Đã sửa thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
            LoadData(); // Load lại dgv
            
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (dgvNguoiDung.SelectedRows.Count == 0)
            {
                MessageBox.Show("Vui lòng chọn dòng để xóa!", "Thông báo");
                return;
            }

            DialogResult dr = MessageBox.Show("Bạn có chắc chắn muốn xóa?", "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (dr == DialogResult.No) return;

            foreach (DataGridViewRow row in dgvNguoiDung.SelectedRows)
            {
                string ma = row.Cells["MaND"].Value?.ToString();
                if (string.IsNullOrEmpty(ma)) continue;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "DELETE FROM NGUOIDUNG WHERE MaND=@ma";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ma", ma);
                    cmd.ExecuteNonQuery();
                }
            }

            MessageBox.Show("Xóa thành công!", "Thông báo");
            LoadData();
        }

        private void btnHienThiTatCa_Click(object sender, EventArgs e)
        {
            txtHoTen.Clear();
            txtSDT.Clear();
            rdoNam.Checked = false;
            rdoNu.Checked = false;
            dtpTuNgay.Value = new DateTime(1800, 1, 1);
            dtpDenNgay.Value = DateTime.Now;

            LoadData();
        }
    }
}
