Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BB4C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 20:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0043D24650
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 20:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="C9ULTBWp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfLRUPL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 15:15:11 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45784 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfLRUPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 15:15:11 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so1829853pgk.12
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 12:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=HD8W6fhAu1mWofyKWkCz1NpTzUclxFawWOIeyvyb7f4=;
        b=C9ULTBWptCUWmD4A0U4YXZGV1wIL4RakCm6UgvCU+1w9CnLOe7Lh/A2xOupd1x7WQP
         AfJnFEHSbOWYZvI9lI5Qexm+/4aQ0XSkPvGrCt4bOdMizuVDYoWv6ewj7gKCj1JFFzAI
         bnG4m9338dqqU5AwfTg6O+FNFnZxpHYDTNSVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HD8W6fhAu1mWofyKWkCz1NpTzUclxFawWOIeyvyb7f4=;
        b=Kd18PQxAR03EUSxZjAD8jDYdfSaEv+1RBKOM2qYkcvjNGkNfxHi70LJvvOOW6ckSN1
         WbTDmJPVyiFpvrKfp0xah4gX+F/jj2ilzngLThgBgyunYDF3NZpRSZQR+BxnKOfoHHPg
         3CavcpUmUXlZBBFx7U3pEKgN3aY0jZJACUovlZkoXhtfQzVbBe9eti8pL8oXXI+1Ax8Z
         es+UzJ+xrVIvJetthFW7WG4A/z2757osA9VGrXMsHAhJx4fYpeeAPqeD2pH2hahgCwos
         bVppR0hJb0weXZVtc4r0t8pUSMdiCN+9o8BS+gfhGrrxDUQjCkGqS4AG1QTPUNrOLVXR
         Gftg==
X-Gm-Message-State: APjAAAVA3eXCjk8mvOCpPtJjyq4ZbVt6mGOwMyEMLSWpMLRBkYWbFxUw
        aGcqdUVqQehguAS4BYl7mql/Ww==
X-Google-Smtp-Source: APXvYqySjaIGnai4aQAxwyqY2JNgSL5HA+f/f2TVbZItNdpctnD8WhUrDSozrX1opco+RPLyQXOI7A==
X-Received: by 2002:aa7:82d5:: with SMTP id f21mr5167907pfn.245.1576700111152;
        Wed, 18 Dec 2019 12:15:11 -0800 (PST)
Received: from [10.230.29.90] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i9sm4449775pfk.24.2019.12.18.12.15.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 12:15:10 -0800 (PST)
Subject: Re: [PATCH] scsi: lpfc: fix spelling mistakes of asynchronous
To:     Colin King <colin.king@canonical.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191218084301.627555-1-colin.king@canonical.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <79579d2d-ea32-e529-6cf4-7a02ff955cfb@broadcom.com>
Date:   Wed, 18 Dec 2019 12:15:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191218084301.627555-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 12/18/2019 12:43 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There are spelling mistakes of asynchronous in a lpfc_printf_log
> message and comments. Fix these.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/lpfc/lpfc_init.c |  2 +-
>   drivers/scsi/lpfc/lpfc_sli.c  | 10 +++++-----
>   2 files changed, 6 insertions(+), 6 deletions(-)
>

Looks good. Thanks Colin.

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james

