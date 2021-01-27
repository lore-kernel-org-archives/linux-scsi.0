Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CA8C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 14:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D4B3207C7
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 14:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhA0OeI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 09:34:08 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2439 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbhA0Oc1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 09:32:27 -0500
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DQm9Y63Sjz67h7C;
        Wed, 27 Jan 2021 22:25:53 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 27 Jan 2021 15:31:45 +0100
Received: from [10.47.4.0] (10.47.4.0) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 27 Jan
 2021 14:31:44 +0000
Subject: Re: [RESEND PATCH v2 0/4] io_uring iopoll in scsi layer
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-scsi@vger.kernel.org>
References: <20210127035527.40622-1-kashyap.desai@broadcom.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2d1387f4-66ac-301e-034a-9af0dc2b015d@huawei.com>
Date:   Wed, 27 Jan 2021 14:30:22 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210127035527.40622-1-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.4.0]
X-ClientProxiedBy: lhreml726-chm.china.huawei.com (10.201.108.77) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/01/2021 03:55, Kashyap Desai wrote:
> This patch series is to support io_uring iopoll feature
> in scsi stack. This patch set requires shared hosttag support.
> 
> This patch set is created on top of 5.12/scsi-staging branch.
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/mkp/scsi/+/refs/heads/5.12/scsi-staging
> 
> Resend this series as I have to rebase it to 5.12/scsi-staging.
> 
> v2 ->
> - updated feedback from v1.
> - add reviewed-by & tested-by tag

There are no reviewed-by tags, even though we provided some previously:

https://lore.kernel.org/linux-scsi/340133e8-893c-e8c8-cf0e-3d6dc9da20ea@huawei.com/#t

Thanks,
John

> - remove flood of prints in scsi_debug driver during iopoll
>    reported by Douglas Gilbert.
> - added new patch to support to get shost from hctx.
>    added new helper function "scsi_init_hctx"

