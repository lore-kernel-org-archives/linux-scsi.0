Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2954063C;
	Fri, 16 Aug 2024 09:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798860; cv=none; b=ut2+D0bvxqXC9oiLL5OdgsTApLELMMM9wc4UY34kioz2aIU2ep2cPwfJVrcd/JPHmaGBRhvq8cp8pooGhH+xR9cTklEL76cd2dvYXVcHVbbyt7jhFYFCMmvNBU1l+8BmE1BEFHbJQgc9mCMND+P+em6Nvd7G7KbdziPO0tPW4UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798860; c=relaxed/simple;
	bh=SlgCZ2eQgx2UJcpJVh1GSxRXUMC10H4Eyeef73RMgY0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m5/a5Xqkfl8xPkOaNc44R9GCcu3cN0eyCzYA/FeLqaG6Y+KYrg8YFhT0zuo3ZuuXUNGhyFci9uZk65lU9ITvtomVLX/nrXPS0RYCr1jbUvaqwO9DClabfR06zIenZ9NbhJ8v920AvpL4Q4I/hQx4rJbCTiM/8BOqoOIBJ4A0APs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DFnT+MOA; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DFnT+MOA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1723798849; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=aFfVZtyqR08IVTCvy0rDquI0TbpiESxA/RY1m3+3LbU=;
	b=DFnT+MOAjfyf+OurS5zEGpisvbB86isKYPoVL14aLNYFdrTptHz5tyUl+7o1ehfdxzdp0885oSBtJM65ugw1JGRVv1bexLx9sFPjCF+G0QIIFn4Qjs0VdlPgEVOmSmFePD8Pdqo+czFmXU6x2wVS1FBycQGMgCuj5i4tTrlhNAU=
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0WCzwoP6_1723798528)
          by smtp.aliyun-inc.com;
          Fri, 16 Aug 2024 16:55:29 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] scsi: qla2xxx: Add missing kernel-doc function comments.
Date: Fri, 16 Aug 2024 16:55:28 +0800
Message-Id: <20240816085528.99675-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing kernel-doc function comments to enhance code readability and
maintainability in accordance with the kernel coding standards.

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fe98c76e9be3..6988c931720b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3884,6 +3884,7 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
  * @vha: host adapter pointer
  * @rsp: respond queue
  * @pkt: head iocb describing how many continuation iocb
+ * @rsp_q_in: index of the response queue input pointer
  * Return: 0 all iocbs has arrived, xx- all iocbs have not arrived.
  */
 static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
-- 
2.32.0.3.g01195cf9f

