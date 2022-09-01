Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43795C0502C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 14:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiIAOX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 10:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiIAOXm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 10:23:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872D978222
        for <linux-scsi@vger.kernel.org>; Thu,  1 Sep 2022 07:23:14 -0700 (PDT)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MJNTS480Hz688r1;
        Thu,  1 Sep 2022 22:19:24 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 16:23:12 +0200
Received: from [10.48.151.166] (10.48.151.166) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 1 Sep 2022 15:23:11 +0100
Message-ID: <9e9a24a0-3d04-306f-b8f6-dfe5fe03efab@huawei.com>
Date:   Thu, 1 Sep 2022 15:23:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 0/2] Prepare for constifying SCSI host templates
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Christoph Hellwig <hch@lst.de>
CC:     <linux-scsi@vger.kernel.org>
References: <20220830210509.1919493-1-bvanassche@acm.org>
In-Reply-To: <20220830210509.1919493-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.151.166]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/08/2022 22:05, Bart Van Assche wrote:

+ Krzysztof

This is the same topic as what Krzysztof was working on in 
https://lore.kernel.org/linux-scsi/6f28acde-2177-0bc7-b06d-c704153489c0@linaro.org/

And at least we have the scsi_host_template.module issue to solve - any 
plan or progress for that?

Thanks,
John

> Hi Martin,
> 
> This patch series prepares for constifying SCSI host templates by moving the
> members that are not constant out of the SCSI host template. Please consider
> this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> Changes compared to v1: fix the CONFIG_SCSI_PROC_FS=n build.
> 
> Bart Van Assche (2):
>    scsi: esas2r: Introduce scsi_template_proc_dir()
>    scsi: core: Introduce a new list for SCSI proc directory entries
> 
>   drivers/scsi/esas2r/esas2r_main.c |  18 +++--
>   drivers/scsi/scsi_proc.c          | 106 ++++++++++++++++++++++++++----
>   include/scsi/scsi_host.h          |  18 ++---
>   3 files changed, 110 insertions(+), 32 deletions(-)
> 
> .

