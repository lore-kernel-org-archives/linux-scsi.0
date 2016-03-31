From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v12 4/9] added unipro attributes
Date: Thu, 31 Mar 2016 19:57:17 +0100
Message-ID: <be09c73e45e0b2274f2c2d8d54b09f263997c1ab.1459448160.git.jpinto@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tomas.winkler@intel.com
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

Added unipro attributes.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
Changes v0->v12 (Tomas Winkler):
- This patch only appeared in v12

 drivers/scsi/ufs/unipro.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 816a8a4..da16254 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -35,6 +35,10 @@
 #define TX_LCC_SEQUENCER			0x0032
 #define TX_MIN_ACTIVATETIME			0x0033
 #define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
+#define TX_REFCLKFREQ				0x00EB
+#define TX_CFGCLKFREQVAL			0x00EC
+#define	CFGEXTRATTR				0x00F0
+#define DITHERCTRL2				0x00F1
 
 /*
  * M-RX Configuration Attributes
@@ -48,8 +52,38 @@
 #define RX_ENTER_HIBERN8			0x00A7
 #define RX_BYPASS_8B10B_ENABLE			0x00A8
 #define RX_TERMINATION_FORCE_ENABLE		0x0089
+#define RX_REFCLKFREQ				0x00EB
+#define	RX_CFGCLKFREQVAL			0x00EC
+#define CFGWIDEINLN				0x00F0
+#define CFGRXCDR8				0x00BA
+#define ENARXDIRECTCFG4				0x00F2
+#define CFGRXOVR8				0x00BD
+#define RXDIRECTCTRL2				0x00C7
+#define ENARXDIRECTCFG3				0x00F3
+#define RXCALCTRL				0x00B4
+#define ENARXDIRECTCFG2				0x00F4
+#define CFGRXOVR4				0x00E9
+#define RXSQCTRL				0x00B5
+#define CFGRXOVR6				0x00BF
 
 #define is_mphy_tx_attr(attr)			(attr < RX_MODE)
+
+/*
+ * Common Block Attributes
+ */
+#define TX_GLOBALHIBERNATE			UNIPRO_CB_OFFSET(0x002B)
+#define REFCLKMODE				UNIPRO_CB_OFFSET(0x00BF)
+#define DIRECTCTRL19				UNIPRO_CB_OFFSET(0x00CD)
+#define DIRECTCTRL10				UNIPRO_CB_OFFSET(0x00E6)
+#define CDIRECTCTRL6				UNIPRO_CB_OFFSET(0x00EA)
+#define RTOBSERVESELECT				UNIPRO_CB_OFFSET(0x00F0)
+#define CBDIVFACTOR				UNIPRO_CB_OFFSET(0x00F1)
+#define CBDCOCTRL5				UNIPRO_CB_OFFSET(0x00F3)
+#define CBPRGPLL2				UNIPRO_CB_OFFSET(0x00F8)
+#define CBPRGTUNING				UNIPRO_CB_OFFSET(0x00FB)
+
+#define UNIPRO_CB_OFFSET(x)			(0x8000 | x)
+
 /*
  * PHY Adpater attributes
  */
@@ -110,6 +144,11 @@
 #define PA_STALLNOCONFIGTIME	0x15A3
 #define PA_SAVECONFIGTIME	0x15A4
 
+/*Other attributes*/
+#define VS_MPHYCFGUPDT		0xD085
+#define VS_DEBUGOMC		0xD09E
+#define VS_POWERSTATE		0xD083
+
 /* PA power modes */
 enum {
 	FAST_MODE	= 1,
-- 
1.8.1.5
