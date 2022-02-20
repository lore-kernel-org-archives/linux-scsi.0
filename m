Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A25C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 09:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240444AbiBTJts (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Feb 2022 04:49:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiBTJtq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Feb 2022 04:49:46 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F4550450
        for <linux-scsi@vger.kernel.org>; Sun, 20 Feb 2022 01:49:25 -0800 (PST)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K1gWb3PBRz67Klm;
        Sun, 20 Feb 2022 17:44:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sun, 20 Feb 2022 10:49:21 +0100
Received: from [10.47.82.62] (10.47.82.62) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Sun, 20 Feb
 2022 09:49:20 +0000
Message-ID: <6021a8b4-d114-dedd-5742-98451ff48e8a@huawei.com>
Date:   Sun, 20 Feb 2022 09:49:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v6 23/31] scsi: libsas: Simplify sas_ata_qc_issue()
 detection of NCQ commands
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>
CC:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
 <20220220031810.738362-24-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220220031810.738362-24-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.82.62]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/02/2022 03:18, Damien Le Moal wrote:
> To detect if a command is NCQ, there is no need to test all possible NCQ
> command codes. Instead, use ata_is_ncq() to test the command protocol.
> 
> Signed-off-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>

Reviewed-by: John Garry <john.garry@huawei.com>
