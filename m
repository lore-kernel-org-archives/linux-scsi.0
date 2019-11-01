Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9BFECA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8ADF21835
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfKAQQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:16:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42283 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfKAQQF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 12:16:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id s23so3398301pgo.9
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 09:16:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BrVKgsb3qS2UsXEQF51uQp3A3b1XmkjmChgjvKoBlAE=;
        b=lYwasDLfrWv7f61IVy1prHGRaN8G1DyqASLPIpi7yelVRbTft3Pdn0w1/mxyTdNWRR
         XBVDHFeCHrpQKB8UlUTilNXrwU7sFxQevO+ns2AVpZkuBfgHBA/R5ZW45n+ZvcXssdEd
         ooCBLdQJnLhzYL8FeHmRjNo+MaGHGbVzxE3XEpMuV5VdLXkorirG9Z+GquG3sVcs0PKM
         j8vrLzhzh1duOWYy7wliVELov1IxC/7zyuHi6utf9JwatUbDUSuycf4ZjzJA9OK8+aLU
         tatOeETAmBcIqFxc2hMn2WR3lmh0kLWBf1qZV+H91xYgMCx0oRPB5dH2OgyYyZt2XN78
         sFcA==
X-Gm-Message-State: APjAAAXSDc2SKS9pGzXLFv7K6u8tADjcfExWKhx++LA644P5UCZ6Bswx
        3MOELMWI8iQ99PqN9oI9BV7mT+RWY70=
X-Google-Smtp-Source: APXvYqxFIsf02Lgt2nqoJk/DF9v8ly8uZwQR93+R8HKYb6WuFtcJh9ljMnIkVNTrUK36Gd8F/jaudQ==
X-Received: by 2002:a63:3203:: with SMTP id y3mr14198367pgy.437.1572624963676;
        Fri, 01 Nov 2019 09:16:03 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id i63sm11561515pgc.31.2019.11.01.09.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 09:16:02 -0700 (PDT)
Subject: Re: [PATCH 03/24] wd33c93: use SCSI status
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191031110452.73463-1-hare@suse.de>
 <20191031110452.73463-4-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5fa3fe08-3c99-fb37-c13b-9a3a7cb8ccd7@acm.org>
Date:   Fri, 1 Nov 2019 09:16:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031110452.73463-4-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/19 4:04 AM, Hannes Reinecke wrote:
> Use standard SCSI status and drop usage of the linux-specific ones.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
