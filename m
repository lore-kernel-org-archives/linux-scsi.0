From: akpm@linux-foundation.org
Subject: [patch 2/6] aic94xx: world-writable sysfs update_bios file
Date: Mon, 23 May 2011 15:29:12 -0700
Message-ID: <201105232229.p4NMTCD8016149@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757826Ab1EWW3g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2011 18:29:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, segoon@openwall.com

From: Vasiliy Kulikov <segoon@openwall.com>

Don't allow everybody to load firmware.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aic94xx/aic94xx_init.c~aic94xx-world-writable-sysfs-update_bios-file drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~aic94xx-world-writable-sysfs-update_bios-file
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -486,7 +486,7 @@ static ssize_t asd_show_update_bios(stru
 			flash_error_table[i].reason);
 }
 
-static DEVICE_ATTR(update_bios, S_IRUGO|S_IWUGO,
+static DEVICE_ATTR(update_bios, S_IRUGO|S_IWUSR,
 	asd_show_update_bios, asd_store_update_bios);
 
 static int asd_create_dev_attrs(struct asd_ha_struct *asd_ha)
_
