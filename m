From: <kgudipat@brocade.com>
Subject: [PATCH 14/15] bfa: Firmware image naming convention update
Date: Fri, 21 Sep 2012 17:27:23 -0700
Message-ID: <1348273643-28537-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:43859 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757447Ab2IVA1g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Sep 2012 20:27:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Modified the firmware naming convention to contain the
	  firmware image version (3.1.0.0).
	- The new convention is <firmware-image>-<firmware-version>.bin
	- The change will enforce loading only compatible firmware with this driver
	  and also avoid over-writing the old firmware image in-order to load new
	  version driver as the firmware names used to be the same.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index c374949..895b0e5 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -63,9 +63,9 @@ int		max_rport_logins = BFA_FCS_MAX_RPORT_LOGINS;
 u32	bfi_image_cb_size, bfi_image_ct_size, bfi_image_ct2_size;
 u32	*bfi_image_cb, *bfi_image_ct, *bfi_image_ct2;
 
-#define BFAD_FW_FILE_CB		"cbfw.bin"
-#define BFAD_FW_FILE_CT		"ctfw.bin"
-#define BFAD_FW_FILE_CT2	"ct2fw.bin"
+#define BFAD_FW_FILE_CB		"cbfw-3.1.0.0.bin"
+#define BFAD_FW_FILE_CT		"ctfw-3.1.0.0.bin"
+#define BFAD_FW_FILE_CT2	"ct2fw-3.1.0.0.bin"
 
 static u32 *bfad_load_fwimg(struct pci_dev *pdev);
 static void bfad_free_fwimg(void);
-- 
1.7.3.rc1

