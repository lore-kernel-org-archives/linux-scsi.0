Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA03C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 14:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD0CA611C0
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 14:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240761AbhI1OMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 10:12:23 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3885 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240841AbhI1OMW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 10:12:22 -0400
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HJhD93XMnz67DRW;
        Tue, 28 Sep 2021 22:07:53 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 16:10:41 +0200
Received: from [10.47.85.67] (10.47.85.67) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 28 Sep
 2021 15:10:40 +0100
Subject: Re: SCSI layer RPM deadlock debug suggestion
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        Xiejianqin <xiejianqin@hisilicon.com>
References: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
 <20210702203142.GA49307@rowland.harvard.edu>
 <ec4a3038-34b0-084f-a1bd-039827465dd1@acm.org>
 <1081c3ed-0762-58c7-8b99-8b3721c710bd@huawei.com>
 <20210705131712.GB116379@rowland.harvard.edu>
 <a5b9109c-cad6-0057-29c9-8974fda3347c@suse.de>
 <47f35811-33c5-9620-45d5-8201e5ec5db3@huawei.com>
 <20210714161027.GC380727@rowland.harvard.edu>
 <dc75007c-4a07-d1a9-6b86-2f6d2dc59271@huawei.com>
 <20210928140544.GA393436@rowland.harvard.edu>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ef485dfb-e355-1dd8-93cb-ea26be09f6c5@huawei.com>
Date:   Tue, 28 Sep 2021 15:13:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210928140544.GA393436@rowland.harvard.edu>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.85.67]
X-ClientProxiedBy: lhreml717-chm.china.huawei.com (10.201.108.68) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/09/2021 15:05, Alan Stern wrote:
>> As for your change itself, I had something similar sitting on our dev
>> branch:
>>
>> [0]https://github.com/hisilicon/kernel-dev/commit/3696ca85c1e00257c96e40154d28b936742430c4
>>
>> For me, I'm happy to hold off on any change, but if you think it's serious
>> enough to progress your patch, below, now, then I think that should be ok.
>>
>> Thanks,
>> John
> John:
> 
> We seem to have forgotten all about this.  I just now noticed that
> this hadn't gotten in 5.15-rc3... and the reason is that it was never
> submitted!
> 
> What would you like to do?
> 

Hi Alan,

We're still working through our driver RPM issues internally. It is 
taking a while.

Maybe in the next cycle we will look to upstream.

For now, I'm happy to leave this change pending.

Thanks,
John
