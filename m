Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCCFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 10:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiBIKpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 05:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiBIKpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 05:45:31 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA518E0A24B4
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 02:30:10 -0800 (PST)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JtvJV1QFGz687xN;
        Wed,  9 Feb 2022 17:11:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 10:11:41 +0100
Received: from [10.47.89.1] (10.47.89.1) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 9 Feb
 2022 09:11:37 +0000
Message-ID: <79fbdb3d-0d0d-fb18-82e8-32e302297b97@huawei.com>
Date:   Wed, 9 Feb 2022 09:11:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 02/44] nsp_cs: Use true and false instead of TRUE and
 FALSE
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-3-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220208172514.3481-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.89.1]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/02/2022 17:24, Bart Van Assche wrote:
> Additionally, change the return type of the functions that always return
> TRUE from 'int' into 'void'. This patch prepares for removal of the
> drivers/scsi/scsi.h header file. That header file defines the 'TRUE' and
> 'FALSE' constants.
> 
> Reviewed-by: Johannes Thumshirn<johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>


FWIW,

Reviewed-by: John Garry <john.garry@huawei.com>
