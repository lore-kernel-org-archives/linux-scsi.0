Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A05C7618E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 01:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjDUB5z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Apr 2023 21:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjDUB5y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2023 21:57:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359CE198D
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 18:57:53 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q2cxy1v3szSw6s;
        Fri, 21 Apr 2023 09:53:42 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 09:57:51 +0800
Subject: Re: [PATCH v2 2/3] scsi: libsas: Remove an empty branch in
 sas_check_parent_topology()
To:     Christoph Hellwig <hch@lst.de>
CC:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <hare@suse.com>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>
References: <20230420143339.2769414-1-yanaijie@huawei.com>
 <20230420143339.2769414-3-yanaijie@huawei.com>
 <20230420150201.GB11103@lst.de>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <6fe2b1df-3b7a-c3aa-9210-d2786fc9f82e@huawei.com>
Date:   Fri, 21 Apr 2023 09:57:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230420150201.GB11103@lst.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/4/20 23:02, Christoph Hellwig wrote:
> On Thu, Apr 20, 2023 at 10:33:38PM +0800, Jason Yan wrote:
>> There is an empty "All good" branch in sas_check_parent_topology(). We can
>> reverse the test statement and remove the empty branch.
> 
> Eww, this code is pretty unreadable (as-is and after the change).
> Can you move SAS_EDGE_EXPANDER_DEVICE case into a helper to
> make it readabke?  That has the extra upside of just being able to
> return the error code instead of assigning it to res.

Sure.
