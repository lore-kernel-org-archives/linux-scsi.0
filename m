Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08091C6FA82
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 17:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiINRG4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 13:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiINRGz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 13:06:55 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5848646A
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 10:06:54 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id fs14so15191642pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 10:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=m1jvSnG4OFoD1hM2t1Em5XHiAWNHCkLT2PaFzLV80og=;
        b=gCaEioCo1KKhGK8x2A656O+Rb1u8iohl+lnQXuqKMzL+1nKUAeqFpe723osbn/iCVs
         J6XwIyiGOzY7X80+427JYTQqpM7sZDt/It04nHGwd1QJCxrPjQmIf1H0l2srrijNe8cZ
         W1yJf89vQFzso86b/McmVIo1h/SKTKyqphXhTkJxPHFc8YSZmgyw4r8gFfqPW3yV7uwF
         TgugtElQwKLH9c7kCFvqbI5k73OOMIxrJOzoj/Rm9DojzdSvGl+6YrKQKwE24ikEdw4l
         g/ZFxjsSPNWo5564LSv96FyKQ38ZR5GM0rUW/I1yYz3crc2EOJLzXlmvMZUMtUf2bIxF
         Qh1w==
X-Gm-Message-State: ACgBeo27rD1EwLb05Ld+SzzoyVKvk8b9x02N72kpQElO/7cx4iRTA6YL
        pEwsjZpdDZb6jiQzQZRXCdvmk6FLzxE=
X-Google-Smtp-Source: AA6agR54vdSIF873JIGvpWvT2C7GDFo4V50PZqj3ZHdL5HD4FoUMFsNk02MPNNN/MTdY0rH7qn+Vcg==
X-Received: by 2002:a17:902:d18c:b0:178:292b:a89f with SMTP id m12-20020a170902d18c00b00178292ba89fmr18556438plb.85.1663175214313;
        Wed, 14 Sep 2022 10:06:54 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:44a3:d997:5eda:cf2b? ([2620:15c:211:201:44a3:d997:5eda:cf2b])
        by smtp.gmail.com with ESMTPSA id n5-20020a63e045000000b0041cd2417c66sm9804423pgj.18.2022.09.14.10.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 10:06:53 -0700 (PDT)
Message-ID: <264043c8-f4ab-d8f4-cd5c-6e91424181dd@acm.org>
Date:   Wed, 14 Sep 2022 10:06:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 0/4] Prepare for constifying SCSI host templates
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20220913195716.3966875-1-bvanassche@acm.org>
 <0c708d51-e853-f5e6-dc93-cb43ff2e4109@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0c708d51-e853-f5e6-dc93-cb43ff2e4109@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/22 02:21, John Garry wrote:
> note: I find that this series does not apply cleanly to mkp-scsi 6.1 
> staging (which I guess it should), but ok for v6.0-c5

Hi John,

A few reverts have been sent to Linus and are present in his tree but 
not in Martin's for-next branch. Hence the choice to base this patch 
series on Linus' master branch.

Thanks,

Bart.
