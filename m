Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39013CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 15:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1382A20656
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 15:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfKAP2Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 11:28:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45403 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfKAP2Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 11:28:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id r1so6680952pgj.12
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 08:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q7kWBpOlJ1UDJbzwrLke+k2urAFg6xV3cf81FWxWsCI=;
        b=VAyAS6JfW/CYo8tUQOPP1UasEAQjBTi8L2fPEZyO+9NuKHVszPshyAgmuCW5watsZQ
         F8H1AXmlyftNMn05OnasFtU2LiPmobt+CU0PHA9qAHseg1N6oYaKJLXj1ZHNuTUY1Qv/
         xpt/C//0S/cVJV99Fw7sIxRV9aahj5S6fLWfgNHRTRs/r0O76AoAC70kFdcCuztvR1ef
         3usDOn7TxMu8QlEk7EgyyT+aytDDqtQXzae26v7xs1bnd0AjIv54SBvUb48B6p2Vs+pi
         vWMRf40cxOMNOJ95w2xpOtfQFlqG4n9rRujp0U8JHEODrZohGYkqDUZIpXcbNqt9YPxv
         vkJA==
X-Gm-Message-State: APjAAAVvi1zSDNiyCU6q23iDiU3pP755Llm6eCnOwm0rpeFP8riN+BOE
        mK6phP7PoQHJwa06tO/+3tbPdOOr
X-Google-Smtp-Source: APXvYqwKQNeqDYR2nDD7pGY64FEN4ongPlj/SYIsZ6twpV8wrBp/bwj4r7ZyqDUniTqnfRwaT89Q6A==
X-Received: by 2002:aa7:9482:: with SMTP id z2mr13901521pfk.98.1572622102899;
        Fri, 01 Nov 2019 08:28:22 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id f185sm7921082pfb.183.2019.11.01.08.28.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 08:28:22 -0700 (PDT)
Subject: Re: [PATCH 4/4] scsi: Remove cmd_list functionality
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191101111838.140027-1-hare@suse.de>
 <20191101111838.140027-5-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <54aca76d-a2dd-5dfb-6118-b576e329f8a6@acm.org>
Date:   Fri, 1 Nov 2019 08:28:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191101111838.140027-5-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/19 4:18 AM, Hannes Reinecke wrote:
> Remove cmd_list functionality; no users left.
> With that the scsi_put_command() becomes empty,
> so remove that one, too.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
