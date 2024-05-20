Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22854182DF;
	Mon, 20 May 2024 11:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716203158; cv=none; b=ZICk7MYiY5q0xzR5TPIirN844mrlvr1hwHeaUoaG7Mz0WMDpiBMh5GXFoJnqK86Cnr/CnQqTsGdqBn3kVU5hMWCQmfyO2WkQvEgderuKF9y93xNEpKZjlaISHASM17Q2W/khI++0wd7OZLAFgYxKyr9o0BbfBIvnwgM5boJRSbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716203158; c=relaxed/simple;
	bh=ZZ4fI+rvH0q4oAcFDZWwjVo6DH1kfeXdNpFAbj9Q/GE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=An7hlFUPJyuo2Cz8zQ/VLGBWymdGpDiDW95q/n4/4sDKkD+gRHJi0aEBV+g+r6MfDhRcj+hjVofrFztVyHDCw3dL8tzW+o2r60nVF1D+wyXzEFTFInpuC3+gCTTGU/oHFcEYsIO/mOFnJ6ACA7pxLtc2e5xAo9JuNGR9O7Ipe0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from unicom146.biz-email.net
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id RIA00146;
        Mon, 20 May 2024 19:05:46 +0800
Received: from localhost.localdomain (10.94.11.110) by
 jtjnmail201604.home.langchao.com (10.100.2.4) with Microsoft SMTP Server id
 15.1.2507.35; Mon, 20 May 2024 19:05:48 +0800
From: Deming Wang <wangdeming@inspur.com>
To: <jejb@linux.ibm.com>, <martin.petersen@orcal.com>
CC: <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] scsi: mpt3sas: Use a unified annotation style
Date: Mon, 20 May 2024 07:05:46 -0400
Message-ID: <20240520110546.1652-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
tUid: 202452019054680586f228c4f3ba84241561ee0f3ba81
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Use a unified annotation style.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12d08d8ba538..97062b440e9d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2681,8 +2681,8 @@ scsih_device_configure(struct scsi_device *sdev, struct queue_limits *lim)
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
 		mpt3sas_scsih_change_queue_depth(sdev, qdepth);
 		/* Enable QUEUE_FLAG_NOMERGES flag, so that IOs won't be
-		 ** merged and can eliminate holes created during merging
-		 ** operation.
+		 * merged and can eliminate holes created during merging
+		 * operation.
 		 **/
 		blk_queue_flag_set(QUEUE_FLAG_NOMERGES,
 				sdev->request_queue);
-- 
2.31.1

