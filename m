Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1042BAB
	for <linux-scsi@vger.kernel.org>; Mon, 11 Dec 2023 17:14:26 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Sq0xG3xwwzvPrt;
	Tue, 12 Dec 2023 09:13:38 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id DFC62140133;
	Tue, 12 Dec 2023 09:14:23 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Dec 2023 09:14:23 +0800
Subject: Re: [PATCH 0/5] scsi: hisi_sas: Minor fixes and cleanups
To: <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
References: <1699932486-206596-1-git-send-email-chenxiang66@hisilicon.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <c45761ab-beba-ec17-ddd9-005678a3abf5@hisilicon.com>
Date: Tue, 12 Dec 2023 09:14:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1699932486-206596-1-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500025.china.huawei.com (7.221.188.170)

Gentle ping...


在 2023/11/14 星期二 11:28, chenxiang 写道:
> From: Xiang Chen <chenxiang66@hisilicon.com>
>
> This series contain some fixes and cleanups including:
> - Set .phy_attached before notifying phyup event HISI_PHYEE_PHY_UP_PM;
> - Use standard error code instead of hardcode;
> - Check before using pointer variable;
> - Rollback some operations if FLR failed;
> - Correct the number of global debugfs registers;
>
> Yihang Li (5):
>    scsi: hisi_sas: Set .phy_attached before notifing phyup event
>      HISI_PHYE_PHY_UP_PM
>    scsi: hisi_sas: Replace with standard error code return value
>    scsi: hisi_sas: Check before using pointer variables
>    scsi: hisi_sas: Rollback some operations if FLR failed
>    scsi: hisi_sas: Correct the number of global debugfs registers
>
>   drivers/scsi/hisi_sas/hisi_sas_main.c  | 11 +++++++----
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 19 ++++++++++++-------
>   2 files changed, 19 insertions(+), 11 deletions(-)
>

