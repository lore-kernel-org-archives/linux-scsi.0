Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8575CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C66FD20869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfKDRkY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:40:24 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44741 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDRkY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:40:24 -0500
Received: by mail-pl1-f193.google.com with SMTP id q16so7889173pll.11
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:40:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dph0Raqdsf//+GDu2MAr+c+IolWVXOaz7N10yfWb6g=;
        b=QxagWfNkf8MXgxS1iqcgkPiNh2H5xYwZdp3s/3hyx6bVCkO9p4kNthhCtJjJl9NcSr
         5mnE4T+OW/Q/n/Sy0J/KwtvZ1458cATqvqmwN1riVWvNc1bKrwlNodGPQ/44Jxat+z8V
         Px8PKt/6etgSQh78qIaf3aBs60KzYHLUy9gmI8KX7GfDWVAZ/vjUfvbm5LuUo+vXudFr
         Ds63VCqHg/xh9BuV6hVmFhEGP6I9H4UFXwazN3iBHmCz3kTvs/QAvsOSDe3ZTzK2Tpy0
         KUgy70yTR5sPgVB1fnIL82v8O2Lh6QqI+uHGhqj+dSPxaSDyfD05csdwIDZADTsbKIKq
         iZ5g==
X-Gm-Message-State: APjAAAXriX1Gs2gX2lw1ZK64scECfoKlMUFojZDY+fhbfs7NT/fqrCd4
        kKrB3+h68x9eNeknyjhcfsksrXYB
X-Google-Smtp-Source: APXvYqwB4R1VNVkicP2aoISBkTNuakFDCQArTC5i2vRrTHi4ZCCvspxwqq+q/LwbYfpdYRGL1z2C1A==
X-Received: by 2002:a17:902:8d98:: with SMTP id v24mr28478846plo.265.1572889222736;
        Mon, 04 Nov 2019 09:40:22 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id j22sm14945494pff.42.2019.11.04.09.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:40:22 -0800 (PST)
Subject: Re: [PATCH 12/52] gdth: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-13-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a1bb5aef-f25f-3ba7-4943-f75d844e4a96@acm.org>
Date:   Mon, 4 Nov 2019 09:40:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-13-hare@suse.de>
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
