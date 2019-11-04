Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259CDCA9ECF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 012AF20869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfKDRh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:37:27 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45785 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbfKDRh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:37:27 -0500
Received: by mail-pg1-f193.google.com with SMTP id w11so1432827pga.12
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:37:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dph0Raqdsf//+GDu2MAr+c+IolWVXOaz7N10yfWb6g=;
        b=BARlSGzucSMvsu9bYRlKqao8TzEBGhF88YjnWL0+YXNE0iAq8e6IopjI1fdr6SptHJ
         brMjAzXy7N7pBn+4SlvKFDciB3ERilHZXwlBxva7rbU1AL0VsfWCxPh1/Y5WmBMURlz+
         pPjMJJjVPpWHWlXpgGYwTmWyY4ygx9LjxqRZcw93xOcrtTo4KIZGkSU5FETaZ8LDwWXj
         LqNH1kdqEp0HC9GRV/08+GdNkSKx3/XHYJPrFSlo5ctw6sgQMs7G1DU8jE7qHIBSAnZQ
         C4mMThP8Ac7LjlyobohHeMGKmE1OiZ2jg6uKjoStPmy6Jt0IXhxDn+Ubw6bTQPeIQ5Lf
         9y2A==
X-Gm-Message-State: APjAAAVq3e280g4WHx0Q9mipNJ88nS8mc3QPNQExM50i7muM9L9+jwrt
        nxtTGGcKTO7Z/4XpyEZfEEBxApYy
X-Google-Smtp-Source: APXvYqwYeITsFMULgclvs+gpIGlpOBcNAuYDOPO9BGN8FAQcZ7njxW8/+wa7ub459CgXTKCJa8xSFA==
X-Received: by 2002:a63:4c57:: with SMTP id m23mr32442027pgl.207.1572889046189;
        Mon, 04 Nov 2019 09:37:26 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z62sm21332888pfz.135.2019.11.04.09.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:37:25 -0800 (PST)
Subject: Re: [PATCH 08/52] arcmsr: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-9-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fcbcc9a5-788a-ef96-a2b9-2b6b64721102@acm.org>
Date:   Mon, 4 Nov 2019 09:37:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-9-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use standard SAM status codes and omit the explicit shift to convert
> from linux-specific ones.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
