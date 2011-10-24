From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH][trivial] SCSI, pmcraid: Fix spelling error in a pmcraid_err()
 call
Date: Tue, 25 Oct 2011 00:45:13 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1110250043300.19795@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
List-Id: linux-scsi@vger.kernel.org

There's a mistake in one of the pmcraid_err() calls in
drivers/scsi/pmcraid.c - 'failed' is misspelled as 'faile'. This patch
fixes that error.

PS. This patch is generated on top of my previous one "[PATCH] SCSI,
pmcraid: Fix kmalloc() argument order in pmcraid_chr_ioctl()".

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/pmcraid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 compile tested only.

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index da19bdf..9a6951b 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4106,7 +4106,7 @@ static long pmcraid_chr_ioctl(
 	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
 
 	if (!hdr) {
-		pmcraid_err("faile to allocate memory for ioctl header\n");
+		pmcraid_err("failed to allocate memory for ioctl header\n");
 		return -ENOMEM;
 	}
 
-- 
1.7.7


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
