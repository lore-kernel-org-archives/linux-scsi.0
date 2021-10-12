Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD2CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 16:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3A3760E05
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 16:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhJLQaw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 12:30:52 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:42866 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLQaw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 12:30:52 -0400
Received: by mail-pl1-f174.google.com with SMTP id l6so13853069plh.9;
        Tue, 12 Oct 2021 09:28:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lqr0Xjwo4bt3FrFTL/PXm4WKYr4cNF7lZlXpOFURPfQ=;
        b=SjJGQP6U6oLLtzpWYa39+eIyV/ufxLuk60KmSL3tNqrNmmJ8T7IGinTHuTa9Gybf2h
         K2MWmvZRv50yyRntsu8PJ4uJtcHMfuw+m9YSTaqd9071skdn+jPT4IA+c6A5pEV+/6xw
         cZPk3gsrNMMuAJT5stit8AztCFtMAmr/5mG7cLci89wkkVJFVD4XBVnXKhsOEn7hdhjz
         ZmeBTrlu/wcXxE7dyhzTp9NLZIIHi4VAuA7z2UFqgJhLrt4EY2zfFXGX5j0wagArblyc
         nxaJavVfir0069ZZK74MXqKbAJ2gG5IYDByuwYWiauX7wUpfU4rLQygjXRqkoYLHFarI
         KvAQ==
X-Gm-Message-State: AOAM530QpWi4BwCYFrdZ2pxDv3AogGqO/Cx1ZgXnxpg0qpmFjgnaCFAy
        fhJlelhuvP/jaZGvAMCVL61NH+/QoeQ=
X-Google-Smtp-Source: ABdhPJzIvz2dXTPPZrJJPf3E236of698Im62a+c0zIOAN9z2BtB6E2tsUs4RK05DMhyFmQX5M4kIjA==
X-Received: by 2002:a17:90a:b391:: with SMTP id e17mr7186659pjr.137.1634056129580;
        Tue, 12 Oct 2021 09:28:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id j6sm6268139pfb.175.2021.10.12.09.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 09:28:49 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: print write through due to no caching mode page
 as warning
To:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     dgilbert@interlog.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210122083000.32598-1-martin.kepplinger@puri.sm>
 <2d3b0e8f422b7ff08a5c4ce804a1884eaf9b5d60.camel@puri.sm>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <87cad616-2075-b52e-cb8c-2f7180bbb1ee@acm.org>
Date:   Tue, 12 Oct 2021 09:28:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2d3b0e8f422b7ff08a5c4ce804a1884eaf9b5d60.camel@puri.sm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/21 8:18 AM, Martin Kepplinger wrote:
> does this "consmetic" change have any chance of being acceptible? At
> least it'd be nice if messages sent as error are real errors that needs
> fixing.

Hi Martin,

It seems like I overlooked that patch. Since this patch was posted ten 
months ago, it is likely that it has disappeared from the mailboxes of 
the people who are interested in this patch. Please repost this patch.

Thanks,

Bart.
