Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A733A29F;
	Wed, 14 Aug 2024 04:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723608092; cv=none; b=fMnfk4oyjkrvNBAj6DWrwrLixNi/ym7YfPvb+ItYnSJtegoT1W8VHLYJ3qv6riO5Fmbk7cn+hb6856rd7uloSWphkUHkbvIYj+FnRRST2ygbFSwc/Y/Ui/2ozvqD5n6n+PC0IKIS+6rlCpmRaH8tVHSioTokGFF0pQcj1OKlzao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723608092; c=relaxed/simple;
	bh=/Yck9BGkJAS4Qrhb2Taf8bZdwpcTpDPFxp9rQ7NUfEE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ry+Vbyg1FS4I+sMM5HhE7CYNjE+EjG1XN60YmzOMTp9WWTmt8uafe+Hak+RKZCy6lotZPvq35J9WqkSDzCC26b1Y5yuU6apjIWOr5NHJd8SJkkY4buqZ6Sxhl6evhnB+Eh2HZpti5ZkhWFERqluu2c4kns/CRplItxr4RhPWk48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WkDxn74q0z1HGFH;
	Wed, 14 Aug 2024 11:58:21 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 11D3A1A0188;
	Wed, 14 Aug 2024 12:01:26 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 14 Aug 2024 12:01:25 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liyihang9@huawei.com>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<chenxiang66@hisilicon.com>
Subject: [PATCH] MAINTAINERS: Update HiSilicon SAS controller driver maintainer
Date: Wed, 14 Aug 2024 12:01:24 +0800
Message-ID: <20240814040124.1376195-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)

Add Yihang Li as the maintainer of the HiSilicon SAS controller driver,
replacing Xiang Chen.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f328373463b0..26c2e788ea69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10173,7 +10173,7 @@ F:	Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
 F:	drivers/infiniband/hw/hns/
 
 HISILICON SAS Controller
-M:	Xiang Chen <chenxiang66@hisilicon.com>
+M:	Yihang Li <liyihang9@huawei.com>
 S:	Supported
 W:	http://www.hisilicon.com
 F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
-- 
2.33.0

