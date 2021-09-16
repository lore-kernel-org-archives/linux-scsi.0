Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9408EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 02:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7188F61178
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 02:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhIPCxh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 22:53:37 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:46942 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhIPCxh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 22:53:37 -0400
Received: by mail-pf1-f178.google.com with SMTP id y17so4487822pfl.13;
        Wed, 15 Sep 2021 19:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fQJn8Q0ll+72cPNZoFOS54tODtjRpWdTdBuYbo42e1A=;
        b=EyaKSgCiSiekmbH54AEfhuLHUww/bi8Lp92KQB7yx8aQXJ7Q5l1KT0eJqnyDBySMlv
         XItgiUQiSEV8nZaMh5aysiBKWS+0KdFqEk8R3Fila833hTGhHddrHZM6e/O4aKbHEHzE
         kKF1ZA5Lm3PD2GX8XK2vw0PNfBsXGuNavmMKmMKpdCHl7s50MoLWKTqctUM6wSv5eJTc
         LfKz/gndeWayILT8c/lq9C3gIjCUTZzVCdu3bxtGhA50I14DoXeXs63M6034AEeULsI3
         PuXkAY6XkSX7Y77QZEvl7QrAy6QH2Y2cnCx8ickfA/z4i7NxuUqHb4inLishqti8/LA0
         lU+w==
X-Gm-Message-State: AOAM533zYK1eamNg2ZDMNL2SJWFDTp6IeRYPhvF1Zr+xJYtfC0r8jCKw
        Jy9ClE2tkBxZMTc+B+MgJAjV99JKGWk=
X-Google-Smtp-Source: ABdhPJzny6dePmr/KKptiKIvkTX1lh4iC42Ju4V+xxjtzUaPQ4u0OwlpaScxUtyAeZ6Q9lMOt0bqYA==
X-Received: by 2002:a65:4007:: with SMTP id f7mr2788443pgp.251.1631760736875;
        Wed, 15 Sep 2021 19:52:16 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:90aa:5690:bbc:9f5e? ([2601:647:4000:d7:90aa:5690:bbc:9f5e])
        by smtp.gmail.com with ESMTPSA id s38sm1044341pfw.209.2021.09.15.19.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 19:52:16 -0700 (PDT)
Message-ID: <26faeb37-73fc-9423-69e3-8ffecf673f24@acm.org>
Date:   Wed, 15 Sep 2021 19:52:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v2 3/3] scsi: remove 'current_tag'
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux@armlinux.org.uk,
        jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.de
Cc:     linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1631696835-136198-1-git-send-email-john.garry@huawei.com>
 <1631696835-136198-4-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1631696835-136198-4-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/21 02:07, John Garry wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> The 'current_tag' field in struct scsi_device is unused now; remove it.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
