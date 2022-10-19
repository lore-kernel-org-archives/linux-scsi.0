Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618BFC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 08:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJSITy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 04:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiJSITs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 04:19:48 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AB91FCD1;
        Wed, 19 Oct 2022 01:19:40 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id w18so27813360wro.7;
        Wed, 19 Oct 2022 01:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=gainN3JJKW4QlyonF0+wIXMDpcPhi2mTm5DpXdBT/4PM1PS6fbWXYwdoGOa91EMukI
         KsfJGt+yH2bNmfniuoFs5HXaYD6+CJMpaF8PSyvcy27I0ZEn4zVHqvWm5CLu6VRX63kt
         PK9yomY/FxX6EuEz7WoVpIxtJa9FBBtDPklPNob3jHyX4etQKhaowjqLBqnWAHDil6uz
         i8ifHYOUbim/TU2lWr81r4i1gjHhUr/lFMDclOsJTusx1vMvDvVmgWPMQyY3hfvo/5VT
         S4PEHMBLcxvQRyyMNtsiXDCLJj7zB0D3MJ7ks02JrEBx4sv5GjcpCa9BvMgAHkYw48q0
         eN2Q==
X-Gm-Message-State: ACrzQf1wvv4yAJVWAR/2IIx9qOYM+NFoUilnIPEJtqe+7TN89GUmem9V
        OREIOJjDPLW3gfgK43Q36f4=
X-Google-Smtp-Source: AMsMyM5wXkXOMf7f8IO6xMolfmR8pG6VjvA9rnVoAkzSpdMGj1++8w63nXLq76FhbkNVn2Vm63O5Jg==
X-Received: by 2002:a05:6000:1786:b0:22e:3955:13a1 with SMTP id e6-20020a056000178600b0022e395513a1mr4197623wrg.624.1666167579379;
        Wed, 19 Oct 2022 01:19:39 -0700 (PDT)
Received: from [192.168.64.53] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id bi20-20020a05600c3d9400b003b49ab8ff53sm15131879wmb.8.2022.10.19.01.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 01:19:38 -0700 (PDT)
Message-ID: <34fae217-1d72-3229-bf32-d0fed88cc641@grimberg.me>
Date:   Wed, 19 Oct 2022 11:19:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4/4] nvme-apple: remove an extra queue reference
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-5-hch@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20221018135720.670094-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
