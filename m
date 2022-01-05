Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9E7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 09:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbiAEJHE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 04:07:04 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4334 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiAEJHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 04:07:03 -0500
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JTNlg6bK8z67gSR;
        Wed,  5 Jan 2022 17:02:07 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 10:07:00 +0100
Received: from [10.47.27.56] (10.47.27.56) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Wed, 5 Jan
 2022 09:06:59 +0000
Subject: Re: [PATCH] scsi: hisi_sas: Remove unused variable and check in
 hisi_sas_send_ata_reset_each_phy()
To:     chenxiang <chenxiang66@hisilicon.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <nathan@kernel.org>, <colin.i.king@gmail.com>
References: <1641300126-53574-1-git-send-email-chenxiang66@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <134547e6-1212-266c-5cd6-41b4b83272e0@huawei.com>
Date:   Wed, 5 Jan 2022 09:06:48 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1641300126-53574-1-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.27.56]
X-ClientProxiedBy: lhreml736-chm.china.huawei.com (10.201.108.87) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/01/2022 12:42, chenxiang wrote:
> From: Xiang Chen<chenxiang66@hisilicon.com>
> 
> In commit 29e2bac87421 ("scsi: hisi_sas: Fix some issues related to
> asd_sas_port->phy_list"), we use asd_sas_port->phy_mask instead of
> accessing asd_sas_port->phy_list, and it is enough to use
> asd_sas_port->phy_mask to check the state of phy, so remove the unused
> check and variable.
> 
> Fixes: 29e2bac87421 ("scsi: hisi_sas: Fix some issues related to asd_sas_port->phy_list")
> Reported-by: Nathan Chancellor<nathan@kernel.org>
> Reported-by: Colin King<colin.i.king@gmail.com>
> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>

Acked-by: John Garry <john.garry@huawei.com>
