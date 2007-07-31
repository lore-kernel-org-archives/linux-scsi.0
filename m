From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 44] drivers/scsi/lpfc/lpfc_debugfs.c: kmalloc + memset conversion to kcalloc
Date: Tue, 31 Jul 2007 20:25:45 +0200
Message-ID: <200707312025.45603.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, james.smart@emulex.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_debugfs.c | 13809 -> 13716 (-93 bytes)
 drivers/scsi/lpfc/lpfc_debugfs.o | 146124 -> 146124 (0 bytes)

 drivers/scsi/lpfc/lpfc_debugfs.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_debugfs.c	2007-07-31 14:11:24.000000000 +0200
@@ -432,14 +432,11 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 	if (!lpfc_debugfs_start_time)
 		lpfc_debugfs_start_time = jiffies;

-	vport->disc_trc = kmalloc(
-		(sizeof(struct lpfc_disc_trc) * lpfc_debugfs_max_disc_trc),
-		GFP_KERNEL);
+	vport->disc_trc = kcalloc(lpfc_debugfs_max_disc_trc,
+				  sizeof(struct lpfc_disc_trc),	GFP_KERNEL);

 	if (!vport->disc_trc)
 		goto debug_failed;
-	memset(vport->disc_trc, 0,
-		(sizeof(struct lpfc_disc_trc) * lpfc_debugfs_max_disc_trc));

 	snprintf(name, sizeof(name), "discovery_trace");
 	vport->debug_disc_trc =
