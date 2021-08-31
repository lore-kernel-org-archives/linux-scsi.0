Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42BBC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 15:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3A0B61053
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 15:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbhHaPPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 11:15:20 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:38679 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbhHaPPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2021 11:15:19 -0400
Received: by mail-pl1-f173.google.com with SMTP id u1so7027803plq.5;
        Tue, 31 Aug 2021 08:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9D9qsE+noSqIxlombEWfgmTi8GkmBBFofBmVtpmcEtA=;
        b=itSWzH4ixfOyPM690gG4ccQ/BhSaaoxi67TASyMz9x5YVMbXNg4rSXPANfR1ex1saj
         pS3Mse1CzVBx1FWyJYBux7wRPMfZa8KejAk1A2rX70I7v0Pt+BpQh02J3Pwh0ji1uGf0
         qSnLFCtus+so1769jmx1Usp1wDRq6xCT5fPN5sO7Mx+m4H2e6/FrlgUPD6/8ec74TpxC
         vjTd+KrlDxayEGI63oD8bucTgtfSXC8q8/IMyfIA01dMJI90jE245Lk8BFB1UPrSkxDQ
         YGn+aOymw8O5T4xaCCg9hA6lKowSNgVdarnQsxTm1zWNfcvOCZqS6LkR0Km46iY6d+l9
         H2TQ==
X-Gm-Message-State: AOAM532uuh5pyW8xQB4NWOC12GFA22T8QjWE8YHsTIc0eQXir0Ef4ubn
        nmo9fiYShW6bSCKfcXU0SbE=
X-Google-Smtp-Source: ABdhPJyKXABDfAD4y80t9N4Emqt15ysfSH9n+R7JutmuWmP2w8oVS7MjvXqU3xPfHqC6EoKjin3xqg==
X-Received: by 2002:a17:90a:6b83:: with SMTP id w3mr5890999pjj.114.1630422863841;
        Tue, 31 Aug 2021 08:14:23 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:bf86:9409:8dda:644? ([2601:647:4000:d7:bf86:9409:8dda:644])
        by smtp.gmail.com with UTF8SMTPSA id x10sm2926345pfj.174.2021.08.31.08.14.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 08:14:22 -0700 (PDT)
Message-ID: <634f24b5-c47e-0303-f462-8a63c3453af8@acm.org>
Date:   Tue, 31 Aug 2021 08:14:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH] scsi: ufs: ufshpb: Remove unused parameters
Content-Language: en-US
To:     Chanwoo Lee <cw9316.lee@samsung.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, daejun7.park@samsung.com,
        beanhuo@micron.com, stanley.chu@mediatek.com,
        keosung.park@samsung.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        dh0421.hwang@samsung.com, sh043.lee@samsung.com
References: <CGME20210831071227epcas1p188440324d4e68fb5c5ab506e02ee11e7@epcas1p1.samsung.com>
 <20210831070443.25480-1-cw9316.lee@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20210831070443.25480-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/31/21 00:04, Chanwoo Lee wrote:
> From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
> Remove unused parameters
> * ufshpb_set_hpb_read_to_upiu()
>   -> struct ufshpb_lu *hpb
>   -> u32 lpn

Please use full sentences in the patch description for future patch 
submissions. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
