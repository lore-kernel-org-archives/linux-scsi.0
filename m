From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] aic94xx: Fix spelling error
Date: Wed, 06 Sep 2006 10:58:37 -0700
Message-ID: <44FF0C4D.7020905@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45247 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751252AbWIFR7B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Sep 2006 13:59:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

This patch corrects the spelling of "ENEBLEABLE" in the aic94xx driver.

--D

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index eec1e0d..7508250 100644
@@ -807,11 +808,11 @@ static void *asd_find_ll_by_id(void * co
  *
  * HIDDEN phys do not count in the total count.  REPORTED phys cannot
  * be enabled but are reported and counted towards the total.
- * ENEBLEABLE phys are enabled by default and count towards the total.
+ * ENABLEABLE phys are enabled by default and count towards the total.
  * The absolute total phy number is ASD_MAX_PHYS.  hw_prof->num_phys
  * merely specifies the number of phys the host adapter decided to
  * report.  E.g., it is possible for phys 0, 1 and 2 to be HIDDEN,
- * phys 3, 4 and 5 to be REPORTED and phys 6 and 7 to be ENEBLEABLE.
+ * phys 3, 4 and 5 to be REPORTED and phys 6 and 7 to be ENABLEABLE.
  * In this case ASD_MAX_PHYS is 8, hw_prof->num_phys is 5, and only 2
  * are actually enabled (enabled by default, max number of phys
  * enableable in this case).
@@ -868,7 +869,7 @@ static int asd_ms_get_phy_params(struct 
 			rep_phys++;
 			continue;
 		case MS_PHY_STATE_ENABLEABLE:
-			ASD_DPRINTK("ms: phy%d: ENEBLEABLE\n", i);
+			ASD_DPRINTK("ms: phy%d: ENABLEABLE\n", i);
 			asd_ha->hw_prof.enabled_phys |= (1 << i);
 			en_phys++;
 			break;

