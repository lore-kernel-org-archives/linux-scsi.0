X-Greylist: delayed 209 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Dec 2023 19:43:58 PST
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D5493
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 19:43:58 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4SrJ8S3VMXz1Q6MW;
	Thu, 14 Dec 2023 11:42:48 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id E71851400CF;
	Thu, 14 Dec 2023 11:43:56 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 11:43:56 +0800
Subject: Re: [PATCH 0/5] scsi: hisi_sas: Minor fixes and cleanups
To: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1699932486-206596-1-git-send-email-chenxiang66@hisilicon.com>
 <c45761ab-beba-ec17-ddd9-005678a3abf5@hisilicon.com>
 <yq14jglij1l.fsf@ca-mkp.ca.oracle.com>
CC: <jejb@linux.vnet.ibm.com>, <linuxarm@huawei.com>,
	<linux-scsi@vger.kernel.org>
From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <1825cce4-960b-4f2b-3c43-910b760b36bd@hisilicon.com>
Date: Thu, 14 Dec 2023 11:43:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <yq14jglij1l.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500025.china.huawei.com (7.221.188.170)

Hi,


在 2023/12/14 星期四 11:06, Martin K. Petersen 写道:
>> Gentle ping...
>>
>> 在 2023/11/14 星期二 11:28, chenxiang 写道:
>>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>>
>>> This series contain some fixes and cleanups including:
>>> - Set .phy_attached before notifying phyup event HISI_PHYEE_PHY_UP_PM;
>>> - Use standard error code instead of hardcode;
>>> - Check before using pointer variable;
>>> - Rollback some operations if FLR failed;
>>> - Correct the number of global debugfs registers;
> I don't have this submission. Can't see it in neither lore, nor
> patchwork. Please resubmit.

There seems to be a problem with my email sending before, but i didn't 
notice it.
I have resent those patchset.

Thanks
chenxiang

