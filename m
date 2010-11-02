From: Joe Perches <joe@perches.com>
Subject: [RESEND PATCH 2/4] drivers/scsi/pmcraid.c: Fix k.alloc switched
 arguments
Date: Tue, 02 Nov 2010 15:47:39 -0700
Message-ID: <1288738059.7326.14.camel@Joe-Laptop>
References: <cover.1288555098.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3929 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab0KBWrk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2010 18:47:40 -0400
In-Reply-To: <cover.1288555098.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

And a typo fix of faile to failed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/pmcraid.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 4b87657..e5a694a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4094,10 +4094,10 @@ static long pmcraid_chr_ioctl(
 	struct pmcraid_ioctl_header *hdr = NULL;
 	int retval = -ENOTTY;
 
-	hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));
+	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
 
 	if (!hdr) {
-		pmcraid_err("faile to allocate memory for ioctl header\n");
+		pmcraid_err("failed to allocate memory for ioctl header\n");
 		return -ENOMEM;
 	}
 
-- 
1.7.3.1.g432b3.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


