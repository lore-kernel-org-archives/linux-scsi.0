Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A2DC55194
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 15:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E0FE20767
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 15:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgDWPee (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 11:34:34 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2090 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729261AbgDWPed (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 11:34:33 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 84FE426C581A6B7BBBC7;
        Thu, 23 Apr 2020 16:34:31 +0100 (IST)
Received: from [127.0.0.1] (10.47.5.255) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 23 Apr
 2020 16:34:30 +0100
Subject: Re: [PATCH RFC v2 02/24] scsi: allocate separate queue for reserved
 commands
To:     Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@infradead.org>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-3-git-send-email-john.garry@huawei.com>
 <20200310183243.GA14549@infradead.org>
 <79cf4341-f2a2-dcc9-be0d-2efc6e83028a@huawei.com>
 <20200311062228.GA13522@infradead.org>
 <b5a63725-722b-8ccd-3867-6db192a248a4@suse.de>
 <9c6ced82-b3f1-9724-b85e-d58827f1a4a4@huawei.com>
 <39bc2d82-2676-e329-5d32-8acb99b0a204@suse.de>
 <20200407163033.GA26568@infradead.org>
 <ae3b498b-aea8-dc09-53b8-9e160effc681@huawei.com>
 <a0316b0b-a24c-7d0c-df17-0573593e2a11@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <17c47c8c-f993-b472-43ac-936cec560744@huawei.com>
Date:   Thu, 23 Apr 2020 16:33:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <a0316b0b-a24c-7d0c-df17-0573593e2a11@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.5.255]
X-ClientProxiedBy: lhreml722-chm.china.huawei.com (10.201.108.73) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> Not sure if we want a static scsi_device per host, or alloc and free 
>> dynamically.
>>
>> (@Hannes, I also have some proper patches for libsas if you want to 
>> add it)
>>
> Hold your horses.

I wasn't going to do anything else...

> I'm currently preparing a patchset implementing things by improving the 
> current scsi_get_host_dev() etc.

OK, great, all you have to do is say.

> 
> RFC should be ready by the end of the week.
> 

Thanks,
John
