Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218C5C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 17:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC7B661391
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 17:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhHWRXm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 13:23:42 -0400
Received: from mail-ej1-f45.google.com ([209.85.218.45]:39758 "EHLO
        mail-ej1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhHWRXl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 13:23:41 -0400
Received: by mail-ej1-f45.google.com with SMTP id a25so11851044ejv.6;
        Mon, 23 Aug 2021 10:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=CwYFuNa4M5WfOUE14YoJY/3udP1Pi6dLlMNx3Cz8HgYXHpZqACLn3ZVTQjgNnzcQc4
         P5lZ26s83Y0jV9Un3LAWwlLcf875mnUv6pJZFRUXYPeehSRT5MR5LUf75thoWH2WzL/A
         KxpZrmJFiUTc0iAEO1Q8bL61y5fkv6pg876NYMjJ8vyZsgbpTvXi/6IQXLsVwSBurLgN
         9+LERySNL5OaoipRaJ4s7h9WqOgHEpGBE49A5hOcivFHwRPkk4PhYnDweqNb7J1TMI/l
         VpeiUI5KXnNWIevBpuUPukvglABzR3NIzm2YN/iM3s1zOVJSStRC2uEheJW2M56dtkU2
         oDnA==
X-Gm-Message-State: AOAM533Fcm3RNjzwfAQwCqgQSEpFm4bExdtLnhUFzGpxpip7m9pIsQLw
        mx0F08EeCQx2aRAmOPIvifJnn27jBdQ=
X-Google-Smtp-Source: ABdhPJzhQQj+1FbUSkhXJlv4z4LCBoifoOuwSSVN/lL3GU689ibnE7T8pYP3tbn2sySj3BojrvwNtg==
X-Received: by 2002:a17:906:8258:: with SMTP id f24mr6605489ejx.375.1629739377321;
        Mon, 23 Aug 2021 10:22:57 -0700 (PDT)
Received: from [10.100.102.14] (109-186-228-184.bb.netvision.net.il. [109.186.228.184])
        by smtp.gmail.com with ESMTPSA id 8sm7775687ejy.65.2021.08.23.10.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 10:22:57 -0700 (PDT)
Subject: Re: [PATCH 1/9] nvme: use blk_mq_alloc_disk
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210816131910.615153-1-hch@lst.de>
 <20210816131910.615153-2-hch@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <40e534a8-ebcb-73ca-fe79-9170819114f0@grimberg.me>
Date:   Mon, 23 Aug 2021 10:22:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816131910.615153-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
