Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D557C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D34961152
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhDZDnR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:43:17 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:41961 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhDZDnB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:43:01 -0400
Received: by mail-pl1-f178.google.com with SMTP id e2so23874593plh.8
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:42:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9OJZQx2v8us15KqmPBq8LiL+sr4WoO5Fis6eeXBq4+E=;
        b=bmLjYfBIkddo/MvHpo8OKJRR6eyo9tuD81fwA949ioqf5VN6eiIZcsvI+27RJa+W3o
         HEHGLzjNey4HT61nRIIhlN1A0HuJbl2bj2D0Y3zKtBf/8Uo9F0tRVOkmLcyf16uPe4PH
         xz3+ys9GJ75u4SWYRYnu31SPyFgz+LyRDnh3cjfkDqd9tS2K+ESyG29xRkZRr/aGH7qw
         x0PxvOUepduNEw5lWUKBU0NrjyYqlEzECCsXIi1HFhuCjsmbVqR3tJbXKWd413VcV3iG
         cdeqzbKVa9jWtRCyqHbG3JJ1SCEoqr4ruwO4BEjsmdRJKV75rixH5iNZDph0XUkNx69n
         LA5Q==
X-Gm-Message-State: AOAM533IlYmeVSsjHyxWg6gdp6r1aq4OXThTr4Hh14OjTz/OOAsdezTp
        lymi3S2DAZ6lg8rMnJRsGUKQ8z/GqhYSqg==
X-Google-Smtp-Source: ABdhPJxL9KUOuMFHolxnrJn1TWYrsVGKIKOcMpn9mv+fB11f1MM7J6vf5jQs9B+040yV+ivUZ4N2Uw==
X-Received: by 2002:a17:90b:1b4a:: with SMTP id nv10mr17836422pjb.153.1619408525993;
        Sun, 25 Apr 2021 20:42:05 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b20sm13009026pju.17.2021.04.25.20.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:42:05 -0700 (PDT)
Subject: Re: [PATCH 09/39] scsi: do not use DRIVER_INVALID
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-10-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <42f91848-b08a-0ffa-55e9-8adf592febda@acm.org>
Date:   Sun, 25 Apr 2021 20:42:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-10-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> There is no point in returning DID_ABORT together with DRIVER_INVALID,
> as the caller couldn't care less where the abort originated.
> So drop the use of DRIVER_INVALID.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
