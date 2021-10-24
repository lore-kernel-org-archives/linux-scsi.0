Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B654FC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 21:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD5360F70
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 21:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhJXVbo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Oct 2021 17:31:44 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:36689 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhJXVbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Oct 2021 17:31:44 -0400
Received: by mail-pg1-f181.google.com with SMTP id 75so8972774pga.3;
        Sun, 24 Oct 2021 14:29:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ysIjSYmDBZJLxoRd+SuKLJIVsyPJOqyleXYg5fRpYDE=;
        b=4IjAXAEmZtUoNpDcDXzM/j+0CRkZPYS+l4wL/y/mkjBDcMVg3S7iwtyOT7wfRFZtOY
         MKSXa4sMniCspHtJArWCu2U42p1s5FkeAUpp9wXzj+1aB8A5WUsnbFjROUd1pE9VKuyI
         Gf+3cw+3FlAvEf9xruNSaptfaXsfslLj3YvCTFAtBeiun0eq/h7WWZ/4hfW2g4IAZK/7
         UiH7FZ0wqrZ1Of2G1T7IHcpLunURZwSdbt7PgppT5r7/s6itxPmJ3imrwwefVfAYAJ9p
         64QOUVMzu7cqsFjTW8l2dBPEIbBEDJ+LVT/y+gyxd5rncYT+Uj+M4rM761F6R2gIb6fZ
         LnFw==
X-Gm-Message-State: AOAM532NkU0KM751F+SY+8tY/eM7bPhnYTRAFubGQSJGtGwg0yq01ALc
        kBcYvKzZhTCW+ZhWCsfvInc=
X-Google-Smtp-Source: ABdhPJwpAT+ktHbfbc320iprd1fuwoGs2ic9vhtLVHqDu2hecVEbCRPm926IOK6No3GYH1ipL1/8FQ==
X-Received: by 2002:a05:6a00:1a56:b0:44d:23ae:37dd with SMTP id h22-20020a056a001a5600b0044d23ae37ddmr14380020pfv.8.1635110962678;
        Sun, 24 Oct 2021 14:29:22 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:1d23:4f1f:253d:c1e1? ([2601:647:4000:d7:1d23:4f1f:253d:c1e1])
        by smtp.gmail.com with ESMTPSA id i7sm8971752pgk.85.2021.10.24.14.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Oct 2021 14:29:22 -0700 (PDT)
Message-ID: <8578e393-2a25-bc52-65ea-599d071387e9@acm.org>
Date:   Sun, 24 Oct 2021 14:29:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] scsi: ufs: clean up the Kconfig file
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20211024064332.16360-1-rdunlap@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211024064332.16360-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/21 23:43, Randy Dunlap wrote:
> @@ -39,7 +38,7 @@ config SCSI_UFSHCD
>   	select DEVFREQ_GOV_SIMPLE_ONDEMAND
>   	select NLS
>   	help
> -	  This selects the support for UFS devices in Linux, say Y and make
> +	  This selects the support for UFS devices in Linux. Say Y and make

How about changing "This selects the support for UFS devices in Linux"
into "Enables support for UFS devices"? "the" should be left out from a
grammatical point of view and "in Linux" is redundant.

>   	  sure that you know the name of your UFS host adapter (the card
>   	  inside your computer that "speaks" the UFS protocol, also
>   	  called UFS Host Controller), because you will be asked for it.
> @@ -51,7 +50,7 @@ config SCSI_UFSHCD
>   	  (the one containing the directory /) is located on a UFS device.
>   
>   config SCSI_UFSHCD_PCI
> -	tristate "PCI bus based UFS Controller support"
> +	tristate "PCI bus-based UFS Controller support"

Even with this change applied capitalization is inconsistent.

Thanks,

Bart.
