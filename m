From: Cosimo Streppone <cosimo@cpan.org>
Subject: [PATCH] scsi: zorro7xx: braces code style fix
Date: Tue, 09 Feb 2010 22:41:43 +0100
Message-ID: <1265751703-25745-1-git-send-email-cosimo@cpan.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Cosimo Streppone <cosimo@cpan.org>
List-Id: linux-scsi@vger.kernel.org

This is just a tiny coding style fix for the scsi/zorro7xx.c file.
FOSDEM GregKH talk helped this patch come to life.

Signed-off-by: Cosimo Streppone <cosimo@cpan.org>
---
 drivers/scsi/zorro7xx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 64d40a2..a666f20 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -80,11 +80,10 @@ static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 	board = zorro_resource_start(z);
 	zdd = (struct zorro_driver_data *)ent->driver_data;
 
-	if (zdd->absolute) {
+	if (zdd->absolute)
 		ioaddr = zdd->offset;
-	} else {
+	else
 		ioaddr = board + zdd->offset;
-	}
 
 	if (!zorro_request_device(z, zdd->name)) {
 		printk(KERN_ERR "zorro7xx: cannot reserve region 0x%lx, abort\n",
-- 
1.6.0.4
