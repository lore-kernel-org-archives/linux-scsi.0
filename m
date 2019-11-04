Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED18CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B742920848
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfKDRqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:46:42 -0500
Received: from mail-pl1-f169.google.com ([209.85.214.169]:40456 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbfKDRqm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:46:42 -0500
Received: by mail-pl1-f169.google.com with SMTP id e3so5790093plt.7
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:46:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OxlwRi5geSvoPI9JL5frR2l2pimPKxBkG41ITce8byw=;
        b=Mr4KJvT/nsc0/x/XGwX0wXTQbpJTBh3IR1NtTzJSydeudmP/xmxYmDe9+v58Zn8gPr
         iLSzsh6d82VfaaSFhl2VulvUB/QO7+sduh8l7sekn/vJ4dCRXHB/fqXJj44Y+PzO1uqU
         arkto9HsS2VB2XTXHpws2L/paFayxsf/fJa05L9KHrgsDAzZ1vIrfm1G6LvCF4g4UkZj
         vUV8sSZ6Od6hL6gvpFbifA0nylw/znwpXnTxqJ3gVqsG8i2K4MIqo83RRnZRk29mha8Y
         KhPlfXD39gIWje7IkoL61h57UjLu1+iDx4pBGHetOHppK3rjJBwrCu2gf8SIWJQ2KFBb
         q1sQ==
X-Gm-Message-State: APjAAAV0tutjx6eHuM0hThDRoo8U2hC3bX9WhXW+gX/mW/msCMNbie8X
        MGr0vI69oFf12TT2MeF3cM/Y6WT4
X-Google-Smtp-Source: APXvYqwNgyaPlknnfIG+ttYRUWbdPhnglqCAaDiiEe2esyp5HNHMedERKxiSDGGgSXOKj/zrODCxmg==
X-Received: by 2002:a17:902:7617:: with SMTP id k23mr27559001pll.307.1572889601033;
        Mon, 04 Nov 2019 09:46:41 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w5sm5431587pfd.31.2019.11.04.09.46.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:46:40 -0800 (PST)
Subject: Re: [PATCH 22/52] scsi: Kill obsolete linux-specific status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-23-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b76b9838-ca70-5c21-9438-d71c7feae7ed@acm.org>
Date:   Mon, 4 Nov 2019 09:46:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-23-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> After several years it's time to finally kill them.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

