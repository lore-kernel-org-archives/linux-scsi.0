Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D416C25B67
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 23:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjJWXn0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 19:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjJWXnZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 19:43:25 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D2892;
        Mon, 23 Oct 2023 16:43:24 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5ac88d2cfaaso3051181a12.2;
        Mon, 23 Oct 2023 16:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698104603; x=1698709403;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XoxPFkvwF1gGCb4SskDRp9+XUyFIjvmDkssfl+Vpa5g=;
        b=bY4B7IUZezHBLixh9lHiPJqFr08+xG5hFVBFrnDuLQ5kop7OeEUAiXvzOhvAN+eHk5
         XLa3xdHkxnIPTZuBHz275UIa4xf941BgajdM1RDeTsQLV2GuiEz3YuPrc93XghNdtaqt
         WiJQ6OfK7Rc8zBiYMegWz/soJxVznN6qAxe/oAZ4U/Y2NGot6nWy5e2COTT3pH82iDoj
         5UwxgV8Nh5TCqoMA3UismfKHwceWor1Vl26D5u7AvUExOOUDxnW6WQNIGGtITb8ONqnb
         En8rYGjT61YsCrwIczQdoLdmnNcDCkk6xlFnXnI+aBhqjsEkGKreDdvfnvptJAOO61a3
         xr+g==
X-Gm-Message-State: AOJu0Yz0nlaTAlEj1ZXnWQXALDLjSh5FFpzGVLsU1GFhHs/AMK7/m5nv
        U6ZuavJ2HWOraZFxHumaKsY=
X-Google-Smtp-Source: AGHT+IHs+Th71GT5S/3HopfGomFpPWz3knSxkodk8eFCZZJGbVbwmbY9oU+jLkxPzxOEmeDI8nhKPA==
X-Received: by 2002:a05:6a20:440b:b0:159:f884:4d6e with SMTP id ce11-20020a056a20440b00b00159f8844d6emr1359915pzb.40.1698104603310;
        Mon, 23 Oct 2023 16:43:23 -0700 (PDT)
Received: from ?IPV6:2601:642:4c01:5668:fce6:4ab1:fda4:1303? ([2601:642:4c01:5668:fce6:4ab1:fda4:1303])
        by smtp.gmail.com with ESMTPSA id g29-20020aa79ddd000000b0068be4ce33easm5925993pfq.96.2023.10.23.16.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 16:43:22 -0700 (PDT)
Message-ID: <de1c1829-d23d-4628-85b0-a778489ebd7f@acm.org>
Date:   Mon, 23 Oct 2023 16:43:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 00/19] Improve write performance for zoned UFS devices
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/23 14:53, Bart Van Assche wrote:
> This patch series improves small write IOPS by a factor of four (+300%) for
> zoned UFS devices on my test setup with an UFSHCI 3.0 controller. Please
> consider the block layer patches of this series for the next merge window.

(replying to my own email)

Hi Jens,

Are you OK with queuing the first four patches of this series for the
upcoming merge window (one week from now)? If so, I can send the
remaining patches to Martin after the merge window has closed.

Thanks,

Bart.
