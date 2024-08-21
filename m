Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99451C6B5
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 06:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724221733; cv=none; b=OKvx1zPQ32yjrLMDsLUIffHxIMhCODgRhdSmCse7rfaRd9RHKpXGFBCUkePTxsHCCev606PxD2m5VPf9XJs2Ma9w99K3y6YujqxDrdXxk49F/Bzc4Lm2KZw1jWSVmhrNOk7OiRAica8exzH/a/3lEbnBZB2ShzqLXKds7kpTfkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724221733; c=relaxed/simple;
	bh=iposaii019J+QrRRCvYqwGgu0vCoISAJLhxnLHi/Xgk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y6d9U4vjru5fJhkhAVjZtOcM1ImCafugpbsf5X4GDbBlJb8DYyooklTHdNqaAAUH/badboHKtlN9m+MrZ6uWfUkLGbMpxJsVO0jw/zo3/98bhn0/X3m0KUJXih89jsYsGixXJ0zodrz0LP5vVwubiUbZcGl24HNbJa6N+zve3Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Wpby55RtHz2Cn28;
	Wed, 21 Aug 2024 14:28:45 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id C84E91401F3;
	Wed, 21 Aug 2024 14:28:47 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 21 Aug
 2024 14:28:47 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next 0/2] driver/scsi: use macro LIST_HEAD()
Date: Wed, 21 Aug 2024 14:36:07 +0800
Message-ID: <20240821063609.2292672-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Make use of the helper macro LIST_HEAD() to simplify the
code.

Hongbo Li (2):
  driver: scsi: Make use of the helper macro LIST_HEAD()
  driver: scsi: Make use of the helper macro LIST_HEAD()

 drivers/scsi/bnx2i/bnx2i_init.c | 2 +-
 drivers/scsi/qla2xxx/qla_os.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.34.1

