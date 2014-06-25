From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: advansys.c:  Cleaning up variable is set more than once
Date: Wed, 25 Jun 2014 14:23:28 +0200
Message-ID: <1403699008-22658-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A struct member variable is set to the same value more than once

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/advansys.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d814588..8281ae0 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11592,7 +11592,6 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 			    adv_dvc_varp->cfg->disc_enable;
 			ep_38C0800->bios_ctrl = adv_dvc_varp->bios_ctrl;
 			ep_38C0800->wdtr_able = adv_dvc_varp->wdtr_able;
-			ep_38C0800->tagqng_able = adv_dvc_varp->tagqng_able;
 			ep_38C0800->sdtr_speed1 = adv_dvc_varp->sdtr_speed1;
 			ep_38C0800->sdtr_speed2 = adv_dvc_varp->sdtr_speed2;
 			ep_38C0800->sdtr_speed3 = adv_dvc_varp->sdtr_speed3;
@@ -11620,7 +11619,6 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 			    adv_dvc_varp->cfg->disc_enable;
 			ep_38C1600->bios_ctrl = adv_dvc_varp->bios_ctrl;
 			ep_38C1600->wdtr_able = adv_dvc_varp->wdtr_able;
-			ep_38C1600->tagqng_able = adv_dvc_varp->tagqng_able;
 			ep_38C1600->sdtr_speed1 = adv_dvc_varp->sdtr_speed1;
 			ep_38C1600->sdtr_speed2 = adv_dvc_varp->sdtr_speed2;
 			ep_38C1600->sdtr_speed3 = adv_dvc_varp->sdtr_speed3;
-- 
1.7.10.4
