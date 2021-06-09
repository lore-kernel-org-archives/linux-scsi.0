Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D30C48BCF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 19:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A11FE613D5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 19:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhFIUBk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 16:01:40 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:45590 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhFIUBj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 16:01:39 -0400
Received: by mail-pf1-f180.google.com with SMTP id d16so19340363pfn.12
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 12:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W95e73g7Yif3EgGR7oFsvTA251/6jCYnq1KeqYjLCp4=;
        b=q2IOB2pJ+5V/K82z/Q1eGyZ4VNBUPMJRb1GbTtDLJRGKp0JTJI+NgrUG4ssPqP+VRh
         JAetQ0HPGTRyifcDFyH4DCFfJV7vk4LjIpbHlWG0ADcQreDrStzaoXFq+p/0WX5ANzpa
         8bMTx1AQgqWKxO6nZa9qtWQ6KkaWtlKkWMpaLdC4auxEq1C5yduwTbHmt/9NBN20cWhj
         2gjB6wyvhOgzBhHSU8hGqS3vA+FtvDfhsFfhh7ZW0pS5NaZcwsVSmRInyuxxSc6mQaGo
         MI5kwDyGShatdSEBb8C4bV9NYo5Wu1TL2IePjdCLjydkmjEXoOC7Ajq1rTZvGadfRUHe
         hNfA==
X-Gm-Message-State: AOAM532EzMrSLqaynJwkZv0kFjPTKZo23NkAwfMZCbKt3115ttyVv6d4
        usmQkEz1QHAa89bdIwJvzH+ssJIq7JY=
X-Google-Smtp-Source: ABdhPJzCv6Lo1Tb1d3BVVQnn6BWF5o3a5/YelCp21duXGZMI1QbO8nF0vOovjche69nhs0FkTglpwg==
X-Received: by 2002:a62:a217:0:b029:2ee:48e1:fd92 with SMTP id m23-20020a62a2170000b02902ee48e1fd92mr1097216pff.55.1623268783754;
        Wed, 09 Jun 2021 12:59:43 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g4sm533804pgu.46.2021.06.09.12.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 12:59:43 -0700 (PDT)
Subject: Re: [PATCH 15/15] scsi: ufs: core: Use scsi_get_lba() to get LBA
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-16-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <dabb0ea5-75b9-e996-e385-1f241d025299@acm.org>
Date:   Wed, 9 Jun 2021 12:59:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210609033929.3815-16-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/8/21 8:39 PM, Martin K. Petersen wrote:
> Use the scsi_get_lba() helper instead of a function internal to the
> SCSI disk driver. Remove #include "sd.h".

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
