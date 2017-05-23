From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH 1/2] libsas: Don't process sas events in static works
Date: Tue, 23 May 2017 14:39:21 +0800
Message-ID: <5923D919.30408@huawei.com>
References: <1495262360-40135-1-git-send-email-wangyijing@huawei.com>
 <1495262360-40135-2-git-send-email-wangyijing@huawei.com>
 <CAPcyv4idOqGpdFt=FKRPs0gAqYc8pOv+=gL3PGN0Wgp6maUcMw@mail.gmail.com>
 <59227D16.6000102@huawei.com>
 <392354c0-a4a1-99a8-7723-25513efb835c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <392354c0-a4a1-99a8-7723-25513efb835c@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Dan Williams <dan.j.williams@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, chenqilin2@huawei.com, hare@suse.com, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, Wei Fang <fangwei1@huawei.com>, yanaijie@huawei.com, Christoph Hellwig <hch@lst.de>, Yousong He <heyousong@huawei.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

>>
> 
> I have seen this scenario on our development board when we have a bad physical cable connection - the PHY continually goes up and down in a loop.
> 
> So, in this regard, it is worth safeguarding against this scenario.

OK, I will reconsider this case.

Thanks!
Yijing.


> 
> John
> 
> 
> .
> 
