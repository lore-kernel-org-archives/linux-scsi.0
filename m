Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90276C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 08:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiJSITp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 04:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiJSITi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 04:19:38 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B28BFD14;
        Wed, 19 Oct 2022 01:19:35 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id u10so27838128wrq.2;
        Wed, 19 Oct 2022 01:19:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=KrfJCz4d6luLN2qjCV9vBSEdreYzhoxwGiXcIPzJIdUpa2weWS3r6TcocgNQUv7BbH
         GgpC8AOnWYdFolWZXtzKcwSyjUVL0Su+YF3r4iqGLYW72zayDs2jD5D93rNVjiZgwcGP
         pbCdWJVSMIy3tC1LfqNRoWVMrrr8DM4PE0xp9He/sp568UQRLPvLx8fsXbBYWPsIi+ze
         TyQGphRDGTV4jIPYqG3MnO1LDD9+dNXKKY2RwxVBx3Mi6lMriGnF9mIjEqhXillCllSN
         rd6yVeD8Jraw4sPCt+BiFNXf8TTHQQct3zPr/C5gaDCckYj86SFFkurzVjewRy6uWSJx
         9Izg==
X-Gm-Message-State: ACrzQf31OPbNnIv9XQzrw0lphiq1eZJQA0bjUNGEosEDlmogs6I+4lBY
        vOWrPtE7UrYLwlwQhnkw8sM=
X-Google-Smtp-Source: AMsMyM4lc4x/iFtG7fWlIVzB9oPWjbMGXLCGhbisxKo/bil/DlRMDg37IxS+5Kq2K+aKA3fI7lbTJQ==
X-Received: by 2002:a05:6000:15cf:b0:230:ba81:cefc with SMTP id y15-20020a05600015cf00b00230ba81cefcmr4214706wry.544.1666167573743;
        Wed, 19 Oct 2022 01:19:33 -0700 (PDT)
Received: from [192.168.64.53] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id g5-20020a5d4885000000b0022e55f40bc7sm12916968wrq.82.2022.10.19.01.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 01:19:33 -0700 (PDT)
Message-ID: <635c9218-2ab6-5759-2657-5a1d3f50735e@grimberg.me>
Date:   Wed, 19 Oct 2022 11:19:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 3/4] nvme-pci: remove an extra queue reference
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-4-hch@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20221018135720.670094-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
