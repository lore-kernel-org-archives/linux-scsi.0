Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A563CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6731720650
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfKAQTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:19:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36757 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfKAQTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 12:19:00 -0400
Received: by mail-pf1-f195.google.com with SMTP id v19so7403364pfm.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 09:19:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jkeReOj0jz4Ah95xtmmWo8LRrbzSRBjNNNQBp40QDRk=;
        b=Qsrw5kij1FVSrwJ79HCbc4MIhJascwzEN7ocp+BNosrSj1IijodA8o0D0CAW0b4PYq
         PgalMLjYXgZXWptInh+wlKO44jrCw9wmjOjzvjDJ8Ur5ntyA4YWVknla6zdtYx3za9u1
         yEXpDrRaLfu9pYo+GjXMaWnobUmwi+HqjtsPtkS8ZPwTSsKuiOdUyfvJC7a63M8ZSk1e
         mtMF3nqLrq9gZwpVGATQ0Mbhjx+kBLk30v+7Se9b7WIMdCtOLYNjSaJOqf4tf3LMTFXU
         W1b6gaJEjKlHypYUV91c+Ae+IrINnqSck+cNJn1p7BRPwukPaniv26JxHqMgj+b4jcaG
         iBiw==
X-Gm-Message-State: APjAAAWXB7DMlNux9Iz793Fvp6Ep7bjTzBwKZOOsTRLMMIG9cnNuofh1
        HrJxpxSFj7JcMjfo7DU/0/LZ7bWMI0E=
X-Google-Smtp-Source: APXvYqzP1kTgYlhVilR36ESqzJqxFH0ywYMzcCNhWllChbN1P1640Uiw3P7mFslDY17es8zoRJ0BRw==
X-Received: by 2002:aa7:908b:: with SMTP id i11mr14865678pfa.140.1572625139494;
        Fri, 01 Nov 2019 09:18:59 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id x70sm10072709pfd.132.2019.11.01.09.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 09:18:58 -0700 (PDT)
Subject: Re: [PATCH 04/24] acornscsi: use standard defines
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191031110452.73463-1-hare@suse.de>
 <20191031110452.73463-5-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6cb47b1f-1468-9abe-7da4-a22c2b7c6454@acm.org>
Date:   Fri, 1 Nov 2019 09:18:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031110452.73463-5-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/19 4:04 AM, Hannes Reinecke wrote:
> Use midlayer-defined values and drop the non-existing QUEUE_FULL
> case.
> 
> [ ... ]
>   
> -    case QUEUE_FULL:
> -	/* TODO: target queue is full */
> -	break;

Please clarify in the commit message why it is OK to drop this code.

Thanks,

Bart.


