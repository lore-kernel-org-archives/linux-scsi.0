From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH][TRIVIAL] SCSI, pmcraid: Fix 'failed' misspelled as 'faile'
 in error message
Date: Sat, 17 Dec 2011 23:32:33 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1112172329580.21713@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, trivial@kernel.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/pmcraid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 5163edb..ea8a0b4 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4105,7 +4105,7 @@ static long pmcraid_chr_ioctl(
 	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
 
 	if (!hdr) {
-		pmcraid_err("faile to allocate memory for ioctl header\n");
+		pmcraid_err("failed to allocate memory for ioctl header\n");
 		return -ENOMEM;
 	}
 
-- 
1.7.8


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
