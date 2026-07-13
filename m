Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ED93DB980
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 09:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783933277; cv=none; b=lOt3qJ043QJlx0gIqBA/8sV5n9CDltRwFkJV0+6M/xioptqbfCBX3x3Bo+frSDcrf8B13cJpdcS8GlRWuhrASzFMy0fWG6SYHjeJfBVtZUJvoe8426aR8749pkaN+7MT1Ee0f18V2nPyb1OAnLMAhXBO8zIk9e/3tN8baUEfLlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783933277; c=relaxed/simple;
	bh=rHMuM7J4pRNHKBnY89EHxEjl8DVA50PBlRSK04Bbsms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X++CckTRhr7fvjhGJq0gyW5BsA96syfpndkhaLNFnxN3Os3wMKOZunDQG1gT3jjHbRod7HhI5UWKiOT7yyk949Xq4DXdC5iDtxNkHRw2VeIyDrZU4R9eG+hG/owlvyhvjG0GgCGS3Uut2YEKBnjHtqxE1ho1sGeN6XCR1G+QZJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gmHa0eqj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gmHa0eqj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783933275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SVXsZ8MkliphxqtJRsm1Y1yxw0BKg93aj4HTiUHcmo4=;
	b=gmHa0eqjfoL+AkDy3zX8kqD/emm0Se5pb6nNwaQDUW4ICJHPZuR+gD11gi54OiW4/fq3aC
	ODQaIPLmIqCCSLVzMsq0NWk1S/F9Ug30f5uRf2zsvxN098Os3B5tP/MP9/kmOKCnYQZzlI
	lWo0JNORF5g9DDMZ/Ov56qzU689h84Y=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-310-4Agobc53PIGHRaAsfq023A-1; Mon,
 13 Jul 2026 05:01:12 -0400
X-MC-Unique: 4Agobc53PIGHRaAsfq023A-1
X-Mimecast-MFC-AGG-ID: 4Agobc53PIGHRaAsfq023A_1783933270
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EDD3A1954AE2;
	Mon, 13 Jul 2026 09:01:09 +0000 (UTC)
Received: from nprabudo-thinkpadp16vgen1.rmtin.csb (unknown [10.74.64.171])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 644E936F29;
	Mon, 13 Jul 2026 09:01:05 +0000 (UTC)
From: Nimal Prabudoss I <nprabudo@redhat.com>
To: GR-QLogic-Storage-Upstream@marvell.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com
Cc: jmeneghi@redhat.com,
	mschmidt@redhat.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nimal Prabudoss I <nprabudo@redhat.com>
Subject: [PATCH] MAINTAINERS: Update QED and Broadcom maintainer entries
Date: Mon, 13 Jul 2026 05:01:00 -0400
Message-ID: <20260713090100.126362-1-nprabudo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

---
 MAINTAINERS | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14968b84f0f6..7197b9aa4278 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4560,7 +4560,8 @@ F:	include/linux/bcm963xx_nvram.h
 F:	include/linux/bcm963xx_tag.h
 
 BROADCOM BNX2 GIGABIT ETHERNET DRIVER
-M:	Rasesh Mody <rmody@marvell.com>
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
 M:	GR-Linux-NIC-Dev@marvell.com
 L:	netdev@vger.kernel.org
 S:	Supported
@@ -4568,14 +4569,16 @@ F:	drivers/net/ethernet/broadcom/bnx2.*
 F:	drivers/net/ethernet/broadcom/bnx2_*
 
 BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
-M:	Saurav Kashyap <skashyap@marvell.com>
-M:	Javed Hasan <jhasan@marvell.com>
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
 M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2fc/
 
 BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
 M:	Nilesh Javali <njavali@marvell.com>
 M:	Manish Rangankar <mrangankar@marvell.com>
 M:	GR-QLogic-Storage-Upstream@marvell.com
@@ -18927,7 +18930,8 @@ F:	drivers/infiniband/hw/qib/
 
 QLOGIC QL41xxx FCOE DRIVER
 M:	Saurav Kashyap <skashyap@marvell.com>
-M:	Javed Hasan <jhasan@marvell.com>
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
 M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
@@ -18935,14 +18939,16 @@ F:	drivers/scsi/qedf/
 
 QLOGIC QL41xxx ISCSI DRIVER
 M:	Nilesh Javali <njavali@marvell.com>
-M:	Manish Rangankar <mrangankar@marvell.com>
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
 M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/qedi/
 
 QLOGIC QL4xxx ETHERNET DRIVER
-M:	Manish Chopra <manishc@marvell.com>
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/qlogic/qed/
@@ -18951,6 +18957,8 @@ F:	include/linux/qed/
 
 QLOGIC QL4xxx RDMA DRIVER
 M:	Michal Kalderon <mkalderon@marvell.com>
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/hw/qedr/
@@ -18963,6 +18971,8 @@ S:	Maintained
 F:	drivers/scsi/qla1280.[ch]
 
 QLOGIC QLA2XXX FC-SCSI DRIVER
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
 M:	Nilesh Javali <njavali@marvell.com>
 M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
@@ -18977,7 +18987,8 @@ F:	drivers/net/ethernet/qlogic/qla3xxx.*
 
 QLOGIC QLA4XXX iSCSI DRIVER
 M:	Nilesh Javali <njavali@marvell.com>
-M:	Manish Rangankar <mrangankar@marvell.com>
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
 M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
-- 
2.54.0

