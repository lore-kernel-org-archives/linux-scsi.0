Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C162989B5;
	Sat, 21 Mar 2026 10:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774090799; cv=none; b=EQLddfTXwiWL05KiIIOmxQ6u+PhgCwUchcWbtU07gBLFjmWo7ZvxT0j+xnFneGk0ePFBOsROKaAlf6aTGjOcsCWFA83rGou12RYChU8c49CbYy+6JiGkGxILjWhlaI7HVhv4zFGJpeu7ENCOOFgxVjRMeOy2bhrXLqsciLZGEZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774090799; c=relaxed/simple;
	bh=F/o5F4tSnn6uxfLYVTYPdJ2YYSc1K03L66VRzHznNMw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=omd1Ir1ROUhBM4DpzPM6OF3TpxlYdpSOPe/tL4kTKGLc3LhwsqeRxXQAH5/2wENDN3ldFLlS+AV37tgeYUK9b620rMHXnpTjLfKxbMfs2+XG6WLHIzMOIX3zgth7iF81aHTQcw1bwp1k1UpG0omV2symPkWcqAKk1IuRVzOm1+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=E7rLpvR/; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="E7rLpvR/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1774090759;
	bh=AHBzfH9ITH/SlgbFgG1zKhvDKe5/EItbp98C1HysHIU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=E7rLpvR/YfFL9MpaP9y2iq3NMXJvaLiuTsU+MJHrizXIjHZtaputtbF9tNaIwYyGH
	 toHc8ppso5P8zFWjOA26HgrGIuUsiR6n9aDoDFqm85thXvbRiGBKm48Qed7+bO46nm
	 CTU2Y3o0msWrWlG+APw/rMJEZJAfYhMBJQ1o8Jhk=
X-QQ-mid: esmtpgz10t1774090752t414764ed
X-QQ-Originating-IP: A4r9p/RJwcvQH5cI67Pm4o6xQQKjqigxxiZdP1PjT3g=
Received: from localhost.localdomain ( [116.172.93.199])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 21 Mar 2026 18:59:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 16487684211841182525
EX-QQ-RecipientCnt: 11
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
To: justin.tee@broadcom.com,
	paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: julia.lawall@inria.fr,
	xutong.ma@inria.fr,
	kexinsun@smail.nju.edu.cn,
	yunbolyu@smu.edu.sg,
	ratnadiraw@smu.edu.sg
Subject: [PATCH] scsi: lpfc: update outdated comment for renamed lpfc_freenode()
Date: Sat, 21 Mar 2026 18:59:09 +0800
Message-Id: <20260321105909.7804-1-kexinsun@smail.nju.edu.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:smail.nju.edu.cn:qybglogicsvrgz:qybglogicsvrgz5b-0
X-QQ-XMAILINFO: OW8T3r1JWOoKTkjIF8ZRjX5M1mxSg7r9MgosrIVaffV2z0xZmevGoK0v
	YSV3YW6nN3wBX4sN1wFe1hryOVrVFYe8tZt/HcghO3S6B2NJaclI0noaiWyEEA8EsDRUuTp
	GbR1IY+j35RqdIxeQ+60/l2lVtmjPPV3IG8DN14/0Swpv01Qy+2efw0ahvdzAaLUDQiPxYW
	GUJmD2Xp+S8z7BwPfNfvJzl9PmZGAQcbv1jzqgH4z05QublqGkVkzsPdeaz8nzs/rlfur0P
	RoVvwkAsNx8Gyo+x4KrNgBo7xyczwpJRX1ZUIGaM3Ed2fhXuw97XYXtvmLh2kzSCr5jWp/e
	SHKdG/R+9PLECdj6mlsRK5yWiAj8picNfHl116LB529RbDUSFCLFKcfcVTCxa2R9S+qjzy5
	d9C6dGgqaUsTqz7/UFEqhcEhg81xUO7XgxskLuc7YQQYeCs/Ad69H+ar/N+Jck5Od3kVfB1
	fFj/1BLsRrN8MkBcrz+6PA6WFcU84SnjKo8iXyf+iaHrtq0O+hrJkSxBFZyd8IYOFuKcfo9
	ZgOVqzVwm8ts9bwhFsrhE0hnXU3sA9VFE5BR7TAL2iqHgiXccn/Pzg9Ff6HrFMC2n4SXYdl
	ejwNs6uURh45Cesu357poh0rFsbvMQtwHv5CS1czOywTdzhUlI26sJw2NMNRxTnnPOb1WdI
	LJsnb4gFbdpAp/i6yqp8Q2Wn15f49L/wr0yItUJN7QtYDcHwMxRW24GXcEaji/+lIqGnX2T
	+HY0NOQP8n1N69TtIqMra468NHsaTz8bYp56+ujDHK0UXxT1xpb+c9SoSA1HsqaKjuCX1UY
	SuyxN5LEfeL1pCMobTUaJkD+CJEy1nAwmKbHwe3UcnNZxsGH+ChMvyZf/zlURou3Og1VhBC
	76YK/GmtoMOEgfC6xNCE5DmFoefZi/sZfmsDbGS7vcBliCe9mRhxZforZKBd6LKKRKDRj4L
	/5H8r7vWZ+xcI6vX4vMDUBCBZsW+afVKHwmd2z1plJNnjKEp3m0Kf8m+eZmLV/Cjn59o0/d
	/87qfKPIQnH6ZNuKNcW9hfbqlE2pKxVEFXXwMrhlsKxtoSz1ULPhJ+rCcIT/+1sHExAQRnL
	AXh2WZunBBgAuWDjilWFBg=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

The function lpfc_freenode() was renamed to
lpfc_cleanup_node() by commit 685f0bf7afe0 ("[SCSI] lpfc
8.1.12 : Collapse discovery lists to a single node list"),
and commit a70e63eee1c1 ("scsi: lpfc: Fix NPIV Fabric Node
reference counting") later removed the lpfc_unreg_rpi() call
from lpfc_cleanup_node().  Remove the now-inaccurate
"called from lpfc_freenode()" sentence and reflow the
remaining comment text for lpfc_unreg_rpi().

Assisted-by: unnamed:deepseek-v3.2 coccinelle
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 8aaf05d7bb0a..ac2a0b5b0034 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5228,12 +5228,11 @@ lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
 
 /*
  * Free rpi associated with LPFC_NODELIST entry.
- * This routine is called from lpfc_freenode(), when we are removing
- * a LPFC_NODELIST entry. It is also called if the driver initiates a
- * LOGO that completes successfully, and we are waiting to PLOGI back
- * to the remote NPort. In addition, it is called after we receive
- * and unsolicated ELS cmd, send back a rsp, the rsp completes and
- * we are waiting to PLOGI back to the remote NPort.
+ * This routine is called if the driver initiates a LOGO that completes
+ * successfully, and we are waiting to PLOGI back to the remote NPort.
+ * In addition, it is called after we receive and unsolicated ELS cmd,
+ * send back a rsp, the rsp completes and we are waiting to PLOGI back
+ * to the remote NPort.
  */
 int
 lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
-- 
2.25.1

