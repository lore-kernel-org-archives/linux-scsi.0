Return-Path: <SRS0=xWhZ=DN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1059FC4363D
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 14:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC579206DD
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 14:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFO1t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 10:27:49 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2961 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725906AbgJFO1t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Oct 2020 10:27:49 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id A0C064897DFD8A483C98;
        Tue,  6 Oct 2020 15:27:47 +0100 (IST)
Received: from [127.0.0.1] (10.210.170.159) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 6 Oct 2020
 15:27:46 +0100
Subject: Re: [PATCH v8 00/18] blk-mq/scsi: Provide hostwide shared tags for
 SCSI HBAs
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     <jejb@linux.ibm.com>, <don.brace@microsemi.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>,
        <dgilbert@interlog.com>, <paolo.valente@linaro.org>,
        <hare@suse.de>, <hch@lst.de>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <df6a3bd3-a89e-5f2f-ece1-a12ada02b521@kernel.dk>
 <379ef8a4-5042-926a-b8a0-2d0a684a0e01@huawei.com>
 <yq1363xbtk7.fsf@ca-mkp.ca.oracle.com>
 <32def143-911f-e497-662e-a2a41572fe4f@huawei.com>
 <yq1imcdw6ni.fsf@ca-mkp.ca.oracle.com>
 <32574da3d8de863ff38347ef6ead9b35@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1a7f30f3-d0bf-3703-2004-fba70cbe8212@huawei.com>
Date:   Tue, 6 Oct 2020 15:24:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <32574da3d8de863ff38347ef6ead9b35@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.170.159]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/09/2020 17:11, Kashyap Desai wrote:
>>
>> John,
>>
>>> Have you had a chance to check these outstanding SCSI patches?
>>>
>>> scsi: megaraid_sas: Added support for shared host tagset for
> cpuhotplug
>>> scsi: scsi_debug: Support host tagset
>>> scsi: hisi_sas: Switch v3 hw to MQ
>>> scsi: core: Show nr_hw_queues in sysfs
>>> scsi: Add host and host template flag 'host_tagset'
>>
>> These look good to me.
>>
>> Jens, feel free to merge.
> 
> Hi Jens, Gentle ping. I am not able to find commits for above listed scsi
> patches. I want to use your repo which has above mentioned patch for
> <scsi:io_uring iopoll> patch submission.  Martin has Acked the scsi
> patches.
> 
>>
>> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
>>
>> --
>> Martin K. Petersen	Oracle Linux Engineering


Hi Jens,

Could you kindly pick up the following patches, to go along with the 
blk-mq changes:

scsi: megaraid_sas: Added support for shared host tagset for
cpuhotplug
scsi: scsi_debug: Support host tagset
scsi: hisi_sas: Switch v3 hw to MQ
scsi: core: Show nr_hw_queues in sysfs
scsi: Add host and host template flag 'host_tagset'

Thanks,
John
