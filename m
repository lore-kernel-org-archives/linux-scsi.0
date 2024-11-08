Received: from cmccmta3.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF7CDDA8;
	Fri,  8 Nov 2024 07:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731049783; cv=none; b=sefOSl2pboTWnSBUxucOM95Wepn8HXkNhZLNiZ6oPxo/SJpVwt0xOP5iSmWpwCRuZ4kx4M7u6QDrb2tq25Y65nw83QIbj0o5aBU7j5137C0i+N2uSjZBegZSydvTLWiM2t/PT/M0HZ17iUJ+/Gl14UTKIxanOuZ2hxYKugmITuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731049783; c=relaxed/simple;
	bh=NZfaUT3PuVJd7QSqbh3Iw5TQJNKJ6xXrsnc0CQcgPL0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IShLToe2IA+VIu7uz0HUvwGmJe1qrNmt0KS2kwcZA3NhVEdmzItmb6xtxYLcvCMvyXLD1884laVwHCx77/CPm680gZ0GKGpMXp8QPMh5i0y1SWrzElhhxqXh6uYDzKXyibL1IVN+P7o5TI+Bxvd0VJurKBP5+bv5umK+Ax6NKmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee9672db930ed8-f5eec;
	Fri, 08 Nov 2024 15:09:37 +0800 (CST)
X-RM-TRANSID:2ee9672db930ed8-f5eec
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[10.55.1.71])
	by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee4672db93004d-866ba;
	Fri, 08 Nov 2024 15:09:37 +0800 (CST)
X-RM-TRANSID:2ee4672db93004d-866ba
From: liujing <liujing@cmss.chinamobile.com>
To: james.smart@broadcom.com
Cc: dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liujing <liujing@cmss.chinamobile.com>
Subject: [PATCH] scsi: lpfc: Fix spelling errors asynchronously
Date: Fri,  8 Nov 2024 15:09:35 +0800
Message-Id: <20241108070935.10427-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: liujing<liujing@cmss.chinamobile.com>

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 49dd78ed8a9a..43dc1da4a156 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -242,7 +242,7 @@ lpfc_nvme_remoteport_delete(struct nvme_fc_remote_port *remoteport)
  * @phba: pointer to lpfc hba data structure.
  * @axchg: pointer to exchange context for the NVME LS request
  *
- * This routine is used for processing an asychronously received NVME LS
+ * This routine is used for processing an asynchronously received NVME LS
  * request. Any remaining validation is done and the LS is then forwarded
  * to the nvme-fc transport via nvme_fc_rcv_ls_req().
  *
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index e6c9112a8862..fba2e62027b7 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2142,7 +2142,7 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
  * @phba: pointer to lpfc hba data structure.
  * @axchg: pointer to exchange context for the NVME LS request
  *
- * This routine is used for processing an asychronously received NVME LS
+ * This routine is used for processing an asynchronously received NVME LS
  * request. Any remaining validation is done and the LS is then forwarded
  * to the nvmet-fc transport via nvmet_fc_rcv_ls_req().
  *
-- 
2.27.0



