Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08FCF2
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 20:00:29 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4SrJ5b3cS6z1wnlb;
	Thu, 14 Dec 2023 11:40:19 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id 54A481404F9;
	Thu, 14 Dec 2023 11:40:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 11:40:26 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>, Xiang Chen
	<chenxiang66@hisilicon.com>
Subject: [RESEND PATCH 0/5] scsi: hisi_sas: Minor fixes and cleanups
Date: Thu, 14 Dec 2023 11:45:11 +0800
Message-ID: <1702525516-51258-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500025.china.huawei.com (7.221.188.170)

From: Xiang Chen <chenxiang66@hisilicon.com>

This series contain some fixes and cleanups including:
- Set .phy_attached before notifying phyup event HISI_PHYEE_PHY_UP_PM;
- Use standard error code instead of hardcode;
- Check before using pointer variable;
- Rollback some operations if FLR failed;
- Correct the number of global debugfs registers;

Yihang Li (5):
  scsi: hisi_sas: Set .phy_attached before notifing phyup event
    HISI_PHYE_PHY_UP_PM
  scsi: hisi_sas: Replace with standard error code return value
  scsi: hisi_sas: Check before using pointer variables
  scsi: hisi_sas: Rollback some operations if FLR failed
  scsi: hisi_sas: Correct the number of global debugfs registers

 drivers/scsi/hisi_sas/hisi_sas_main.c  | 11 +++++++----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 19 ++++++++++++-------
 2 files changed, 19 insertions(+), 11 deletions(-)

-- 
2.8.1

