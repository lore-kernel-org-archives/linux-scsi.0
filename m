Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF473C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 03:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbiFMDOK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jun 2022 23:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbiFMDOJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jun 2022 23:14:09 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DDE193CC
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jun 2022 20:14:08 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id h1so3984653plf.11
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jun 2022 20:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ubLyStSlyUmnJaEr7fSu5SMpd42+LpO4uYPmeIXKiOc=;
        b=vI7ATmxHvKbUHPSslhKIzVskfvkWmUTyTnFPu54kZtmXCmCDgHIudJiQs2Dnyd01LY
         Wt5YAt8UE4ivu15TVNM63rsANNwK3IqmuiMrHlO3xh1HLVOf6zV/Cy6p2t/ZFohi4Oxb
         XC/HUjH6MQFu+oLMTSHEp9aWSu1nB+rCL0vcGf/Nor94wC2bIlzr6YhbZV97qTERN2TQ
         g6j9TUSE1zzDawfJyuMa6gRx+wtqVpIa29aWcNG1ep3JZRbUdvdtILxVYVZxkEmCmHkk
         viqaaUT6mqF+N1d2z/SaWF4cE0W842FphIL/GRJjfCJsH+62faC0PN9AebUOQu/JgvmP
         AmRw==
X-Gm-Message-State: AOAM533Eg/+aWJh7cWJcqYDcTHrvxGadqsH35zZnKy4XYwDQ26xTg05q
        rz2fyOGliQOWKd8m6BTg/FE=
X-Google-Smtp-Source: ABdhPJyeFj7FSiW1aA4vNtVd+zHaEyKL+2XXTQdhppBlSUTqsOHoty+ezwyZZFiep/AY4RCkB8BzRA==
X-Received: by 2002:a17:90a:cb8c:b0:1e6:715f:ed28 with SMTP id a12-20020a17090acb8c00b001e6715fed28mr13334092pju.69.1655090047678;
        Sun, 12 Jun 2022 20:14:07 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j15-20020a17090a3e0f00b001e2ebcce5d5sm3873984pjc.37.2022.06.12.20.14.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 20:14:06 -0700 (PDT)
Message-ID: <bda14873-9b95-f971-6470-913cb00307fe@acm.org>
Date:   Sun, 12 Jun 2022 20:14:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] MAINTAINERS: update cxgb3i and cxgb4i maintainer
Content-Language: en-US
To:     Varun Prakash <varun@chelsio.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20220612121340.6746-1-varun@chelsio.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220612121340.6746-1-varun@chelsio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/22 05:13, Varun Prakash wrote:
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>   MAINTAINERS | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1fc9ead83d2a..23e1fcf4ab48 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5361,7 +5361,7 @@ W:	http://www.chelsio.com
>   F:	drivers/net/ethernet/chelsio/cxgb3/
>   
>   CXGB3 ISCSI DRIVER (CXGB3I)
> -M:	Karen Xie <kxie@chelsio.com>
> +M:	Varun Prakash <varun@chelsio.com>
>   L:	linux-scsi@vger.kernel.org
>   S:	Supported
>   W:	http://www.chelsio.com
> @@ -5393,7 +5393,7 @@ W:	http://www.chelsio.com
>   F:	drivers/net/ethernet/chelsio/cxgb4/
>   
>   CXGB4 ISCSI DRIVER (CXGB4I)
> -M:	Karen Xie <kxie@chelsio.com>
> +M:	Varun Prakash <varun@chelsio.com>
>   L:	linux-scsi@vger.kernel.org
>   S:	Supported
>   W:	http://www.chelsio.com

Karen has not been Cc-ed and no explanation has been provided about why 
the MAINTAINERS file is being updated? That's weird ...

Bart.
