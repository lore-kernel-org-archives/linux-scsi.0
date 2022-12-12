Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291BDC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiLLV3q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiLLV3o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:29:44 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3B910A7
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:29:43 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id jl24so13452876plb.8
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:29:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FbyO2uW1aDpSv9vFKCa3mA/pIErbe5qJj/d4Gk7oFCk=;
        b=cFuROY+6o72NStRppCuxt6tfYJVWbI/GxsJKX803etzgSgLRuR3O7Oyjg2HTo4ws7C
         ONO6fSoH4/2ZuEJwcPJZ8ZG1XLZIUUIIJnZxxF95lpuMihlmSudJ54JWxxXBOlTAyJ2j
         4NXImUGA5rcBPkLCMHNB4OLb6DcDU8NdUUMOxcSHRZBiIyoi6SLEBXWuglMjrEmc6Ozl
         4ueC+ul9Lmvehq+K8PUq60xmGJB3x2vUEcj8ZQVUkxx+6rRCyF0PUZ6KRxknKXADAC9k
         HTYPoGXOm5Tenmtp3qWZ69BqlL41XfzhszKqykdrc9U3h55CxkV0xa9rU17BLR4Qtx8X
         Vpfg==
X-Gm-Message-State: ANoB5pkKusxJap2FeRzyvH3wlCguelDgCnD5gnjpqLR46yNUCjBrzEAT
        Nm4Nr6+4LseiYOQ2dToe5G7pMcubjL8=
X-Google-Smtp-Source: AA0mqf5gEXq/OGsBuwEwPL1kD/cIfiM6Rg4MYPB9bbZRqrErBoOcGS8WrOZdcAG/FFAnacVnXxr2ug==
X-Received: by 2002:a17:902:e550:b0:185:441e:2d91 with SMTP id n16-20020a170902e55000b00185441e2d91mr25746327plf.40.1670880582775;
        Mon, 12 Dec 2022 13:29:42 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902d49200b0018997f6fc88sm6847037plg.34.2022.12.12.13.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:29:41 -0800 (PST)
Message-ID: <b418083c-8c7b-8bb0-ea9f-e88432e42efc@acm.org>
Date:   Mon, 12 Dec 2022 11:29:39 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 12/15] scsi: virtio_scsi: Convert to scsi_execute_cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-13-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-13-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert virtio_scsi to
> scsi_execute_cmd.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
