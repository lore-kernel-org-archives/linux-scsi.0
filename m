From: Grant Coady <grant_lkml@dodo.com.au>
Subject: [PATCH] GDT SCSI DISK ARRAY: fix split line comments for grep
Date: Sun, 03 Aug 2008 08:44:39 +1000
Message-ID: <rgo9945k1lva0nh1rfrtaahoingstahl7o@4ax.com>
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754368AbYHBWpK@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: achim_leubner@adaptec.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi there,

Following patch unsplits some comment lines that hold driver device 
names so they can be grepped.

Grant.

From: Grant Coady <gcoady.lk@gmail.com>

fix split line comments so grep can find scsi GDT* device IDs

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 gdth.h |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

--- linux-2.6.27-rc1-mm1/drivers/scsi/gdth.h~	2008-07-14 07:51:29.000000000 +1000
+++ linux-2.6.27-rc1-mm1/drivers/scsi/gdth.h	2008-08-03 08:34:58.817704177 +1000
@@ -99,17 +99,13 @@
 #define PCI_DEVICE_ID_VORTEX_GDT6x11RD  0x114   /* GDT6111RD/GDT6511RD */
 #define PCI_DEVICE_ID_VORTEX_GDT6x21RD  0x115   /* GDT6121RD/GDT6521RD */
 /* GDT_MPR, RD series, wide/ultra2 SCSI */
-#define PCI_DEVICE_ID_VORTEX_GDT6x18RD  0x118   /* GDT6118RD/GDT6518RD/
-                                                   GDT6618RD */
-#define PCI_DEVICE_ID_VORTEX_GDT6x28RD  0x119   /* GDT6128RD/GDT6528RD/
-                                                   GDT6628RD */
+#define PCI_DEVICE_ID_VORTEX_GDT6x18RD  0x118   /* GDT6118RD/GDT6518RD/GDT6618RD */
+#define PCI_DEVICE_ID_VORTEX_GDT6x28RD  0x119   /* GDT6128RD/GDT6528RD/GDT6628RD */
 #define PCI_DEVICE_ID_VORTEX_GDT6x38RD  0x11A   /* GDT6538RD/GDT6638RD */
 #define PCI_DEVICE_ID_VORTEX_GDT6x58RD  0x11B   /* GDT6558RD/GDT6658RD */
 /* GDT_MPR, RN series (64-bit PCI), wide/ultra2 SCSI */
-#define PCI_DEVICE_ID_VORTEX_GDT7x18RN  0x168   /* GDT7118RN/GDT7518RN/
-                                                   GDT7618RN */
-#define PCI_DEVICE_ID_VORTEX_GDT7x28RN  0x169   /* GDT7128RN/GDT7528RN/
-                                                   GDT7628RN */
+#define PCI_DEVICE_ID_VORTEX_GDT7x18RN  0x168   /* GDT7118RN/GDT7518RN/GDT7618RN */
+#define PCI_DEVICE_ID_VORTEX_GDT7x28RN  0x169   /* GDT7128RN/GDT7528RN/GDT7628RN */
 #define PCI_DEVICE_ID_VORTEX_GDT7x38RN  0x16A   /* GDT7538RN/GDT7638RN */
 #define PCI_DEVICE_ID_VORTEX_GDT7x58RN  0x16B   /* GDT7558RN/GDT7658RN */
 #endif
