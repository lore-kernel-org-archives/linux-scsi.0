Received: from cmccmta1.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFAA2B9B9;
	Fri, 15 Nov 2024 08:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731659915; cv=none; b=tKpb5ThzdztZRz2FRHOYG5npVdLIkALv8gupWAnj56EdPfws2GKOF4bJKQHFoPSZgJzqIcj/WPo77Euekj/6PSqh5BSDy5kTWSesd3vfQVedv4eOmOKmGjiylnpwcJbTymZa78uXLk14ow8KS4wAOF+BaNNuoL202xXnHRAY1qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731659915; c=relaxed/simple;
	bh=kBl9PceVCM+x29s5XWwbdQpNT0KY8ECBwJiaj3MWn1w=;
	h=From:To:Cc:Subject:Date:Message-Id; b=PflTGxwH7MDymIpIQ9BhaaN0Cl88D/Ads4LlQ6RGSBOaO9ipLm9lborDw1nJJKlFkTzI+yJ16xJGA5nntewmu8RvpL4joCUQqZVmba44629Cgz9iP9Dg8lU0MDIB1Ay0pOCt4nlcP90YGVph9BcqBmds/Bf9Dr+XWaWH5+JQ+pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16737087c430-fbd47;
	Fri, 15 Nov 2024 16:38:20 +0800 (CST)
X-RM-TRANSID:2ee16737087c430-fbd47
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from ubuntu.localdomain (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66737087bb44-fd15d;
	Fri, 15 Nov 2024 16:38:20 +0800 (CST)
X-RM-TRANSID:2ee66737087bb44-fd15d
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	zhujun2@cmss.chinamobile.com
Subject: [PATCH] bfa: Fix typo in bfi.h
Date: Fri, 15 Nov 2024 00:38:17 -0800
Message-Id: <20241115083817.6637-1-zhujun2@cmss.chinamobile.com>
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



