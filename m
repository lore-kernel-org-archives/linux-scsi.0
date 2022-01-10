Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3BAC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 16:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbiAJQgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 11:36:10 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4378 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237564AbiAJQgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jan 2022 11:36:10 -0500
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JXfX45CW0z68BWh;
        Tue, 11 Jan 2022 00:33:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 17:36:07 +0100
Received: from [10.47.24.251] (10.47.24.251) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 10 Jan
 2022 16:36:07 +0000
Subject: Re: [bug report] scsi: hisi_sas: Fix some issues related to
 asd_sas_port->phy_list
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        <chenxiang66@hisilicon.com>
CC:     <linux-scsi@vger.kernel.org>
References: <20220110125428.GA5230@kili>
From:   John Garry <john.garry@huawei.com>
Message-ID: <eca7784c-2c05-9c8e-e563-610aafbd1b17@huawei.com>
Date:   Mon, 10 Jan 2022 16:35:51 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20220110125428.GA5230@kili>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.24.251]
X-ClientProxiedBy: lhreml743-chm.china.huawei.com (10.201.108.193) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/01/2022 12:54, Dan Carpenter wrote:
> Hello Xiang Chen,
> 
> The patch 29e2bac87421: "scsi: hisi_sas: Fix some issues related to
> asd_sas_port->phy_list" from Dec 20, 2021, leads to the following
> Smatch static checker warning:
> 
> 	drivers/scsi/hisi_sas/hisi_sas_main.c:1536 hisi_sas_send_ata_reset_each_phy()
> 	error: potentially dereferencing uninitialized 'sas_phy'.

Hi Dan,

Thanks for the notice. This should now be fixed on Martin's 5.17 staging 
branch. 
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.17/scsi-staging&id=5d9224fb076e9a2023e0b06d6a164d644612c0c0

Thanks!
