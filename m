Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A597C35657
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 17:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D34D206E2
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 17:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CVafjZJf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBURmG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 12:42:06 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37094 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgBURmG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 12:42:06 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so1597459pfn.4
        for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2020 09:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Z0ajQmgxeuIEJg1R79ODn1BBQ+XGOzhA6+1MZaQFdLw=;
        b=CVafjZJfMia4GiT4T6spBIy59aFiEKScjaEtP6tGUJV1gDCFZIHOSr51ooSw/97kKO
         U0wG6HHfV8eOvk0pU0xXMJ/3G8nlCZo//f7fNeXsQTcM9tDuFLvLNXqg3QrVFCNefbyE
         Xr329kobXBeK751Lg7pSt0z+p4yq6/BfxPnmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Z0ajQmgxeuIEJg1R79ODn1BBQ+XGOzhA6+1MZaQFdLw=;
        b=jahWx7r5u4UzNyH5hEBqgGr6y3wuCvW3ZB5PMCtyU2zWdClSLKUcCIyl1b9pwqoBk6
         FaYtrrwh5S31nEOpudUhp6tiv9YhvK/u4DXHOEl6LVHjaDqxD4VQplFFeaXlc/81ovsv
         xfnloCnuGUx80OsoJcDfYYB+xEPkX6gYLu+TOrMtvBKVIMEJV3NzT0d4CmiZ1rijgYCf
         fCnNVi8YIgKDNfPACnd56MRAf/pHpE0Pfqw5+e8QIvVB2hND/OlPpjp4FS2Sjhlmyfsx
         YY4YRh83gF0YAR5HaQnhNzNYSG5bhJ3h6CnrL87vfZLvf3Hwoxh3Ak4IiWYQLDueqebh
         W7gw==
X-Gm-Message-State: APjAAAUeb2Zp4se/HMxPA9jmmAhDzQrjIwym7Lq+2Xh5tSIl53YVx00a
        +ruH2+yXpR5a00rbk/tz+FJfgw==
X-Google-Smtp-Source: APXvYqyHZu3+WU9AU2VLD7KGoNayml0yrujlDGRLPLRP/66aarTY8M79Q50NfYcg+rGmy4Qq53ke3Q==
X-Received: by 2002:a62:f842:: with SMTP id c2mr38901891pfm.104.1582306925501;
        Fri, 21 Feb 2020 09:42:05 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 13sm3400667pfj.68.2020.02.21.09.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:42:04 -0800 (PST)
Subject: Re: [PATCH][next] scsi: lpfc: fix spelling mistake "Notication" ->
 "Notification"
To:     Colin King <colin.king@canonical.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200221154841.77791-1-colin.king@canonical.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <db8a57f5-53e3-08ea-048f-8b5dca08b16e@broadcom.com>
Date:   Fri, 21 Feb 2020 09:42:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200221154841.77791-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2/21/2020 7:48 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in a lpfc_printf_vlog info messgae. Fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index a712f15bc88c..80d1e661b0d4 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -3128,7 +3128,7 @@ lpfc_cmpl_els_disc_cmd(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
>   		for (i = 0; i < ELS_RDF_REG_TAG_CNT &&
>   			    i < be32_to_cpu(prdf->reg_d1.reg_desc.count); i++)
>   			lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> -				 "4677 Fabric RDF Notication Grant Data: "
> +				 "4677 Fabric RDF Notification Grant Data: "
>   				 "0x%08x\n",
>   				 be32_to_cpu(
>   					prdf->reg_d1.desc_tags[i]));

Reviewed-by: James Smart <james.smart@broadcom.com>

Thanks!

-- james

