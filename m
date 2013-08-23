From: Rasesh Mody <rmody@brocade.com>
Subject: [PATCH 1/1] bfa: firmware update to 3.2.1.1
Date: Fri, 23 Aug 2013 16:05:57 -0700
Message-ID: <1377299157-15551-1-git-send-email-rmody@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:59303 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754810Ab3HWXlb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Aug 2013 19:41:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@Brocade.COM, Rasesh Mody <rmody@Brocade.COM>

This patch updates the firmware to address the thermal notification issue

Signed-off-by: Rasesh Mody <rmody@brocade.com>
---
 drivers/scsi/bfa/bfad.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 9611195..f8ca7be 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -63,9 +63,9 @@ int		max_rport_logins = BFA_FCS_MAX_RPORT_LOGINS;
 u32	bfi_image_cb_size, bfi_image_ct_size, bfi_image_ct2_size;
 u32	*bfi_image_cb, *bfi_image_ct, *bfi_image_ct2;
 
-#define BFAD_FW_FILE_CB		"cbfw-3.2.1.0.bin"
-#define BFAD_FW_FILE_CT		"ctfw-3.2.1.0.bin"
-#define BFAD_FW_FILE_CT2	"ct2fw-3.2.1.0.bin"
+#define BFAD_FW_FILE_CB		"cbfw-3.2.1.1.bin"
+#define BFAD_FW_FILE_CT		"ctfw-3.2.1.1.bin"
+#define BFAD_FW_FILE_CT2	"ct2fw-3.2.1.1.bin"
 
 static u32 *bfad_load_fwimg(struct pci_dev *pdev);
 static void bfad_free_fwimg(void);
-- 
1.8.2.3

