Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D442CC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 16 May 2021 18:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6E2D61073
	for <linux-scsi@archiver.kernel.org>; Sun, 16 May 2021 18:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhEPSMQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 May 2021 14:12:16 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:35707 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhEPSMP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 May 2021 14:12:15 -0400
Received: by mail-pf1-f180.google.com with SMTP id g18so1792825pfr.2
        for <linux-scsi@vger.kernel.org>; Sun, 16 May 2021 11:11:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vehOYiIyNiBdN5lh87aO1pVeRo7MaGFEnaPqPkrbsSU=;
        b=lXXqTdFVYZdEnCm+JZwn8FjyXNoXr+aE7wShTg02JP1NqRDsVYJl6IKjIg0EXWO9Hw
         WjgP5jsKZS/X65mooBmX6UwAgq87tDHd7KIV+C2CVCoT2JIQvQ3mw0yu1JVRmICiJM3h
         A7zwms3lAwBq8Sz1B3iF49gP28WnbRw3Yx62Th5ou6C0yT+jTnByFI1RDvqSA+9nRzue
         vRGC8dKvW+ekspHy+67/CimdlrSxS6c+cKBKb0VnWiw22r7yynXeCIdLxJ0q3AIKzEh7
         1XPGnq9sQZn4BM4L2Nl9JI22PFfZkdyF09ztO+swLbFCTQ1+WDNAi7e03pKBEqE1idgW
         i+Ig==
X-Gm-Message-State: AOAM530E1iOBLizzxmkMPU8yJuDkjceV4XtQT50OKXbsbLi/mBOnzeLq
        nDs5FDu36l+w53qAw1eNAIs=
X-Google-Smtp-Source: ABdhPJwKzQAaiyyU9cPOTL4uYQ8JYcCqWmUccCkO8kt9nk98HPocNfAMqXs1s91dsyYVsCMDKC2ndw==
X-Received: by 2002:a62:8092:0:b029:2cb:cf3b:d1a3 with SMTP id j140-20020a6280920000b02902cbcf3bd1a3mr26678076pfd.26.1621188660286;
        Sun, 16 May 2021 11:11:00 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:31d9:ad96:de9b:b213? ([2601:647:4000:d7:31d9:ad96:de9b:b213])
        by smtp.gmail.com with ESMTPSA id ch24sm1937073pjb.18.2021.05.16.11.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 May 2021 11:10:59 -0700 (PDT)
Subject: Re: [PATCH] ufs-exynos: Move definitions from .h to .c
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'James E . J . Bottomley'" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, 'Christoph Hellwig' <hch@lst.de>,
        'Kiwoong Kim' <kwmad.kim@samsung.com>
References: <CGME20210509213827epcas5p173b48dab49036c8d85eadfc8bda9efd8@epcas5p1.samsung.com>
 <20210509213817.4348-1-bvanassche@acm.org>
 <21f801d749f8$efd9e2b0$cf8da810$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <af3e9b57-70b4-9a84-eff7-3a3eda1d50db@acm.org>
Date:   Sun, 16 May 2021 11:10:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <21f801d749f8$efd9e2b0$cf8da810$@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/15/21 7:12 PM, Alim Akhtar wrote:
> Just for the subject tag consistency, can add subsystem name , scsi: ufs:
> <driver_name> 
> Rest looks good.
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

Martin Petersen, the SCSI maintainer will add the "scsi: " prefix to the
subject before applying this patch. So you want me to change the subject
prefix from "ufs-exynos: " into "ufs: ufs-exynos: "?

Anyway, thanks for the review.

Bart.
