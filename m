Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88D6C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99B7261241
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhGIUfb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:35:31 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:41684 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhGIUfb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:35:31 -0400
Received: by mail-pg1-f171.google.com with SMTP id s18so11106737pgg.8
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:32:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MiEDSUPqPJkLcoRmnm0SVCNujyB3xWL24/0kv6W90ko=;
        b=Ez76CXtDDsgFScnnVsFA3HYHfubel78LuayRx3KU+8/6CjNCJV9YjEoOe1UDygjFOh
         0qXB8F2/JjrBh4oL0w+mgq339Sh97f0fwXtECHsjLAAhx7SDhuzmY7qp/4alpyJufxfL
         lMYiSonpeN9F8RW1kGs9bvcj9A5/QTa//DXzAXq1z8yUaVZX1VHWO9jE/44ZEJ5FdUKc
         VvZ34kIlpOT8ht51byIVXF0FReS8Nim+Ek6YzgCsbHD7AuHvpSfxeHbDm/UhP078REYe
         7E3P2A9CTODtzBAcBizA/+tFfpsnr/D4+s36mIqNIFX6CswxUy8Hw8xxRZxLdgnqkrXn
         7BVw==
X-Gm-Message-State: AOAM530jDsdbMnCP4QlyuN3BZKrN4S5CqZyFWi3747Dyt5TK8Yj1R9By
        RxymXUw811waEJBLYzZaB+U=
X-Google-Smtp-Source: ABdhPJxUPacFeW6y6LtdWg/hGHTOJkmjG+Zh2jG3hhM2S3SLXL+OvoRf6zy776rq6K5Xml8q3gsJEQ==
X-Received: by 2002:a65:6253:: with SMTP id q19mr18468436pgv.230.1625862766370;
        Fri, 09 Jul 2021 13:32:46 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:eeaf:c266:e6cc:b591? ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id h5sm3219218pfv.145.2021.07.09.13.32.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 13:32:45 -0700 (PDT)
Subject: Re: [PATCH] fault-inject: Declare the second argument of
 setup_fault_attr() const
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <55282a42-952c-a541-4810-ec8b6cc5bc2c@acm.org>
Date:   Fri, 9 Jul 2021 13:32:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/9/21 1:26 PM, Bart Van Assche wrote:
> This patch makes it possible to pass a const char * argument to
> setup_fault_attr() without having to cast away constness.

Please ignore this patch - it has already been posted to the LKML.

Bart.
