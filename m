Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E68FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 15:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C90C20720
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 15:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgGIPoo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:44:44 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2450 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbgGIPon (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jul 2020 11:44:43 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 6208982A5FE6DC60C7BF;
        Thu,  9 Jul 2020 16:44:42 +0100 (IST)
Received: from [127.0.0.1] (10.47.5.154) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 9 Jul 2020
 16:44:41 +0100
Subject: Re: [PATCH v2 2/2] scsi: scsi_debug: Support hostwide tags
To:     <dgilbert@interlog.com>, <jejb@linux.vnet.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>,
        <ming.lei@redhat.com>, <kashyap.desai@broadcom.com>
References: <1594297400-24756-1-git-send-email-john.garry@huawei.com>
 <1594297400-24756-3-git-send-email-john.garry@huawei.com>
 <0eebd28b-ca5e-6ddc-1a16-6097cb1b5a08@interlog.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b65bb848-4065-6b88-2f5f-7c035be1ec82@huawei.com>
Date:   Thu, 9 Jul 2020 16:42:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0eebd28b-ca5e-6ddc-1a16-6097cb1b5a08@interlog.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.5.154]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/07/2020 16:25, Douglas Gilbert wrote:
>>
>> hwq = cpu % queue count
>>
>> If the host max queue param is set non-zero, then the max queue depth is
>> fixed at this value also.
>>
>> If and when hostwide shared tags are supported in blk-mq/scsi mid-layer,
>> then the policy to set nr_hw_queues = 0 for hostwide tags can be revised.
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
> 
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> 
> I have updated this page to reflect this addition:
> http://sg.danny.cz/sg/scsi_debug.html

ok, thanks.
