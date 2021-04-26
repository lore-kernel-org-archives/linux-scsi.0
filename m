Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73ECC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AE8961360
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhDZDzr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:55:47 -0400
Received: from mail-vs1-f48.google.com ([209.85.217.48]:46702 "EHLO
        mail-vs1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbhDZDzp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:55:45 -0400
Received: by mail-vs1-f48.google.com with SMTP id y22so3634921vsd.13
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3fc+a+tu3htlxcisCqChIGX7WNZpIEf9XEskn82ykvE=;
        b=olsRJUjNGr+9Z8/odTA9rhOINFEJbGFGDAK7j0pph3uWJWmnLSFhDewYX8JjXPdKjo
         R1rmPJLg6V7hQOZ77lyGfSfbTjaB20iQEHZ3CWIDjT/iyWpzsmFbTkmNF1mBmPKUDjbR
         Rcw6hS1W8bRkfAQDEHKRe/RIiYHmPuspP1mc5vE4Z2vAhmPcmYa13mcdU1i6xOu3nOJl
         yyBFH1Yx8gt9uY05VMECb1zpXxcV8jwofrEiqN/POSqMXrwj4O4VpFDA5GP2Rp0bZAtX
         +ZiTL9XAD1L0InreQSgoZ1p7wjd74We77qYHQVDbgz6cAyf6mIyBwMPSoU6eYtHcE9R6
         eV0g==
X-Gm-Message-State: AOAM532hVNEmy4g4ncMPPswAQsKTZKi2+L6sba/7V7MQkcF9NxcvGuJ5
        wY6vdaMgF7rPETKuUDHATCBm2WcZRlQkYw==
X-Google-Smtp-Source: ABdhPJxBYxMPs9KllnSgCuLD3Ft6nH3XxmeIVNmZS21hRe0YEJP6Q7nYsWxh9CJ/xuxAIb9pHGko8w==
X-Received: by 2002:a17:902:9f88:b029:ed:2b48:3a2c with SMTP id g8-20020a1709029f88b02900ed2b483a2cmr3630981plq.45.1619408770591;
        Sun, 25 Apr 2021 20:46:10 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id q5sm9312354pfu.5.2021.04.25.20.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:46:09 -0700 (PDT)
Subject: Re: [PATCH 13/39] scsi: Drop the now obsolete driver_byte definitions
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-14-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <73ff4fe8-4835-7cd2-d7bf-f707fb538107@acm.org>
Date:   Sun, 25 Apr 2021 20:46:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-14-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> The driver_byte field in the result is now unused, so we can drop
> the definitions.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
