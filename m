Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC96C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 11:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbiBYLBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 06:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiBYLBB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 06:01:01 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FD122F977;
        Fri, 25 Feb 2022 03:00:30 -0800 (PST)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K4mxg5VmJz67fYK;
        Fri, 25 Feb 2022 18:59:35 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 12:00:28 +0100
Received: from [10.47.84.151] (10.47.84.151) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 25 Feb
 2022 11:00:27 +0000
Message-ID: <19bbbdfd-6dd2-f209-3621-cc85de6254db@huawei.com>
Date:   Fri, 25 Feb 2022 11:00:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 8/8] scsi: remove <scsi/scsi_request.h>
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
References: <20220224175552.988286-1-hch@lst.de>
 <20220224175552.988286-9-hch@lst.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220224175552.988286-9-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.84.151]
X-ClientProxiedBy: lhreml737-chm.china.huawei.com (10.201.108.187) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/02/2022 17:55, Christoph Hellwig wrote:
> This header is empty now except for an include of <linux/blk-mq.h>, so
> remove it.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

FWIW,

Reviewed-by: John Garry <john.garry@huawei.com>
