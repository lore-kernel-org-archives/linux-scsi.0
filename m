From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v2 3/3] scsi: libsas: initialize sas_phy status according
 to response of DISCOVER
Date: Thu, 4 Jan 2018 20:42:50 +0800
Message-ID: <5A4E214A.5040101@huawei.com>
References: <20180104114741.37358-1-yanaijie@huawei.com>
 <20180104114741.37358-4-yanaijie@huawei.com> <20180104124121.GC6749@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:57922 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752330AbeADMp2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jan 2018 07:45:28 -0500
In-Reply-To: <20180104124121.GC6749@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hare@suse.com, chenxiang <chenxiang66@hisilicon.com>



On 2018/1/4 20:41, Christoph Hellwig wrote:
> On Thu, Jan 04, 2018 at 07:47:41PM +0800, Jason Yan wrote:
>> +	phy->phy->enabled = (phy->linkrate == SAS_PHY_DISABLED) ? 0:1;
>
> missing whitespaces around the ":, but this could just be simplified to:
>
> 	phy->phy->enabled = (phy->linkrate != SAS_PHY_DISABLED);
>

That's better, will update. Thanks.

> Otherwise this looks fine.
>
> .
>
