Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B87FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 09:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 661182186A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 09:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgFRJEb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 05:04:31 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2323 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728926AbgFRJEZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 05:04:25 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id A53006C186C361029693;
        Thu, 18 Jun 2020 10:04:23 +0100 (IST)
Received: from [127.0.0.1] (10.210.165.247) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Thu, 18 Jun
 2020 10:04:22 +0100
Subject: Re: fix ATAPI support for libsas drivers
To:     Christoph Hellwig <hch@lst.de>, <martin.petersen@oracle.com>
CC:     <brking@us.ibm.com>, <jinpu.wang@cloud.ionos.com>,
        <mpe@ellerman.id.au>, <linux-scsi@vger.kernel.org>,
        <linux-ide@vger.kernel.org>
References: <20200615064624.37317-1-hch@lst.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d3459f71-501e-3fea-d5dc-a5599758459d@huawei.com>
Date:   Thu, 18 Jun 2020 10:02:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200615064624.37317-1-hch@lst.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.165.247]
X-ClientProxiedBy: lhreml701-chm.china.huawei.com (10.201.108.50) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/06/2020 07:46, Christoph Hellwig wrote:
> Hi all,
> 
> this series fixes the ATAPI DMA drain refactoring for SAS HBAs that
> use libsas.
> .
> 

Something I meant to ask before and was curious about, specifically 
since ipr doesn't actually use libsas: Why not wire up other SAS HBAs, 
like megaraid_sas?

Thanks,
John
