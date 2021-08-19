Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B3AC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 18:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1601C60E76
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 18:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhHSSek (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 14:34:40 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:55085 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhHSSej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 14:34:39 -0400
Received: by mail-pj1-f54.google.com with SMTP id n5so5552878pjt.4
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 11:34:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7fIHY5B/+rsc1+dLbZ03GZJUCbAlipidTIplr27BP7w=;
        b=Nnc668ubLPBKiO2UsrrBIYBzXZXIcB6bqzww7XUN24enL7iUhaVW+MxqR0hq7ASXAn
         Nox6firTeSY1i3F/0C9zzeiag/XmCOza0xb3cXr5w7qJ+Kgh4qKs9YASMLB9o9/hhmz5
         ONE0llI3kth8aBhCVjXAKCbbOg+KVtUAHptVcynYkiC5TwKMIem7yRr5Fohap1w+PmWy
         E6QuAhNoOEZnR5q1Z3SV15UPXBNnnNSNT1Sb04a1B92Qxxjg5SJREIdh/ukjZ4JWX5bm
         +IOU3CfFv9EamI8j+ed+3LgU7QOI3Z6JmvqVGB0gm0UzKtrhgscs/2C0soq5JirumqGc
         KVkg==
X-Gm-Message-State: AOAM5328pMkmhPAJ0BFeocFGqNOfqTJBjPKX3kVYNKo+iyjRWjZsi5KM
        VwgFEPdYmyFJetPYdB6qcyYyUrfUDqg=
X-Google-Smtp-Source: ABdhPJxRkClOBpESZmM0EAy9feSLPXwspBXBH8yZz8lVwr4f7/bcoBQWTs5CXRHgJOUtaEMBApJJHQ==
X-Received: by 2002:a17:90a:de04:: with SMTP id m4mr79229pjv.187.1629398042574;
        Thu, 19 Aug 2021 11:34:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8b47:c5d7:9562:9d96])
        by smtp.gmail.com with ESMTPSA id n32sm4337184pgl.69.2021.08.19.11.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 11:34:01 -0700 (PDT)
Subject: Re: [PATCH 10/51] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-11-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d8a0bb5d-6cd4-4400-dd98-f6db59163c9d@acm.org>
Date:   Thu, 19 Aug 2021 11:34:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817091456.73342-11-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/21 2:14 AM, Hannes Reinecke wrote:
> Issuing a host reset should not rely on any commands.
> So use Scsi_Host as argument for eh_host_reset_handler.

Thank you for having done this work!

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
