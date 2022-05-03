Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1DCC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 16:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbiECQNF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 12:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239049AbiECQNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 12:13:01 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9903204F
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 09:09:28 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id p6so15745044pjm.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 May 2022 09:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VcBhKSgWBYb/aXivVYSamFjkv/D2j4yVy25Gd5vWbUQ=;
        b=bEuzvHXZeYlyKHzN1OSVyEWVJEOa98JJdtr19ltUYfS4yCEm8ImSleRLPylGgmxyQo
         fzkgXsTGq/jwF3n/NHc91Bbaxcwo62RmutEXLPN3KLvwBe5Ha6lucIB0cg7XwBvyvMMt
         +06mhxb2qzzTGJgRx9AvSIQUqgT0UhALDTt8PGkES1KxBn19tHeEqDL1ZFznZba4Nb3m
         9QOGjnJCxqAVrnXhnQFQGSEUPb0icb8iHp0wx4LFBBhRx1Aq5ZT/I2te7XXHXhdVkn12
         3g9KzKGTjOQRyiAnz9KMzZD6Ti1eADZxiYdIjz5aIacK2xItC9hRtS7HeGpPXyU5R2Ca
         RlbA==
X-Gm-Message-State: AOAM532GFHPZxkfujwFb+CNUPfBrfls9eMiDG8f6eUWj2SXVr/lMlz+Y
        E+MozAkqo1+MLMjMKvT9ZbE=
X-Google-Smtp-Source: ABdhPJwOVFAMZePfuJZ+4biDn4yb07r5Y7r1dfLkHNEfSP9NvNjMycxEzVHw9zruF0QE3KzST/dznQ==
X-Received: by 2002:a17:90a:dd46:b0:1b8:8:7303 with SMTP id u6-20020a17090add4600b001b800087303mr5415599pjv.197.1651594168277;
        Tue, 03 May 2022 09:09:28 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
        by smtp.gmail.com with ESMTPSA id q19-20020a170903205300b0015e8d4eb211sm6458933pla.91.2022.05.03.09.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 09:09:27 -0700 (PDT)
Message-ID: <8712654b-ea76-0c80-ab21-09c76fe0dd6e@acm.org>
Date:   Tue, 3 May 2022 09:09:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 01/24] csiostor: use fc_block_rport()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220502213820.3187-2-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 14:37, Hannes Reinecke wrote:
> Use fc_block_rport() instead of fc_block_scsi_eh() as the SCSI command
> will be removed as argument for SCSI EH functions.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
