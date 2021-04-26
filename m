Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C88C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C95E611CD
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhDZDss (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:48:48 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:41699 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhDZDss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:48:48 -0400
Received: by mail-pl1-f179.google.com with SMTP id e2so23880391plh.8
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:48:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rNA0m1zyCxOnlgOJtORZBAt1MN54djO0pta3YL9lKtI=;
        b=l7QEeu27qrhft1OPRdWYvjPbOkXOvs2E38ON8bf64yKeKIIGXL+YQLWVkhq+WV2Rd9
         lbVvwm+IAYLHGmHrpp97K0+6vC66aqqRNyyt1Aivym24KaR16ApxsrWWu/jqmnloqrkg
         mZ28F206WWkvUK0+yc90cUhu7M1ApY0cjqhGwwRlDWtxCoVyAKyYaZbpQEL9ukJoWM5x
         G16xqFuXVEf0J+YNGf16mioH4xJmPkVKeMYTuufyOjD+CvN4LrCUmdJXmsUey7IjqBW0
         klMB3lArhQG/rLoE+bO9CdlPpb7xpun4jeTaFKr6D99a9DABxDDedZxIPF6+LQRclJri
         jfTw==
X-Gm-Message-State: AOAM531LFU+jDBSEnIhjM5Mi+AWZXLjuY6QAwyZLjKDGkS4ShFcZSSw/
        +5UZOESi3KKc48jddt2S3c5XDHCdBA9F/g==
X-Google-Smtp-Source: ABdhPJxrioLzn+BZxxWl6Q67RVyaZAu8GcNoP5Euvl4oHVakQGgmKtMatNf02HYAH4t3RYBhaQTMzA==
X-Received: by 2002:a17:90a:d24a:: with SMTP id o10mr5187887pjw.138.1619408885152;
        Sun, 25 Apr 2021 20:48:05 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w75sm10555476pfd.10.2021.04.25.20.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:48:04 -0700 (PDT)
Subject: Re: [PATCH 16/39] scsi: add translate_msg_byte()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-17-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0f3856e0-aed7-3315-feec-89f0d89ce85c@acm.org>
Date:   Sun, 25 Apr 2021 20:48:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-17-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> Add helper to convert message byte into a host byte code.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
