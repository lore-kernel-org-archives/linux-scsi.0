Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAD6CA9ECF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2917120848
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbfKDRtS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:49:18 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35085 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDRtS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:49:18 -0500
Received: by mail-pg1-f195.google.com with SMTP id q22so4196810pgk.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:49:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W4M48syZy3IOG6k9Wnu8Z92P0trNI+sdDvtZ8y97oLE=;
        b=hBIE8m6izGP9kGpn6Zz79rDrKjps4b/qCiUealzFs6CCJeRsjqqQcZFoULBIaMNN+t
         P5UyXIADo/WN1qXnPviUv8+cPg050bXflrTnFKf42K22Zq4ka4ajYaTMYU8uAOwQBbdt
         leGeFA384Tq1cniiQZhi756huzgKnBlnbZVrMFUm7aKzaSvPgenIJ0T2j9SBTtMVZUw0
         C2ZyNzT6tmwnhPrYxF07LyuHshGLRRtHtA6id5PWH5A2eWSgYe7uHYXJXF1PhR8k4/e9
         HPnpDNgizedE6QK8ebTQnHE0C+RozZI1OCtUrWm00rZ6XXyrmFljIBB4aNkfyWuhjiqY
         Qy0Q==
X-Gm-Message-State: APjAAAV93Xj15cqv8P9pcru+FRr8XpiMDouiWoGeTxKToh+o7Q4mgaQX
        x+KXB8bIz2AtaJk/7eHFoEQQq5Sr
X-Google-Smtp-Source: APXvYqzPU/HPaXnwCyMCQAEJzNvgDNs5pNqj4LwZDPCPCZEzMau5BRBpKGg+6DwK4ILFoTjAGZ9jgg==
X-Received: by 2002:a63:1f57:: with SMTP id q23mr31140636pgm.391.1572889757398;
        Mon, 04 Nov 2019 09:49:17 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c13sm5980279pfi.0.2019.11.04.09.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:49:16 -0800 (PST)
Subject: Re: [PATCH 28/52] 3w-xxxx: use scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-29-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <68bfe205-f061-c64c-6205-2f89887719ab@acm.org>
Date:   Mon, 4 Nov 2019 09:49:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-29-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use scsi_build_sense() to format the sense code.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

