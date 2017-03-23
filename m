From: kusumi.tomohiro@gmail.com
Subject: [PATCH] scsi: ufs: fix wrong/ambiguous fall through comments
Date: Thu, 23 Mar 2017 12:49:04 +0200
Message-ID: <20170323104904.47040-1-tkusumi@tuxera.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35225 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932085AbdCWKtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2017 06:49:20 -0400
Received: by mail-lf0-f68.google.com with SMTP id v2so16386570lfi.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Mar 2017 03:49:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

These aren't really falling through to anywhere meaningful.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dc6efbd..b7e5128 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -553,15 +553,14 @@ static inline u32 ufshcd_get_intr_mask(struct ufs_hba *hba)
 	case UFSHCI_VERSION_10:
 		intr_mask = INTERRUPT_MASK_ALL_VER_10;
 		break;
-	/* allow fall through */
 	case UFSHCI_VERSION_11:
 	case UFSHCI_VERSION_20:
 		intr_mask = INTERRUPT_MASK_ALL_VER_11;
 		break;
-	/* allow fall through */
 	case UFSHCI_VERSION_21:
 	default:
 		intr_mask = INTERRUPT_MASK_ALL_VER_21;
+		break;
 	}
 
 	return intr_mask;
-- 
2.9.3
