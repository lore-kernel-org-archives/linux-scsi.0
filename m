Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF17C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 17:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDBE1206DB
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 17:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815474AbgJ0RCe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 13:02:34 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:3002 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1815471AbgJ0RCd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Oct 2020 13:02:33 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 2DB0A143DA254A36515B;
        Tue, 27 Oct 2020 17:02:29 +0000 (GMT)
Received: from [10.47.8.138] (10.47.8.138) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 27 Oct
 2020 17:02:28 +0000
Subject: Re: [PATCHv6 00/21] scsi: enable reserved commands for LLDDs
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        <linux-scsi@vger.kernel.org>,
        chenxiang <chenxiang66@hisilicon.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
References: <20200703130122.111448-1-hare@suse.de>
 <ac78e944-25e1-15d7-7c9e-b7f439079222@huawei.com>
 <47ba045e-a490-198b-1744-529f97192d3b@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <c323d43c-771a-a30f-9bae-4f5d4e834e47@huawei.com>
Date:   Tue, 27 Oct 2020 16:59:07 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <47ba045e-a490-198b-1744-529f97192d3b@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.8.138]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/10/2020 15:53, Hannes Reinecke wrote:
>>
> That was actually on the list of things to do next, ie rebasing this 
> series now that the shared tags patchset is in.
> 

Sounds good.

> Oh, and I do have an updated hpsa patch, which doesn't crash on my 
> systems. Will be posting that one separately.

I always thought that change (switch to MQ) looked better with $subject 
series, but I'll leave that to you and Don.

cheers,
John
