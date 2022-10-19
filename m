Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C941FC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 08:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJSITe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 04:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiJSITa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 04:19:30 -0400
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA686FAEA;
        Wed, 19 Oct 2022 01:19:28 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id l32so12410996wms.2;
        Wed, 19 Oct 2022 01:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=v5njm4bsG9XkU+nDsUSvYKNgJ/+zj0oCr2d/sHM81hq9ntlTu1AyfmjsVOSwkp2x3o
         lQf43iCq9tAroUNNIgnQHur9nAoy09iNPwl50NaOfz90XfKnj8k4VN1p2P982J0cCU4N
         aJvPKP324J1Cp4hX0FdtCsLazSo5YMv7mQKU1fotXYJK/oInYbk7FaglFXxyu0DbW8xz
         nlZroPNs+CiFWpweXg26/HYtHeSFXVd3eEmEo/vCOKPr2dI2GqWR+YZ2GzRZgXIfCT/2
         nwd7Jx7M6b2d7DaMBv9VkblMkcl/E0u89M7S9t6/jYGbiKpcLBu/L6Rkd467KtnpSE/2
         Ygdg==
X-Gm-Message-State: ACrzQf1tiTu5XVAJkOqCxk76IfYasS7LxA0N+1F9e2cRHAdGRf9yK+M2
        UEys25s/NYW6ufmu2kvXOabCSe8GdcU=
X-Google-Smtp-Source: AMsMyM6jdfABlBtJU9mx28hXGjxEvpJuKKRVafbYFMooNEY/ZiHfSwRXrftaND2z2wcWPuikvxixrg==
X-Received: by 2002:a7b:c005:0:b0:3c3:6b2a:33bf with SMTP id c5-20020a7bc005000000b003c36b2a33bfmr4527598wmb.167.1666167567218;
        Wed, 19 Oct 2022 01:19:27 -0700 (PDT)
Received: from [192.168.64.53] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id e9-20020adffc49000000b002206203ed3dsm13127525wrs.29.2022.10.19.01.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 01:19:26 -0700 (PDT)
Message-ID: <dd6a3e16-e44a-fdce-d8c3-8823f200c8a6@grimberg.me>
Date:   Wed, 19 Oct 2022 11:19:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/4] scsi: remove an extra queue reference
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-3-hch@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20221018135720.670094-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
