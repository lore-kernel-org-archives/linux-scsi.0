Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A01C54EE9
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 14:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiI1Orb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbiI1Ora (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 10:47:30 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B22AD9BF;
        Wed, 28 Sep 2022 07:47:28 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id e18so8669042wmq.3;
        Wed, 28 Sep 2022 07:47:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=moVcj5wUL67diewPTvJif+HnEWyT98Cdb+C8tVPt3/zcid/FMFYhgjPpWIeaKCMtLb
         aJ3LG5mgFaZPddvQEIuAaOSEHI0tPYXHyiPMQT/wxOyG4KvXhtpRNhnW6hC4ogkIHlyB
         3h0yh7V5FaV4VUJSXO8sQqRRSrSUZq9NkoGF0rs/ZlcO5ILVgVWtefjDUnYjprENcsir
         Ej4NsANa92DRmBsYp0fmEtEnlpMFTiIAocRSU84LkptEqY1FC53RsBQ9iJ+R2IwNnZdE
         5etzHlk0Fj2LeWwhNKr+myDTrcoseeCFr3gVaqjv4N5yQ+nEsBLKTKSzD20XTiHxyzK2
         a1MQ==
X-Gm-Message-State: ACrzQf0j6/lpuoXkMkYR5xyjT6ZTKbILZQoE6Aimnge97LEs3/xLzOqD
        nmg845Irq//Dk6o4KTKtj6M=
X-Google-Smtp-Source: AMsMyM55+YmNsrKezLlhI5j71+PHFUAYKdM7/F043aKabt3sPZ1Gpwqb7PmV4sFgWNm2Gr1rpy1HIg==
X-Received: by 2002:a05:600c:348e:b0:3b4:a9f1:c240 with SMTP id a14-20020a05600c348e00b003b4a9f1c240mr7194314wmq.192.1664376446886;
        Wed, 28 Sep 2022 07:47:26 -0700 (PDT)
Received: from [192.168.64.53] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id v4-20020a5d4b04000000b0022c96d3b6f2sm5710388wrq.54.2022.09.28.07.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 07:47:26 -0700 (PDT)
Message-ID: <4f32387d-b162-e901-a681-387d24d62c96@grimberg.me>
Date:   Wed, 28 Sep 2022 17:47:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5/5] nvme: enable batched completions of passthrough IO
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Stefan Roesch <shr@fb.com>
References: <20220927014420.71141-1-axboe@kernel.dk>
 <20220927014420.71141-6-axboe@kernel.dk>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220927014420.71141-6-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
