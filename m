From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/3] SCSI-sg: Fix a typo in a comment line in sg_ioctl()
Date: Fri, 25 Aug 2017 22:26:48 +0200
Message-ID: <51971166-583b-071f-a9cb-1f00cc852756@users.sourceforge.net>
References: <0fffccee-7cc1-1321-2c6b-00ac06b304b8@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0fffccee-7cc1-1321-2c6b-00ac06b304b8@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, trivial@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 25 Aug 2017 22:06:59 +0200

Fix a word in this description.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4a2db7ff14cc..c80899d249c6 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -891,7 +891,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	case SG_SET_FORCE_LOW_DMA:
 		/*
 		 * N.B. This ioctl never worked properly, but failed to
-		 * return an error value. So returning '0' to keep compability
+		 * return an error value. So returning '0' to keep compatibility
 		 * with legacy applications.
 		 */
 		return 0;
-- 
2.14.0
