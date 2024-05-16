Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA491459E2;
	Thu, 16 May 2024 12:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715861179; cv=none; b=NGoVeak3ZYYnJm+2ZvYTGt4L9N28YGuilxnEQtsmacTpMnvqptTvGa+uHkG+WRdJilYpG7J/Saxpydn5H0stOOCDfwhvXrdTTbLzvu5CkugVohuYQ6iGRgBFDBjoed5ieeWhgTaDckNio5v54wiHlsKOWBG2yhs6LoA3kO8DDeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715861179; c=relaxed/simple;
	bh=wqTSY0U/MqPG50yT6px0iDafyA9m2T6CDMdnd18dOhQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=opygA9xjkVjYsXdCRgEz738XK58rynJn5wm6dxUxngx8rxCh+IexaCJa2Vas5N4sN3X+z439wD+vC6wKb+CqymW96F9rr5JW9sPZPiPlEYzKlbfxqvUvj4K6mbDIynWu3RO2Kv7lE2t4T/XUpnIeyaoIBSPH/R3f//apR3uoXUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from unicom145.biz-email.net
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id NJW00100;
        Thu, 16 May 2024 20:05:00 +0800
Received: from localhost.localdomain (10.94.5.253) by
 jtjnmail201611.home.langchao.com (10.100.2.11) with Microsoft SMTP Server id
 15.1.2507.35; Thu, 16 May 2024 20:04:59 +0800
From: Deming Wang <wangdeming@inspur.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Deming Wang <wangdeming@inspur.com>
Subject: [PATCH] scsi: mpt3sas: Add the description for _scsih_get_sas_address
Date: Thu, 16 May 2024 08:03:47 -0400
Message-ID: <20240516120347.1641-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
tUid: 20245162005009b44ed302864a4fa6028cb316a3e5099
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Add the description for the '_scsih_get_sas_address' function.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12d08d8ba538..3d955dac5778 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -499,7 +499,7 @@ _scsih_is_boot_device(u64 sas_address, u64 device_name,
 
 /**
  * _scsih_get_sas_address - set the sas_address for given device handle
- * @ioc: ?
+ * @ioc: per adapter object
  * @handle: device handle
  * @sas_address: sas address
  *
-- 
2.31.1

