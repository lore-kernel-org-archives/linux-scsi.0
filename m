Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086D3C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 16:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAD5B619C0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 16:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhCWQ3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:29:36 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:36462 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhCWQ3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 12:29:09 -0400
Received: by mail-pg1-f169.google.com with SMTP id h25so12246834pgm.3;
        Tue, 23 Mar 2021 09:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zIDd4j28bpLl4CYYPpUQGrIRe9FEAgjqoCPE+GYsmWU=;
        b=qyg4gsVA1mV2EyIdQjm5xy3tNyDwvvqqRZ+u3INXcn+vqAe8HQrG3gBreT4ReQlllt
         9KXdGJhe76jMMxDR7O6hXzvtx6YLPz+pZoEiwiaFCgQwswduTsQp60Fd9Ym4L11tqpBQ
         CkWA6/5/f8kqgA7LaqjzKJkjomMb+6Bi1XyAkM3Zcfv0kRGidlkPJRRIN0V/tZ2VnQEd
         fOkVn11r1//N/lfJFOvdQndvjlxiCfzgtffGarGs9sTjGtocjNUR3aDuWm58d/Rhntq2
         PwSSwcONStnLDFntiCSMhuFGBdswpl6dnobL/iIUF4iDShsfjWc0u+a932cz4q09ppIX
         TCtQ==
X-Gm-Message-State: AOAM532pu4WQPZhv3Nf0/cUk7UytWX02MNNt8yBlBCSSjqI+gsJvaPKC
        GuZGnrzu7pv3tO0n8LpX0svQOA9Kd+s=
X-Google-Smtp-Source: ABdhPJyutH36s8BgKaQwxghjDrkD20vuVw9tt+qF0iq1cR0oP5oaQIJhN/jSd0ddT0BzueXQtqBAVQ==
X-Received: by 2002:a63:e416:: with SMTP id a22mr4954444pgi.128.1616516948125;
        Tue, 23 Mar 2021 09:29:08 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:817a:e98d:7315:e25f? ([2601:647:4000:d7:817a:e98d:7315:e25f])
        by smtp.gmail.com with ESMTPSA id p7sm15395400pgj.2.2021.03.23.09.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 09:29:07 -0700 (PDT)
Subject: Re: __scsi_remove_device: fix comments minor error
To:     Du Dengke <pinganddu90@gmail.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <CAKHP1duT_jQ6pA7WnHPiYvoQvu1vVmAgUDp1kjhnngRufgijgA@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d779d951-7799-e347-2889-f6a40b2ca7df@acm.org>
Date:   Tue, 23 Mar 2021 09:29:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAKHP1duT_jQ6pA7WnHPiYvoQvu1vVmAgUDp1kjhnngRufgijgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/23/21 12:24 AM, Du Dengke wrote:
>     When I read scsi kernel code, I found a spell error in
> __scsi_remove_device function comments. Patch was made in attach file.

Please include patches in the email body instead of sending these as an
attachment. Please also make yourself familiar with git send-email if
you are not yet familiar with it.

Thanks,

Bart.
