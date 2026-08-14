using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QuanlydichvutiemnetAquamanGaming
{
    public partial class TrangChu : Form
    {
        public TrangChu()
        {
            InitializeComponent();
        }

        private void quảnLýĐăngKýTàiKhoảnToolStripMenuItem_Click(object sender, EventArgs e)
        {
            QL_DangKyTaiKhoan f = new QL_DangKyTaiKhoan();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }

        private void quảnLýThôngTinNgườiDùngToolStripMenuItem_Click(object sender, EventArgs e)
        {
            QL_ThongTinNguoiDung f = new QL_ThongTinNguoiDung();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }

        private void quảnLýDịchVụĂnUốngToolStripMenuItem_Click(object sender, EventArgs e)
        {
            QL_DichVuAnUong f = new QL_DichVuAnUong();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }

        private void quảnLýSựCốHỗTrợKỹThuậtToolStripMenuItem_Click(object sender, EventArgs e)
        {
            QL_SuCoHoTroKyThuat f = new QL_SuCoHoTroKyThuat();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }

        private void quảnLýBáoCáoThốngKêToolStripMenuItem_Click(object sender, EventArgs e)
        {
            QL_BaoCaoThongKe f = new QL_BaoCaoThongKe();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }

        private void quảnLýChươngTrìnhKhuyếnMãiToolStripMenuItem_Click(object sender, EventArgs e)
        {
            QL_ChuongTrinhKhuyenMai f = new QL_ChuongTrinhKhuyenMai();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }

        private void quảnLýPhânQuyềnNhânViênToolStripMenuItem_Click(object sender, EventArgs e)
        {
            QL_PhanQuyenNhanVien f = new QL_PhanQuyenNhanVien();
            this.Hide();
            f.ShowDialog();
            this.Close();
        }
    }
}
