From: Joe Perches <joe@perches.com>
Subject: [PATCH] scsi: pmcraid: trivial typo in printk
Date: Wed, 29 Jul 2015 11:39:13 -0700
Message-ID: <1438195153.30877.3.camel@perches.com>
References: <1438193985-7208-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438193985-7208-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Jiri Kosina <trivial@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Trivial typo fixes:

o \b should be \n
o coalesce format to avoid excess spaces

Signed-off-by: Joe Perches <joe@perches.com>
---
And another here:

 drivers/scsi/pmcraid.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ed31d8c..b421de2 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -1558,8 +1558,7 @@ static void pmcraid_handle_config_change(struct pmcraid_instance *pinstance)
 	cfg_entry = &ccn_hcam->cfg_entry;
 	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
 
-	pmcraid_info("CCN(%x): %x timestamp: %llx type: %x lost: %x flags: %x \
-		 res: %x:%x:%x:%x\n",
+	pmcraid_info("CCN(%x): %x timestamp: %llx type: %x lost: %x flags: %x res: %x:%x:%x:%x\n",
 		 pinstance->ccn.hcam->ilid,
 		 pinstance->ccn.hcam->op_code,
 		((pinstance->ccn.hcam->timestamp1) |
@@ -1583,7 +1582,7 @@ static void pmcraid_handle_config_change(struct pmcraid_instance *pinstance)
 	if (pinstance->ccn.hcam->notification_lost) {
 		cfgcmd = pmcraid_get_free_cmd(pinstance);
 		if (cfgcmd) {
-			pmcraid_info("lost CCN, reading config table\b");
+			pmcraid_info("lost CCN, reading config table\n");
 			pinstance->reinit_cfg_table = 1;
 			pmcraid_querycfg(cfgcmd);
 		} else {
