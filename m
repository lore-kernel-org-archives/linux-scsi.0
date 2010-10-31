From: Joe Perches <joe@perches.com>
Subject: [PATCH 2/4] drivers/scsi/pmcraid.c: Fix k.alloc switched arguments
Date: Sun, 31 Oct 2010 15:33:54 -0700
Message-ID: <d72ee65c9a3bb1987a2fef5b6924d48a17350894.1288555098.git.joe@perches.com>
References: <cover.1288555098.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3904 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819Ab0JaWeB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Oct 2010 18:34:01 -0400
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

