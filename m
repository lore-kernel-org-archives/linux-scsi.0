Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11716C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 18:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiKISzR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiKISzQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 13:55:16 -0500
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4BE10CC
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 10:55:14 -0800 (PST)
Received: by mail-pg1-f173.google.com with SMTP id h193so16964532pgc.10
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 10:55:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qiJ2RMEnx3zisNVaT/Df/UDbt3GpUPrRuimPiihrp70=;
        b=wLsAV/jAgeje6fogDtUR9PN1jdXgZfj+BTRL52M/pR71yGqsstqtPQzvzFkc47Kry2
         DkwYdm9lnbANNgcOX2W8WmtqXGO0jkrnbA6r8x9txaSu0Uqt/5R+vxheYknj5XjK+ukx
         ew73c17UMbL7DZPpaqc3hV++1bOMxipL7EHI5fFWgtDOflvALAybVY/vxzcL7ZngaeeZ
         pDr6uiTcLwFfG8M30vL6Dp+iLhrEW0r1LzoYGO6HG2r0U2I9FzoUKf42bttEJwZNs9tn
         Lpf61u0DBBmnauokH8oR45wTtEOp6R+NgdPxMdJB/NARAqN9l65OBrv3nNArWbtj1Nt8
         DOfw==
X-Gm-Message-State: ACrzQf2yPDSnN2OU8m7/d7kfK5REWZrhl+jXdml99xJSsefjtPY/IkH5
        UEI0NR9HJUZWlnMb9aCOjZ0=
X-Google-Smtp-Source: AMsMyM5zSoMYOc+jpDWzbyLaXKbiZOJQn6tNKInogajKEjWmE4CFJDt1nRo901ztP2Z/GH/lWIsW/A==
X-Received: by 2002:a63:2a44:0:b0:46e:9fda:219b with SMTP id q65-20020a632a44000000b0046e9fda219bmr51138962pgq.347.1668020114057;
        Wed, 09 Nov 2022 10:55:14 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id m12-20020a1709026bcc00b00186a2dd3ffdsm9450262plt.15.2022.11.09.10.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 10:55:13 -0800 (PST)
Message-ID: <95cb1c5d-1ae4-0f4a-2f86-f3904707d9f2@acm.org>
Date:   Wed, 9 Nov 2022 10:55:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 31/35] scsi: sd: Have scsi-ml retry read_capacity_10
 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-32-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221104231927.9613-32-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/22 16:19, Mike Christie wrote:
> This has read_capacity_10 have scsi-ml retry errors instead of driving
> them itself.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


