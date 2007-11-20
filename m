From: Joe Perches <joe@perches.com>
Subject: [PATCH 42/59] drivers/scsi/lpfc: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:34 -0800
Message-ID: <0d5c0d474aaeba86c0899848a6eb16ef92d308bc.1195454436.git.joe__44522.8806500838$1195524405$gmane$org@perches.com>
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
 <1195523331-15303-42-git-send-email-joe@perches.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761380AbXKTCEd@vger.kernel.org>
In-Reply-To: <1195523331-15303-42-git-send-email-joe@perches.com>
Message-Id: <0d5c0d474aaeba86c0899848a6eb16ef92d308bc.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/lpfc/lpfc_attr.c |    2 +-
 drivers/scsi/lpfc/lpfc_ct.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 80a1121..d9d6791 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1182,7 +1182,7 @@ lpfc_nodev_tmo_set(struct lpfc_vport *vport, int val)
 	}
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 			 "0403 lpfc_nodev_tmo attribute cannot be set to"
-			 "%d, allowed range is [%d, %d]\n",
+			 " %d, allowed range is [%d, %d]\n",
 			 val, LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
 	return -EINVAL;
 }
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c701e4d..88b39d5 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -473,7 +473,7 @@ lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint32_t Size)
 							KERN_INFO,
 							LOG_DISCOVERY,
 							"0238 Process "
-							"x%x NameServer Rsp"
+							"x%x NameServer Rsp "
 							"Data: x%x x%x x%x\n",
 							Did, ndlp->nlp_flag,
 							vport->fc_flag,
-- 
1.5.3.5.652.gf192c
