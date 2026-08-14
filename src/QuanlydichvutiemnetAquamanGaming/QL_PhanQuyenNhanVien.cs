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
    public partial class QL_PhanQuyenNhanVien : Form
    {
        string connectionString="Server=YOUR_SERVER;Database=AquamanGaming;Trusted_Connection=True;"

        public QL_PhanQuyenNhanVien()
        {
            InitializeComponent();
            dtpNgayTao.Value = new DateTime(1800, 1, 1); // Mặc định từ 01/01/1800
            LoadData();
        }

        private string TaoMaNV()
        {
            string ma = "NV001";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT TOP 1 MaNV FROM NHANVIEN ORDER BY MaNV DESC";
                SqlCommand cmd = new SqlCommand(query, conn);
                var result = cmd.ExecuteScalar();

                if (result != null)
                {
                    string last = result.ToString().Substring(2);
                    int number = int.Parse(last) + 1;
                    ma = "NV" + number.ToString("000");
                }
            }
            return ma;
        }

        private string TaoMaTKNV()
        {
            string ma = "TKNV001";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT TOP 1 MaTKNV FROM TAIKHOANNHANVIEN ORDER BY MaTKNV DESC";
                SqlCommand cmd = new SqlCommand(query, conn);
                var result = cmd.ExecuteScalar();

                if (result != null)
                {
                    string last = result.ToString().Substring(4);
                    int number = int.Parse(last) + 1;
                    ma = "TKNV" + number.ToString("000");
                }
            }
            return ma;
        }

        private void TaoTaiKhoan(string chucVu)
        {
            string tendn = txtTenDangNhap.Text.Trim();
            string mk = txtMatKhau.Text.Trim();

            if (string.IsNullOrEmpty(tendn) || string.IsNullOrEmpty(mk))
            {
                MessageBox.Show("Tên đăng nhập và mật khẩu không được để trống!",
                    "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string maNV = TaoMaNV();
            string maTKNV = TaoMaTKNV();
            DateTime ngayTao = DateTime.Now.Date;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                SqlTransaction tran = conn.BeginTransaction();

                try
                {
                    // Thêm nhân viên
                    string queryNV =
                        "INSERT INTO NHANVIEN (MaNV, HoTen, GioiTinh, ChucVu, NgaySinh, SDT, DiaChi) " +
                        "VALUES (@maNV, N'Chưa cập nhật', N'Khác', @chucvu, GETDATE(), '0000000000', N'Chưa cập nhật')";

                    SqlCommand cmdNV = new SqlCommand(queryNV, conn, tran);
                    cmdNV.Parameters.AddWithValue("@maNV", maNV);
                    cmdNV.Parameters.AddWithValue("@chucvu", chucVu);
                    cmdNV.ExecuteNonQuery();

                    // Thêm tài khoản
                    string queryTK =
                        "INSERT INTO TAIKHOANNHANVIEN (MaTKNV, TenDangNhapNV, MatKhau, NgayTao, MaNV) " +
                        "VALUES (@maTK, @tendn, @mk, @ngay, @manv)";

                    SqlCommand cmdTK = new SqlCommand(queryTK, conn, tran);
                    cmdTK.Parameters.AddWithValue("@maTK", maTKNV);
                    cmdTK.Parameters.AddWithValue("@tendn", tendn);
                    cmdTK.Parameters.AddWithValue("@mk", mk);
                    cmdTK.Parameters.AddWithValue("@ngay", ngayTao);
                    cmdTK.Parameters.AddWithValue("@manv", maNV);
                    cmdTK.ExecuteNonQuery();

                    tran.Commit();
                }
                catch
                {
                    tran.Rollback();
                    MessageBox.Show("Lỗi khi tạo tài khoản!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
            }

            MessageBox.Show("Tạo tài khoản thành công!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
            LoadData();
        }

        private void btnCapQuyenQ_Click(object sender, EventArgs e)
        {
            TaoTaiKhoan("Nhân viên quầy");
        }

        private void btnCapQuyenPV_Click(object sender, EventArgs e)
        {
            TaoTaiKhoan("Nhân viên phục vụ");
        }

        private void btnCapQuyenKT_Click(object sender, EventArgs e)
        {
            TaoTaiKhoan("Nhân viên kỹ thuật");
        }

        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            string tendn = txtTenDangNhapTK.Text.Trim();
            DateTime from = dtpNgayTao.Value.Date;
            DateTime to = DateTime.Now.Date;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"SELECT tk.MaTKNV, tk.TenDangNhapNV, tk.MatKhau, tk.NgayTao, 
                                tk.MaNV, nv.HoTen, nv.ChucVu
                         FROM TAIKHOANNHANVIEN tk
                         JOIN NHANVIEN nv ON tk.MaNV = nv.MaNV
                         WHERE tk.NgayTao BETWEEN @from AND @to
                         AND tk.TenDangNhapNV LIKE @tendn";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@from", from);
                cmd.Parameters.AddWithValue("@to", to);
                cmd.Parameters.AddWithValue("@tendn", "%" + tendn + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                dgvTKNhanVien.DataSource = dt;

                // Chỉ cho phép chỉnh sửa mật khẩu
                dgvTKNhanVien.Columns["MaTKNV"].ReadOnly = true;
                dgvTKNhanVien.Columns["TenDangNhapNV"].ReadOnly = true;
                dgvTKNhanVien.Columns["NgayTao"].ReadOnly = true;
                dgvTKNhanVien.Columns["MaNV"].ReadOnly = true;
                dgvTKNhanVien.Columns["HoTen"].ReadOnly = true;
                dgvTKNhanVien.Columns["ChucVu"].ReadOnly = true;

                if (dt.Rows.Count == 0)
                {
                    MessageBox.Show("Không tìm thấy dữ liệu!", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
        }

        private void btnThuHoi_Click(object sender, EventArgs e)
        {
            if (dgvTKNhanVien.SelectedRows.Count == 0)
            {
                MessageBox.Show("Vui lòng chọn tài khoản để thu hồi!");
                return;
            }

            string maTKNV = dgvTKNhanVien.SelectedRows[0].Cells["MaTKNV"].Value.ToString();
            string maNV = dgvTKNhanVien.SelectedRows[0].Cells["MaNV"].Value.ToString();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string deleteTK = "DELETE FROM TAIKHOANNHANVIEN WHERE MaTKNV=@MaTKNV";
                SqlCommand cmdTK = new SqlCommand(deleteTK, conn);
                cmdTK.Parameters.AddWithValue("@MaTKNV", maTKNV);
                cmdTK.ExecuteNonQuery();

                string deleteNV = "DELETE FROM NHANVIEN WHERE MaNV=@MaNV";
                SqlCommand cmdNV = new SqlCommand(deleteNV, conn);
                cmdNV.Parameters.AddWithValue("@MaNV", maNV);
                cmdNV.ExecuteNonQuery();

                MessageBox.Show("Thu hồi quyền thành công!");
                LoadData();
            }
        }

        private void btnDoiMatKhau_Click(object sender, EventArgs e)
        {
            foreach (DataGridViewRow row in dgvTKNhanVien.Rows)
            {
                if (row.IsNewRow) continue;

                string ma = row.Cells["MaTKNV"].Value?.ToString();
                if (string.IsNullOrEmpty(ma)) continue;

                string mk = row.Cells["MatKhau"].Value?.ToString()?.Trim();

                if (string.IsNullOrEmpty(mk))
                {
                    MessageBox.Show($"Mật khẩu tài khoản {ma} không hợp lệ!",
                        "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    continue;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = "UPDATE TAIKHOANNHANVIEN SET MatKhau=@mk WHERE MaTKNV=@ma";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@mk", mk);
                    cmd.Parameters.AddWithValue("@ma", ma);
                    cmd.ExecuteNonQuery();
                }
            }

            MessageBox.Show("Đổi mật khẩu thành công!", "Thông báo");
            LoadData();
        }

        private void LoadData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT tk.MaTKNV, tk.TenDangNhapNV, tk.MatKhau, tk.NgayTao, tk.MaNV, nv.HoTen, nv.ChucVu
                                 FROM TAIKHOANNHANVIEN tk
                                 JOIN NHANVIEN nv ON tk.MaNV = nv.MaNV";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgvTKNhanVien.DataSource = dt;

                //chỉ cho sửa mật khẩu
                dgvTKNhanVien.Columns["MaTKNV"].ReadOnly = true;
                dgvTKNhanVien.Columns["TenDangNhapNV"].ReadOnly = true;
                dgvTKNhanVien.Columns["NgayTao"].ReadOnly = true;
                dgvTKNhanVien.Columns["MaNV"].ReadOnly = true;
                dgvTKNhanVien.Columns["HoTen"].ReadOnly = true;
                dgvTKNhanVien.Columns["ChucVu"].ReadOnly = true;
            }
        }

        private void btnHienThiTatCa_Click(object sender, EventArgs e)
        {
            dtpNgayTao.Value = new DateTime(1800, 1, 1);
            txtTenDangNhapTK.Clear();

            LoadData();
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
