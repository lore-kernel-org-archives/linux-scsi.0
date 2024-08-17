Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9572107;
	Sat, 17 Aug 2024 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723858832; cv=none; b=V+enCEcTnNamHuFzNFwwapalIbMnmvEtJ0aPJwjLBfPvU9u+C55sqzLysIXdXu91dERM7/086e8PEbX3dIhBWyevFaGkVLnhWbNgwraTwGb0C4UXxng076KocUWMjcTqsROslfBGt2IndiTnbnIQEmfYXSY8ilUuk4QtoU/hozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723858832; c=relaxed/simple;
	bh=yeVwr2yXh1RDuA9NaxFgcJt2nJbujr/WRA+Wo5BJReM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Um/ogSsyYIBRG8VmYbBdPYOwa514FWmAi8NI33vni/+hq79Kz+VeDLK2GcMldBmrRo0O83+ETWsl1qVjkDbtLrep4FHQyYu07GFOUPwaSeT9822uNPIge8Dsr8YcHCysGqdlIpFV3Lp+GmHCWl4cwXdgBnzfNX7Igcf8Wb8gX9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wm1gX52Qzz1HGQL;
	Sat, 17 Aug 2024 09:37:12 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id EFCF71400D2;
	Sat, 17 Aug 2024 09:40:19 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Aug 2024 09:40:19 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liyihang9@huawei.com>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<chenxiang66@hisilicon.com>
Subject: [PATCH v2] MAINTAINERS: Update HiSilicon SAS controller driver maintainer
Date: Sat, 17 Aug 2024 09:40:19 +0800
Message-ID: <20240817014019.3437222-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf100013.china.huawei.com (7.185.36.179)

Xiang Chen will not focus on HiSilicon SAS controller driver, so add
Yihang Li as the maintainer of replacing Xiang Chen.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
Changes since v1:
- Add Reviewed-by for Xiang Chen.

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

