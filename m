Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F627C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 07:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48EF520809
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 07:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgIPHYQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 03:24:16 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2827 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbgIPHYP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Sep 2020 03:24:15 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id F277770C11FE90AC6EED;
        Wed, 16 Sep 2020 08:24:11 +0100 (IST)
Received: from [127.0.0.1] (10.47.2.96) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 16 Sep
 2020 08:24:10 +0100
Subject: Re: [PATCH v8 00/18] blk-mq/scsi: Provide hostwide shared tags for
 SCSI HBAs
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <don.brace@microsemi.com>, <kashyap.desai@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>,
        <dgilbert@interlog.com>, <paolo.valente@linaro.org>,
        <hare@suse.de>, <hch@lst.de>, <sumit.saxena@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
        <megaraidlinux.pdl@broadcom.com>, <chenxiang66@hisilicon.com>,
        <luojiaxing@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <df6a3bd3-a89e-5f2f-ece1-a12ada02b521@kernel.dk>
 <379ef8a4-5042-926a-b8a0-2d0a684a0e01@huawei.com>
 <yq1363xbtk7.fsf@ca-mkp.ca.oracle.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <32def143-911f-e497-662e-a2a41572fe4f@huawei.com>
Date:   Wed, 16 Sep 2020 08:21:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <yq1363xbtk7.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.2.96]
X-ClientProxiedBy: lhreml746-chm.china.huawei.com (10.201.108.196) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/09/2020 13:44, Martin K. Petersen wrote:
>> Martin/James may want more review of the SCSI core bits, though.
> I'll take a look later today.


Hi Martin,

Have you had a chance to check these outstanding SCSI patches?

scsi: megaraid_sas: Added support for shared host tagset for cpuhotplug
scsi: scsi_debug: Support host tagset
scsi: hisi_sas: Switch v3 hw to MQ
scsi: core: Show nr_hw_queues in sysfs
scsi: Add host and host template flag 'host_tagset'

Cheers,
John
