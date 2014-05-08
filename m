From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [PATCH] drivers: scsi: mvsas: fix compiling issue by adding 'MVS_'
 for "enum pci_interrupt_cause"
Date: Fri, 09 May 2014 07:45:20 +0800
Message-ID: <536C1710.1010108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The direct cause is IRQ_SPI is already defined as a macro in unicore32
architecture (also, blackfin and mips architectures define it). The
related error (unicore32  with allmodconfig)

    CC [M]  drivers/scsi/mvsas/mv_94xx.o
  In file included from drivers/scsi/mvsas/mv_94xx.c:27:
  drivers/scsi/mvsas/mv_94xx.h:176: error: expected identifier before numeric constant

And "enum pci_interrupt_cause" may will be useful for kernel drivers,
although at present, it is not used in kernel. So add 'MVS_' for it.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/scsi/mvsas/mv_94xx.h | 58 ++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index 487aa6f..14e1974 100644
--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -150,35 +150,35 @@ enum chip_register_bits {
 
 enum pci_interrupt_cause {
 	/*  MAIN_IRQ_CAUSE (R10200) Bits*/
-	IRQ_COM_IN_I2O_IOP0            = (1 << 0),
-	IRQ_COM_IN_I2O_IOP1            = (1 << 1),
-	IRQ_COM_IN_I2O_IOP2            = (1 << 2),
-	IRQ_COM_IN_I2O_IOP3            = (1 << 3),
-	IRQ_COM_OUT_I2O_HOS0           = (1 << 4),
-	IRQ_COM_OUT_I2O_HOS1           = (1 << 5),
-	IRQ_COM_OUT_I2O_HOS2           = (1 << 6),
-	IRQ_COM_OUT_I2O_HOS3           = (1 << 7),
-	IRQ_PCIF_TO_CPU_DRBL0          = (1 << 8),
-	IRQ_PCIF_TO_CPU_DRBL1          = (1 << 9),
-	IRQ_PCIF_TO_CPU_DRBL2          = (1 << 10),
-	IRQ_PCIF_TO_CPU_DRBL3          = (1 << 11),
-	IRQ_PCIF_DRBL0                 = (1 << 12),
-	IRQ_PCIF_DRBL1                 = (1 << 13),
-	IRQ_PCIF_DRBL2                 = (1 << 14),
-	IRQ_PCIF_DRBL3                 = (1 << 15),
-	IRQ_XOR_A                      = (1 << 16),
-	IRQ_XOR_B                      = (1 << 17),
-	IRQ_SAS_A                      = (1 << 18),
-	IRQ_SAS_B                      = (1 << 19),
-	IRQ_CPU_CNTRL                  = (1 << 20),
-	IRQ_GPIO                       = (1 << 21),
-	IRQ_UART                       = (1 << 22),
-	IRQ_SPI                        = (1 << 23),
-	IRQ_I2C                        = (1 << 24),
-	IRQ_SGPIO                      = (1 << 25),
-	IRQ_COM_ERR                    = (1 << 29),
-	IRQ_I2O_ERR                    = (1 << 30),
-	IRQ_PCIE_ERR                   = (1 << 31),
+	MVS_IRQ_COM_IN_I2O_IOP0        = (1 << 0),
+	MVS_IRQ_COM_IN_I2O_IOP1        = (1 << 1),
+	MVS_IRQ_COM_IN_I2O_IOP2        = (1 << 2),
+	MVS_IRQ_COM_IN_I2O_IOP3        = (1 << 3),
+	MVS_IRQ_COM_OUT_I2O_HOS0       = (1 << 4),
+	MVS_IRQ_COM_OUT_I2O_HOS1       = (1 << 5),
+	MVS_IRQ_COM_OUT_I2O_HOS2       = (1 << 6),
+	MVS_IRQ_COM_OUT_I2O_HOS3       = (1 << 7),
+	MVS_IRQ_PCIF_TO_CPU_DRBL0      = (1 << 8),
+	MVS_IRQ_PCIF_TO_CPU_DRBL1      = (1 << 9),
+	MVS_IRQ_PCIF_TO_CPU_DRBL2      = (1 << 10),
+	MVS_IRQ_PCIF_TO_CPU_DRBL3      = (1 << 11),
+	MVS_IRQ_PCIF_DRBL0             = (1 << 12),
+	MVS_IRQ_PCIF_DRBL1             = (1 << 13),
+	MVS_IRQ_PCIF_DRBL2             = (1 << 14),
+	MVS_IRQ_PCIF_DRBL3             = (1 << 15),
+	MVS_IRQ_XOR_A                  = (1 << 16),
+	MVS_IRQ_XOR_B                  = (1 << 17),
+	MVS_IRQ_SAS_A                  = (1 << 18),
+	MVS_IRQ_SAS_B                  = (1 << 19),
+	MVS_IRQ_CPU_CNTRL              = (1 << 20),
+	MVS_IRQ_GPIO                   = (1 << 21),
+	MVS_IRQ_UART                   = (1 << 22),
+	MVS_IRQ_SPI                    = (1 << 23),
+	MVS_IRQ_I2C                    = (1 << 24),
+	MVS_IRQ_SGPIO                  = (1 << 25),
+	MVS_IRQ_COM_ERR                = (1 << 29),
+	MVS_IRQ_I2O_ERR                = (1 << 30),
+	MVS_IRQ_PCIE_ERR               = (1 << 31),
 };
 
 union reg_phy_cfg {
-- 
1.9.2.459.g68773ac
