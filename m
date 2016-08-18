From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/5] block-cciss: Delete unnecessary initialisations in
 cciss_bigpassthru()
Date: Thu, 18 Aug 2016 12:00:09 +0200
Message-ID: <d47750ca-25d1-af09-690a-5f215bb845b4@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <686a1f95-a76c-2624-50e1-9d0e59948e64@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <686a1f95-a76c-2624-50e1-9d0e59948e64@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: esc.storagedev@microsemi.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 17 Aug 2016 22:55:51 +0200

Three local variables will be set to an appropriate value a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/cciss.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 43ac632..10e1b0a 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1572,11 +1572,11 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 {
 	BIG_IOCTL_Command_struct *ioc;
 	CommandList_struct *c;
-	unsigned char **buff = NULL;
-	int *buff_size = NULL;
+	unsigned char **buff;
+	int *buff_size;
 	u64bit temp64;
 	BYTE sg_used = 0;
-	int status = 0;
+	int status;
 	int i;
 	DECLARE_COMPLETION_ONSTACK(wait);
 	__u32 left;
-- 
2.9.3
