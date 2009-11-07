From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 60/75] bfa: declare MODULE_FIRMWARE
Date: Sat, 07 Nov 2009 22:05:34 +0000
Message-ID: <1257631534.15927.482.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47316 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501AbZKGWFf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Nov 2009 17:05:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Jing Huang <huangj@brocade.com>, linux-scsi@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/bfa/bfad_fwimg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_fwimg.c b/drivers/scsi/bfa/bfad_fwimg.c
index 2c2082d..2ad65f2 100644
--- a/drivers/scsi/bfa/bfad_fwimg.c
+++ b/drivers/scsi/bfa/bfad_fwimg.c
@@ -41,6 +41,8 @@ u32 *bfi_image_cb;
 
 #define	BFAD_FW_FILE_CT	"ctfw.bin"
 #define	BFAD_FW_FILE_CB	"cbfw.bin"
+MODULE_FIRMWARE(BFAD_FW_FILE_CT);
+MODULE_FIRMWARE(BFAD_FW_FILE_CB);
 
 u32 *
 bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
-- 
1.6.5.2



