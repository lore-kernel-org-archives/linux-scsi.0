Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935D4336896;
	Thu,  5 Mar 2026 06:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772693225; cv=none; b=eFtWSD21cfQwABec+yvktW+rnYSXhbPTu06S7dRN6tkhUrK/kltwSlWKDXWQGvb0LgmoXAx7oWwSyCfX/AIqVAhl+maoqYZaMvgO1nxKvaWkIdSleKpor+oRhvId9nwvl6rkKBqMpTOzC+95JiDq+r9kK8RF25PtO66jAPEnnhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772693225; c=relaxed/simple;
	bh=FfnGczqU/SwcPbEJaFDVOch6xgwDxdxUebM5yOi7jcQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bik3M7qImYjmxJw9U1UL1fVP0Lo5XPEY4gH0DI2Z4KVmdIQiDcntImD7W6zu1gh6+glcasari7smSIaD8W1l5nTk/gt79wy8+d6JQ2Kn2y6kX7N5tFDf2kX2qY3sqJKh8sWZcvGZ7g707lERzJMcYXbsZNG/IGk+rIQYnIhPJgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=LrB2q7FO; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="LrB2q7FO"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=p+VuLr4mlSyPNlfHDq1NugtnyxgrFdT9iU9DHzdTKk0=;
	b=LrB2q7FOxSe91eFnkkKdtzZDp4slRBLW/5VtqAVWg5JDDOmrjajHutEjfIkQf4v5/52ZpVc2R
	umHjnJqkjV4lMaGF6BVkeukMD9EINLnoz2PmbkoxkiUMWSzd2HVAYb86BcVW0wFn64FzVwAKSGh
	NKGiYOdgFca6spy6dXfcx5Q=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4fRKhg5tY9z1K97f;
	Thu,  5 Mar 2026 14:42:11 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id 2799540563;
	Thu,  5 Mar 2026 14:47:01 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Mar 2026 14:47:00 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangxingui@h-partners.com>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<liyihang9@h-partners.com>, <liuyonglong@huawei.com>
Subject: [RESEND PATCH 0/2] Clean up the hisi_sas driver source code
Date: Thu, 5 Mar 2026 14:46:58 +0800
Message-ID: <20260305064700.116033-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemh200005.china.huawei.com (7.202.181.112)

This series mainly consists of some minor cleanups, printing format issue
and risk of overflow in bitwise logical. No functional changes overall.

Yihang Li (2):
  scsi: hisi_sas: Correct the printing format issues
  scsi: hisi_sas: Fixed the risk of overflow in bitwise logical
    operations

 drivers/scsi/hisi_sas/hisi_sas_main.c  |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.33.0

