Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47976C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Oct 2022 08:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiJJIDn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Oct 2022 04:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiJJIDl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2022 04:03:41 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE18253A4E
        for <linux-scsi@vger.kernel.org>; Mon, 10 Oct 2022 01:03:38 -0700 (PDT)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MmBG53xp2z67PjK;
        Mon, 10 Oct 2022 16:02:05 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 10:03:36 +0200
Received: from [10.195.245.13] (10.195.245.13) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 10 Oct 2022 09:03:35 +0100
Message-ID: <cfb9e10a-5d42-4c76-952d-dd1f871dab64@huawei.com>
Date:   Mon, 10 Oct 2022 09:03:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 3/4] scsi: libsas: make use of ata_port_is_frozen() helper
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
References: <20221007132342.1590367-1-niklas.cassel@wdc.com>
 <20221007132342.1590367-4-niklas.cassel@wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20221007132342.1590367-4-niklas.cassel@wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.195.245.13]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/10/2022 14:23, Niklas Cassel wrote:
> Clean up the code by making use of the newly introduced
> ata_port_is_frozen() helper function.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

Reviewed-by: John Garry <john.garry@huawei.com>
