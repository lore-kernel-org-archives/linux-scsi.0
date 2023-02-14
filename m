Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE065C05027
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 18:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjBNSoB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 13:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjBNSoA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 13:44:00 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CB725B98;
        Tue, 14 Feb 2023 10:43:52 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id e17so9089739plg.12;
        Tue, 14 Feb 2023 10:43:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vipa2lJ5FT7JsHiDDZpGRZNIifAiXJtbYAtHZhQihSw=;
        b=6xxHqDqMX5DX7UPVxa/HqCCRQ+k7mr8R7yH9X1ybF44p04Km/5Ry6LEXSWY1qdWsbF
         RsjpBkG1UtizLe01nOkeEWlDdbXzsW26VrwIbe+O+STD2HE/8tSQhMulkqf8DjW90mI5
         e0ExSjM1wI78KNCX9QkX69fUIjTmzJB8HFEH4b+QWwuISSGz9b8xaV4Vqv6u98XLaiCV
         tvNfFVwJ87DkDrndBquJSzvSlLgKNS6idU84ERKTy7a+vvZCAIHiLlgcDwFVz5dsdsbS
         iewjdRBKlB2oTMniknFOYIA1HjnDmMFznLeurS32YY3l0Qx6n2u5uVdUBG8BuJRGvyds
         rZug==
X-Gm-Message-State: AO0yUKXNGTHeCfK/YqxPfB5776YnTnR7lTkjcR+Z+5Jz7ZisFW1nhJMT
        Tscm7vzcelBxOm48LEMx5aYAJuG9KG8=
X-Google-Smtp-Source: AK7set8I5Edv9zXPABxlpNhkDJUw47owri0Uzj636u60oH5e0qN99rPmX/VE5dj9mF41tt9dUYeV8w==
X-Received: by 2002:a17:90b:1b09:b0:233:d3ac:5dc2 with SMTP id nu9-20020a17090b1b0900b00233d3ac5dc2mr3591827pjb.18.1676400232022;
        Tue, 14 Feb 2023 10:43:52 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:bba:95f6:e675:40bc? ([2620:15c:211:201:bba:95f6:e675:40bc])
        by smtp.gmail.com with ESMTPSA id gt1-20020a17090af2c100b00233c727510csm6036780pjb.40.2023.02.14.10.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 10:43:51 -0800 (PST)
Message-ID: <f4079ecb-f483-34f9-0074-b77a9bd36cb6@acm.org>
Date:   Tue, 14 Feb 2023 10:43:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [bug report] WARNING at fs/proc/generic.c:376
 proc_register+0x131/0x1c0 observed with blktests scsi
Content-Language: en-US
To:     Yi Zhang <yi.zhang@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
References: <CAHj4cs-jef8f4zxJQxjKirAWyZkTREycFdNPvQaGbgS-1r_Lcg@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAHj4cs-jef8f4zxJQxjKirAWyZkTREycFdNPvQaGbgS-1r_Lcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/5/23 23:30, Yi Zhang wrote:
> blktests scsi/ failed on the latest linux-block/for-next, pls help
> check it, thanks.

Please help with testing and/or reviewing the candidate fix that I 
posted 
(https://lore.kernel.org/linux-scsi/20230210205200.36973-1-bvanassche@acm.org/).

Thanks,

Bart.

