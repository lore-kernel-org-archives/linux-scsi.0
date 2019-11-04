Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1755FCA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3CC620659
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfKDRgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:36:45 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37401 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDRgp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:36:45 -0500
Received: by mail-pg1-f195.google.com with SMTP id z24so7220213pgu.4
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:36:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dph0Raqdsf//+GDu2MAr+c+IolWVXOaz7N10yfWb6g=;
        b=QWzmzJXen177XlIznSu8Xl4aNOYnjyFYPNdbe74andwaivZoL4FsRWA26OQcxA4yJ0
         Pr7kXmErQdJ25DAIAiNX/yrzQCHbDuZJkn0mAICF4f38SXJiOS9QBPXzfSQIqf1n4SQd
         qb0LnBMbPwjI7PhCTyaJmivCclJNKVldsZHt0/b5sX3t05XKiVgTWcuzMQ/KjqTQ4HQk
         It0Li9HaTh0JqZB4hio2NoAP6lgiI1l/G/P0d2bxEPgJvKsIl7k/XjhRTAS9GZPqwXaU
         q3O5ATm2e8nkZPjd4DVbdw5tf2EElujstxpJsbuNSBACu6hmozGxiBUEl5l3TmJhtMWC
         sYJQ==
X-Gm-Message-State: APjAAAUqZjCOd4KYcTDd8t9Upq03l6IvueZtZssDW33mxOlpXr6iRTRe
        fYQ8Z5/90r2wJ/7m6HODjo0NenQk
X-Google-Smtp-Source: APXvYqx0NoIzGeKcKFWoZlRcU88udKbk07Nl5zpum6qcTZ+0b6p+277vClgH2mWEwtOGtiPAi3p0Rw==
X-Received: by 2002:a17:90a:ba17:: with SMTP id s23mr396159pjr.78.1572889004396;
        Mon, 04 Nov 2019 09:36:44 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id y4sm10458381pfn.97.2019.11.04.09.36.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:36:43 -0800 (PST)
Subject: Re: [PATCH 06/52] ib_srp: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-7-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7da658de-d425-e353-081b-8a0cc79e7731@acm.org>
Date:   Mon, 4 Nov 2019 09:36:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-7-hare@suse.de>
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
