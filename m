Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD82C6FD20
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 19:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjCXTqi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjCXTqh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 15:46:37 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB4E6191;
        Fri, 24 Mar 2023 12:46:37 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id z19so2833662plo.2;
        Fri, 24 Mar 2023 12:46:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679687196;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4rtTUuCCRIIQVv6MF/hcet5LN6DayoTxhlaNVOhUyvs=;
        b=4IbptEsQGB4DBFPf0wjUgt4zPXW5+kHNcTj69PgkPM9ErIA3/qxWydiQ57kZeZK7Hs
         xY7slNPOo23cX3Wluwtzjk2B+hkjGk4ng4BfBt2fKW6heL6RQWx/WGheuxERWlC747L4
         ifFkDmYpMp3nb5fUO/NZDSj/DabtqbSiUOrf7kzfo1XcMcSIJYuD21HfGnTnxI516CJp
         hR5iuxKD8ltXtPmh77c1D4UcKWYh/JDwBdflCqIDALXIfzVpQoJa6yV8IzPgjJJXGXBf
         8WGTbyG9LsKdtBC+fedGpcoPiQATOMO56cJloy9s9zaa81hGdprqshNOyxh4ZSIiNSpz
         niBQ==
X-Gm-Message-State: AAQBX9f6W+buReoZ7av5rPwCGjKn+JCj+Ib4eJ220rSwSLYUkTc8oLcS
        qNsroDMEGCpwfbEF3Ql14YE=
X-Google-Smtp-Source: AKy350bgGq1w2lPDZ+6ZO4UHtm4oCoBNhrnJso4ApZVq060T+JXgY5FqVxTJVceo/xOu2MYuXwm1OQ==
X-Received: by 2002:a17:903:1108:b0:1a1:e867:f2a7 with SMTP id n8-20020a170903110800b001a1e867f2a7mr4823486plh.22.1679687196486;
        Fri, 24 Mar 2023 12:46:36 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:386d:2249:7df8:ecf? ([2620:15c:211:201:386d:2249:7df8:ecf])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902b70200b0019e31e5f7f9sm14639920pls.71.2023.03.24.12.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 12:46:36 -0700 (PDT)
Message-ID: <96910cb2-2a87-420e-1ff5-7427c2971318@acm.org>
Date:   Fri, 24 Mar 2023 12:46:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 03/18] scsi: Rename sd_pr_command
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-4-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230324181741.13908-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/24/23 11:17, Mike Christie wrote:
> Rename sd_pr_command to sd_pr_out_command to match a
> sd_pr_in_command helper added in the next patches.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

