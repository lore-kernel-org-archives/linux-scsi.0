Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCFBC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Apr 2022 14:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377345AbiD2Odm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Apr 2022 10:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377352AbiD2Odk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2022 10:33:40 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7B4F7F;
        Fri, 29 Apr 2022 07:30:20 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id s14so7292113plk.8;
        Fri, 29 Apr 2022 07:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iZlmV64Xc1hWa8wSScKbyiAr5Rslu8TBnEqFBv07zwg=;
        b=rI03VEi0U7PA2S7ILMgtnmRA6bxBqshPFydGYNMQK+9T1lxa6h4TeUFo2P3k9HI6Cq
         UzcKE94L0Suc9Gl4qI6xHUAhrlePllaa601JxRO6QA3EuhQJVvKQqPSlN30q1+s7T8Ed
         wcwKm6+s6Qppfmk4PfcP5bty9o5ftSWOcnQtLJctS90l5lpPGqixacfxsFtLJdY8Mg93
         D9jJXpJ24W1FrGEJd2V/5nO0yFvBkEN6psU1C6mOlpwXzo0myqTIaotJaL4I9VoAYgzU
         k9YfqrEST1If+OFHvFav7FJc315PiGlhzHqJMmIgDUqWlYCikoSaroKPPdnxcxEeYRLX
         +DQw==
X-Gm-Message-State: AOAM530dRdFYuiL5uGYE8LbMowPkGCesA8sy4uHquBP42Agf8HdKIjlZ
        uyFsMESNJDLosUmLnW83Mqw=
X-Google-Smtp-Source: ABdhPJzTJp2fn8qvZQAtR6g5cDj2ky9bT3FB9Vi/zQEh7h/46+nv9XGS+bRccXwuIwR1ZcJBgpncRQ==
X-Received: by 2002:a17:902:e80e:b0:15d:34d2:4e8c with SMTP id u14-20020a170902e80e00b0015d34d24e8cmr19949517plg.142.1651242620075;
        Fri, 29 Apr 2022 07:30:20 -0700 (PDT)
Received: from [192.168.51.14] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d6-20020a17090ac24600b001d9738fdf2asm14302675pjx.37.2022.04.29.07.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 07:30:19 -0700 (PDT)
Message-ID: <9866c2ab-469f-bc87-8510-05dd9af07a84@acm.org>
Date:   Fri, 29 Apr 2022 07:30:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [Regression] Resume process hangs for 5-6 seconds starting
 sometime in 5.16
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>
References: <81b865bb-be46-cdf7-a49b-fd029de439fb@leemhuis.info>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <81b865bb-be46-cdf7-a49b-fd029de439fb@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/29/22 05:24, Thorsten Leemhuis wrote:
> Bart, I noticed a regression report in bugzilla.kernel.org that afaics
> nobody acted upon since it was reported about a week ago, that's why I
> decided to forward it to the lists and all people that seemed to be
> relevant here. It's caused by a commit of yours. To quote from
> https://bugzilla.kernel.org/show_bug.cgi?id=215880 [ ... ]

Thanks Thorsten for having informed me about this issue. I was not yet 
aware of this issue but will take a look as soon as I can (next week is 
LSF/MM).

Bart.
