Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533DBC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 08:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CB936103D
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 08:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhJRIEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 04:04:30 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3992 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhJRIEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 04:04:20 -0400
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HXq4852vmz67gR6;
        Mon, 18 Oct 2021 15:58:00 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 10:01:01 +0200
Received: from [10.47.85.98] (10.47.85.98) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 18 Oct
 2021 09:01:01 +0100
Subject: Re: [PATCH] scsi_transport_sas: Add 22.5 link rate definitions
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC:     <sathya.prakash@broadcom.com>
References: <20211018070611.26428-1-sreekanth.reddy@broadcom.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <175c1273-8d03-4f50-966c-37a67d9428ff@huawei.com>
Date:   Mon, 18 Oct 2021 09:03:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211018070611.26428-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.85.98]
X-ClientProxiedBy: lhreml718-chm.china.huawei.com (10.201.108.69) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/10/2021 08:06, Sreekanth Reddy wrote:
> Adding 22.5GBPS link rate definitions,
> which are needed for mpi3mr driver.
> 
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
>   drivers/scsi/scsi_transport_sas.c | 1 +
>   include/scsi/scsi_transport_sas.h | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 4a96fb05731d..4ee578b181da 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -154,6 +154,7 @@ static struct {
>   	{ SAS_LINK_RATE_3_0_GBPS,	"3.0 Gbit" },
>   	{ SAS_LINK_RATE_6_0_GBPS,	"6.0 Gbit" },
>   	{ SAS_LINK_RATE_12_0_GBPS,	"12.0 Gbit" },
> +	{ SAS_LINK_RATE_22_5_GBPS,	"22.5 Gbit" },
>   };
>   sas_bitfield_name_search(linkspeed, sas_linkspeed_names)
>   sas_bitfield_name_set(linkspeed, sas_linkspeed_names)
> diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
> index 05ec927a3c72..0e75b9277c8c 100644
> --- a/include/scsi/scsi_transport_sas.h
> +++ b/include/scsi/scsi_transport_sas.h
> @@ -41,6 +41,7 @@ enum sas_linkrate {
>   	SAS_LINK_RATE_G2 = SAS_LINK_RATE_3_0_GBPS,
>   	SAS_LINK_RATE_6_0_GBPS = 10,
>   	SAS_LINK_RATE_12_0_GBPS = 11,
> +	SAS_LINK_RATE_22_5_GBPS = 12,

I don't have the T10 spec to check this value, but assume it's correct

>   	/* These are virtual to the transport class and may never
>   	 * be signalled normally since the standard defined field
>   	 * is only 4 bits */
> 

Reviewed-by: John Garry <john.garry@huawei.com>

