Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A4EC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2C38601FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351341AbhERR7o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:59:44 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:54119 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345799AbhERR7n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:59:43 -0400
Received: by mail-wm1-f54.google.com with SMTP id 62so4874703wmb.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=NfaILnfN/UlqyAzFnecyjcPRXvkPVQ28nHPExyQ59RpPJB28hdgRTpdCLVloKkOuBy
         yY+PPmfb2diM1+iKGIDLUWob6uSUretQS5a06OGhW+pzglx0m7gvReKJsalJwVkjp3qd
         EB9S/wuJKBIbvgZk0y7ASsnGLWSdAr2QOYXeZIpzA8WN/HlOfwDl0j4AlHeOFMvXwc7K
         xa6TjLZMF+7mhiApoFlD2sAc6kodzWh5Qm2hPctvdEn2D/5XK8h9rcWwRD0pW33D0tXW
         8rUIpD/IpXSq8UGcWjfvt7e8fBFc+SbAzuf8VyCUX1Gg4TswAKnk/7w+tS+jphh9VU5L
         Ezjg==
X-Gm-Message-State: AOAM532qYbyaUqrIyYnJQbHNrJ5jS5DIMgVWRqYoYtLQ9HATRSY+Wh24
        rbrdjOU2QpNR9AnhMpYx/Ik=
X-Google-Smtp-Source: ABdhPJzgf2Dz29FtM/b6c0C8T2lEFJD96mbgjSZmxTvzcHjHkSEpG3NfESvWo6UJgzoHI5YvlKZDng==
X-Received: by 2002:a05:600c:354b:: with SMTP id i11mr6581738wmq.102.1621360704902;
        Tue, 18 May 2021 10:58:24 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:f888:e3f1:214b:6edc? ([2601:647:4802:9070:f888:e3f1:214b:6edc])
        by smtp.gmail.com with ESMTPSA id h9sm18205377wmb.35.2021.05.18.10.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 10:58:24 -0700 (PDT)
Subject: Re: [PATCH v2 08/50] RDMA/iser: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <20210518174450.20664-1-bvanassche@acm.org>
 <20210518174450.20664-9-bvanassche@acm.org>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <990c6443-2fb8-b13b-b35a-d30db7b7b2dc@grimberg.me>
Date:   Tue, 18 May 2021 10:58:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210518174450.20664-9-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
