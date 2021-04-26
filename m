Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C046C43461
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6324161139
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhDZDnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:43:19 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:35379 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhDZDnI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:43:08 -0400
Received: by mail-pg1-f169.google.com with SMTP id q10so39176641pgj.2
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QsAwYO0XZmkYLjnjtWr++SjnbodNg/aUhtcsFdopSdk=;
        b=Awz9cJkFfLOx9xgovD7CHNSLhLiD617rOILhJX9sVyA5IVEj5ym1L++p37X+6Nsk3U
         gTgt5LkvfAUqCd/lC2KGF5GfxDGJxHo9IDNF3pW7rnQQdOCeIACtjnt/G80IgX2sP/0j
         DgBsQB2Nh5YxqI/UBBWVFrE0cMZB9+5QsSjwWrQ356hlfAgjmIqx6+ek4jAORuyU0PxV
         VnHvUMQn3GFynWR7E6YG8//9o5iOIC2iNkr8kVWvxzFVRjWbiUCegV6e4P0XNDyz3OZQ
         +vlfiJOEwt+8h6rJOSSLliqtnukjSzvrOpDzcVuUjAxrEwzcczuMSHWhC5OTM8O6i1Gv
         NklQ==
X-Gm-Message-State: AOAM533wHP8zj9HPn/lcvDQA6sne2sbkUdW1ZOqYWVULU0x1yKaK5V+j
        sLbW3zRjrbRex4wtHz/eJBwsKe3/l4084w==
X-Google-Smtp-Source: ABdhPJybgM8SPWvPaqKC96bAo356PR0EJ11wvZ+ufZFHpTDTpL0WbrZIzEm91GsKJAYyUc0W7w46Cg==
X-Received: by 2002:a63:190b:: with SMTP id z11mr14729845pgl.314.1619408547423;
        Sun, 25 Apr 2021 20:42:27 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w134sm10416375pfd.173.2021.04.25.20.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:42:26 -0700 (PDT)
Subject: Re: [PATCH 10/39] scsi_error: use DID_TIME_OUT instead of
 DRIVER_TIMEOUT
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-11-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4b084082-f50d-c930-ee8d-e02e2cbef4e5@acm.org>
Date:   Sun, 25 Apr 2021 20:42:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-11-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> Set DID_TIME_OUT instead of DRIVER_TIMEOUT when a command
> is finally marked as failed after error recovery.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
