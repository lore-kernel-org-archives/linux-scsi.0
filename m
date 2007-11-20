From: Joe Perches <joe@perches.com>
Subject: [PATCH 41/59] drivers/scsi/aic94xx: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:33 -0800
Message-ID: <1195523331-15303-42-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
 <1195523331-15303-21-git-send-email-joe@perches.com>
 <1195523331-15303-22-git-send-email-joe@perches.com>
 <1195523331-15303-23-git-send-email-joe@perches.com>
 <1195523331-15303-24-git-send-email-joe@perches.com>
 <1195523331-15303-25-git-send-email-joe@perches.com>
 <1195523331-15303-26-git-send-email-joe@perches.com>
 <1195523331-15303-27-git-send-email-joe@perches.com>
 <1195523331-15303-28-git-send-email-joe@perches.com>
 <1195523331-15303-29-git-send-email-joe@perches.com>
 <1195523331-15303-30-git-send-email-joe@perches.com>
 <1195523331-15303-31-git-send-email-joe@perches.com>
 <1195523331-15303-32-git-send-email-joe@perches.com>
 <1195523331-15303-33-git-send-email-joe@perches.com>
 <1195523331-15303-34-git-send-email-joe@perches.com>
 <1195523331-15303-35-git-send-email-joe@perches.com>
 <1195523331-15303-36-git-send-email-joe@perches.com>
 <1195523331-15303-37-git-send-email-joe@perches.com>
 <1195523331-15303-38-git-send-email-joe@perches.com>
 <1195523331-15303-39-git-send-email-joe@perches.com>
 <1195523331-15303-40-git-send-email-joe@perches.com>
 <1195523331-15303-41-git-send-email-joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:2149 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871AbXKTBtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:50 -0500
In-Reply-To: <1195523331-15303-41-git-send-email-joe@perches.com>
Message-Id: <6cd7c30e31d1e1a732eeb7f08636afa5061d5f44.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/aic94xx/aic94xx_sds.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 06509bf..f45f0b9 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -325,8 +325,8 @@ asd_hwi_check_ocm_access (struct asd_ha_struct *asd_ha)
 			goto out;
 		}
 
-		printk(KERN_INFO "OCM is not initialized by BIOS,"
-		       "reinitialize it and ignore it, current IntrptStatus"
+		printk(KERN_INFO "OCM is not initialized by BIOS, "
+		       "reinitialize it and ignore it, current IntrptStatus "
 		       "is 0x%x\n", v);
 
 		if (v)
-- 
1.5.3.5.652.gf192c

