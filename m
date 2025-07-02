Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329D0487A5;
	Wed,  2 Jul 2025 01:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751419482; cv=none; b=Veo0xrzZDGDMZ4/tX2I4aTnpe2JNq0q40SteCo47NXu1zTrL9lbt/1ses7DdBHGZgDePoFImLvyXxQBG8F47aRGIzNGTxxfv0r02R1t1w9xN6241kwMkJC4jp/Tr8pRaxbovwMnT0TgldBETDot7kCfrqwoLx6cq5UjDXdm/iGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751419482; c=relaxed/simple;
	bh=0UL0XMhpIwk4bK3SsQ5tofRptiTYrAuCESz+i6PWB5s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LgSiBgecHizuJ6bxw9t9ZTZKb4hj5kqeSB75wsmJh2pMvM0roRNmdJg/gc6nup7WER9SXLkHXI+HO5WYpuAkILW5taSnB/9yZ9dlaBi00LZtVf1R7NXoq+kiIzs3Igmpv/35h+lREzvXt+AW4LV2BLCLk8TPogOqJW3rXn9T1Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4bX2Fb5QT9z2Bcmp;
	Wed,  2 Jul 2025 09:22:43 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id 473C8140295;
	Wed,  2 Jul 2025 09:24:30 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 2 Jul 2025 09:24:24 +0800
From: Yihang Li <liyihang9@h-partners.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>
Subject: [PATCH] scsi: MAINTAINERS: Update hisi_sas entry
Date: Wed, 2 Jul 2025 09:24:23 +0800
Message-ID: <20250702012423.1947238-1-liyihang9@h-partners.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemh200005.china.huawei.com (7.202.181.112)

liyihang9@huawei.com no longer works. So update information for hisi_sas.

Signed-off-by: Yihang Li <liyihang9@h-partners.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a92290fffa16..05325fab7a6b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10949,7 +10949,7 @@ F:	Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
 F:	drivers/infiniband/hw/hns/
 
 HISILICON SAS Controller
-M:	Yihang Li <liyihang9@huawei.com>
+M:	Yihang Li <liyihang9@h-partners.com>
 S:	Supported
 W:	http://www.hisilicon.com
 F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
-- 
2.33.0

