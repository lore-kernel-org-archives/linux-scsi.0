Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F826C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 08:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FFE60F36
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 08:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhKAIzu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 04:55:50 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:4042 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhKAIzu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 04:55:50 -0400
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HjRXM6CpYz67kSQ;
        Mon,  1 Nov 2021 16:48:51 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Mon, 1 Nov 2021 09:53:14 +0100
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 08:53:14 +0000
Subject: Re: kernel 5.15 does not boot with 3ware card (never had this issue
 <= 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) timed out,
 resetting card
To:     Bart Van Assche <bvanassche@acm.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
References: <006a01d7cead$b9262d70$2b728850$@lucidpixels.com>
 <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0d9db49d-84c2-4fda-3c7d-0286cdff8cf6@huawei.com>
Date:   Mon, 1 Nov 2021 08:53:13 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml719-chm.china.huawei.com (10.201.108.70) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/10/2021 23:52, Bart Van Assche wrote:
> On 10/31/21 16:19, Justin Piszcz wrote:
>> Diff between 5.14 and 5.15 .config files-- could it be something to do 
>> with
>> CONFIG_IOMMU_DEFAULT_DMA_LAZY=y?

On x86 (intel or amd) iommu we were using lazy mode previously, but just 
did not have a config option, so should not make a difference.


> 
> That's hard to say. Is CONFIG_MAGIC_SYSRQ enabled? If not, please enable 
> it and hit Alt-Printscreen-t (dump task list; see also 
> Documentation/admin-guide/sysrq.rst) and share the contents of the 
> kernel log. If that would not be convenient, please try to bisect this 
> issue.

