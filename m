Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BD7CA9ECF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10A6620869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbfKDRhI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:37:08 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42759 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDRhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:37:08 -0500
Received: by mail-pf1-f193.google.com with SMTP id s5so4477343pfh.9
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:37:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dph0Raqdsf//+GDu2MAr+c+IolWVXOaz7N10yfWb6g=;
        b=lse+3oW5PtgYvsqgM6Q8H8WS9bsvb5N4RF7pHrBeYnf3SlYZy3vI4xrKWqrwE0qYDs
         s19sUniux8eKq43OwZUXAy1sRKyzJDcXkYgDdi1iNsXSozZceHkv4gvzjuTU1Rut37ql
         XEJk7VknaVGxPdTdB7XAYiqB23DxflAwsKfyLZ1Mh9xhPOs7KeujXekynkEPbZtaAW1E
         FBzjD8peh+clxWiXQUH8kJarlwJKp27NrdX4uP58w7lA20s2Jvps1mgiFUQZDrNDf8lM
         +RjXSiZ5wkCq7HZps3QlfrNxL340a3g2o6+k2lzBuB96TkGCVIdV+Z/3HGc0fXprJnvN
         EgdQ==
X-Gm-Message-State: APjAAAWoGABJ70f4NEu7yU4xGG3X13Hh9bZ/B7SmdOq34PhupnvKVpWL
        /iPe075Bb1dIfNpJ/tVWopiQ4Bvg
X-Google-Smtp-Source: APXvYqzasdoW3gx+AfQvilAPFlgxc4xRN8eMeojP0+JRrnKb8NhwO9d0ATMx+tHGYQ7TBL66K7v2KQ==
X-Received: by 2002:a62:6884:: with SMTP id d126mr20438731pfc.109.1572889027343;
        Mon, 04 Nov 2019 09:37:07 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id t13sm16582511pfh.12.2019.11.04.09.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:37:06 -0800 (PST)
Subject: Re: [PATCH 07/52] 3w-xxxx: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-8-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <36165b2d-9a16-d2b3-2221-97515af3576c@acm.org>
Date:   Mon, 4 Nov 2019 09:37:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-8-hare@suse.de>
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
