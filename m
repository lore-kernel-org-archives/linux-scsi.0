Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7759A1CD204;
	Tue,  3 Dec 2024 09:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733217690; cv=none; b=QxEe/YcffKmWlIJEeNJG4xHTBWfwm71rqoiTzeIFLt32ClkI1y47yWp3NfCeO7yUzP7m+UWSYHotx5ggtRsu1PxW+CvYJBTswhJ8XtM+OrGuVAEo6nHmkKMbpabpbw/49mSGvQl2YIM+bxUZ7dtEX26agOOg1h6wwplXRynEnr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733217690; c=relaxed/simple;
	bh=kBl9PceVCM+x29s5XWwbdQpNT0KY8ECBwJiaj3MWn1w=;
	h=From:To:Cc:Subject:Date:Message-Id; b=QaQxHVfkgiBF13koMlKnPs8P5dmjXOim9wcQ9xppK6AJ7j7JSWJA3zfCEvstS2CIHigRaBBSbpxaWLVX50EQVbxurWrT3h+l0Xm6yatF4FWpt6pijSX2o+u3d+D55UqgjbVKGiIxC+LWPtVaTgqKTTOj+KpXkMtcZGB+XiHNiRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee7674ecd8eda8-c1dc7;
	Tue, 03 Dec 2024 17:21:18 +0800 (CST)
X-RM-TRANSID:2ee7674ecd8eda8-c1dc7
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from ubuntu.localdomain (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee8674ecd8cf08-25831;
	Tue, 03 Dec 2024 17:21:18 +0800 (CST)
X-RM-TRANSID:2ee8674ecd8cf08-25831
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	zhujun2@cmss.chinamobile.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND] bfa: Fix typo in bfi.h
Date: Tue,  3 Dec 2024 01:21:15 -0800
Message-Id: <20241203092115.7496-1-zhujun2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The word 'swtich' is wrong, so fix it.

Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
---
 drivers/scsi/bfa/bfi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
index 41e6b4dac056..e1e0e967bcc3 100644
--- a/drivers/scsi/bfa/bfi.h
+++ b/drivers/scsi/bfa/bfi.h
@@ -1148,7 +1148,7 @@ struct bfi_diag_dport_scn_testcomp_s {
 	u16	numbuffer; /* from switch  */
 	u8	subtest_status[DPORT_TEST_MAX];  /* 4 bytes */
 	u32	latency;   /* from switch  */
-	u32	distance;  /* from swtich unit in meters  */
+	u32	distance;  /* from switch unit in meters  */
 			/* Buffers required to saturate the link */
 	u16	frm_sz;	/* from switch for buf_reqd */
 	u8	rsvd[2];
-- 
2.17.1



