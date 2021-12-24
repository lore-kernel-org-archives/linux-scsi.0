Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661B8C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 11:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352624AbhLXL6v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 06:58:51 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4324 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbhLXL6u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Dec 2021 06:58:50 -0500
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JL5B34JLpz67kT0;
        Fri, 24 Dec 2021 19:56:11 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 24 Dec 2021 12:58:42 +0100
Received: from [10.195.32.200] (10.195.32.200) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 24 Dec 2021 11:58:42 +0000
Subject: Re: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
From:   John Garry <john.garry@huawei.com>
To:     Jinpu Wang <jinpu.wang@ionos.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "vishakhavc@google.com" <vishakhavc@google.com>,
        <ipylypiv@google.com>, <Ruksar.devadi@microchip.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
 <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
 <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
Message-ID: <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
Date:   Fri, 24 Dec 2021 11:58:40 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.195.32.200]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/12/2021 09:02, John Garry wrote:
> + some recent contributors
> 
> Hi microchip guys,
> 
> Do you have any idea on the 2x outstanding issues I reported for the 
> pm8001 driver:
> a. my arm system goes into a continuous cycle of SCSI error handling for 
> this scsi host
> b. maxcpus=1 on commandline crashes during bootup on my arm system - I 
> assume that x86 is same also

commit 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues
") looks to cause this issue.

Problem a. still exists prior to this.

Thanks,
John
