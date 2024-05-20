Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F50F4DA09;
	Mon, 20 May 2024 11:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716203111; cv=none; b=S6huK/5riIeGziy5EgJPmqi7mfITcMcghOV1TXMyX6teKNVI31Kz5w+rlzAXP7vXckpqsInYbeIF8Vs+Wvo/ZC330AdJinWjywyqrseXoWlgTkEt2c8AseJEQFvZdnexLu3hO16A7FSdBlYHDP63PrAMXoZ49cdKSCnc6ikQYvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716203111; c=relaxed/simple;
	bh=Kd7iT4a+Eb85p3qxLidrv0+DJA6dyWVZ3QopEgl0/HQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RILUd626eu8RK1UStqDEu0RnkOXacgWVWXZQa0M/8IrY3rqciqQ+7VFikqJzHHaZMWqYiHsP7oluiPfrj//4eveQOxzkuKY6P9wDIq+DWsjPVaxBuKimw1/ZVMa/P76XybJNvj3LA6tylxINeeQQRgjAuXpXbW9FkmGFOx45jVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from unicom146.biz-email.net
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id RIZ00053;
        Mon, 20 May 2024 19:04:53 +0800
Received: from localhost.localdomain (10.94.11.110) by
 jtjnmail201604.home.langchao.com (10.100.2.4) with Microsoft SMTP Server id
 15.1.2507.35; Mon, 20 May 2024 19:04:54 +0800
From: Deming Wang <wangdeming@inspur.com>
To: <jejb@linux.ibm.com>, <martin.petersen@orcal.com>
CC: <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] scsi: mpt3sas: remove unnecessary comments.
Date: Mon, 20 May 2024 07:04:53 -0400
Message-ID: <20240520110453.1598-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
tUid: 2024520190453ef3d4968520008d18be7906398bde47a
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Remove unnecessary comments.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12d08d8ba538..4f5c1b56c71b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2206,13 +2206,6 @@ _scsih_display_sata_capabilities(struct MPT3SAS_ADAPTER *ioc,
 	    (flags & MPI2_SAS_DEVICE0_FLAGS_SATA_SW_PRESERVE) ? "y" : "n");
 }
 
-/*
- * raid transport support -
- * Enabled for SLES11 and newer, in older kernels the driver will panic when
- * unloading the driver followed by a load - I believe that the subroutine
- * raid_class_release() is not cleaning up properly.
- */
-
 /**
  * scsih_is_raid - return boolean indicating device is raid volume
  * @dev: the device struct object
-- 
2.31.1

