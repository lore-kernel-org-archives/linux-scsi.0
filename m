Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19813C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjE2U1V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjE2U1U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:27:20 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5C3B7;
        Mon, 29 May 2023 13:27:19 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-256832ee24aso849786a91.0;
        Mon, 29 May 2023 13:27:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685392039; x=1687984039;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ta8eeQVmNHIA73QwvIWQwgms5NVmEHdBIhCFYMN/ltI=;
        b=D3r8VqrZdvcEQyu3qjzOZG0x1mFPQlntlMdoO4ku/g6gEFqR6FLe5iDeW0ljg/tS33
         JLOJf1ZemfJls9CVSZwcnowdYOkb3YIDwB7rKLO4m/iBqqRGESC2AeoX90bpWVbtjsMe
         o9dnplJeOj/iLgtj3eab1MUXgdXMc1JS0SoQtsktIDVfpStbbjX+qSbBfs6m7Sk3gdyt
         y05zeQwFeNGHgiR28X/ClOcZkkwYSvvtzOL3BztxZBkIa86BkL/dhy6lAkJjnJiBwbR0
         y58iGUd/kgFfu3kHw/m4t7ofZmRP0mkGoqF9bahsi1UVNcBmF8BiaMT62owdMbNDps9L
         fALQ==
X-Gm-Message-State: AC+VfDxnNnOaTVJGn07QQmjYrunSXoPjScoe5uA/O9yam5vMupsNLiY9
        BjdRnlv73EsNdq7z3N9JeBA=
X-Google-Smtp-Source: ACHHUZ5pL8rxk2MUSTmst8N1i9gOLuwOdWfu8iKNvMkS6cJNNGFNJfD+z+ZcJGoNrAZl20rsj3oZEg==
X-Received: by 2002:a17:90b:87:b0:253:62c2:4e1b with SMTP id bb7-20020a17090b008700b0025362c24e1bmr131128pjb.48.1685392039238;
        Mon, 29 May 2023 13:27:19 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090a784b00b00250bf8495b3sm9105863pjl.39.2023.05.29.13.27.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 13:27:18 -0700 (PDT)
Message-ID: <743ee7a6-e239-7ce0-de2c-091907c6932b@acm.org>
Date:   Mon, 29 May 2023 13:27:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] scsi: stex: Fix gcc 13 warnings
Content-Language: en-US
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230529202157.11361-1-bvanassche@acm.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230529202157.11361-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/29/23 13:21, Bart Van Assche wrote:
> gcc 13 may assign another type to enumeration constants than gcc 12. Split
> the large enum at the top of source file stex.c such that the type of the
> constants used in time expressions is changed back to the same type chosen
> by gcc 12. This patch suppresses compiler warnings like this one:

Please ignore this email and the replies to this email since it includes
two different patch series.

Thanks,

Bart.

