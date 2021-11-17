Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992ADC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 04:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D5561A8D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 04:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhKQERa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:17:30 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:33538 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbhKQERa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 23:17:30 -0500
Received: by mail-pg1-f180.google.com with SMTP id 136so1114675pgc.0
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 20:14:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6pMN2x4rfwXkNUvC5t9P6iBCXpqt/b8Tt9qgOTQJzoc=;
        b=lOoKwm8qvnWutaGGwM1Z7kHfgzDEkJf66W9DQLgILDF5mM5VwgIs0d/tlCP2QPqdJ1
         rcZ6mAtYyY5Wn9w2bvtr1Ti1E3mekiBQE8PgxUtMC4yefIoZfe4RinzRDIUIHfVHNErM
         u0GKey5xUbcSVxI2HDo+8219PbYT4aAUkERqKXY2ce8ADxrUK2g2dJD7GazRZOB0GCCV
         WS7qxzTeUFJNvex5mIr3nHQiZs4Og4yD9VB4DLxi2/0z0kp2iTdkLaYqwEzjwhBQCyft
         SUPbz7/G3EtH9h29OHOYyju8CSHwyBg5i/uq6vZgD9LrsptcppHOpWfBhOAH4oUOVmQW
         OzvA==
X-Gm-Message-State: AOAM533diipPmS8x94/jEbkps/aH5ndFRKGn089QoLPPEPUCwbYrM1W5
        7bUrCmjMyVin2hp94VUvmyA=
X-Google-Smtp-Source: ABdhPJw/Q32T6K0D4jYgDN57I/TsXjZBwDoJwMR/YEigBjVtRiLYkhJU/DJrRqSaaiiPY7vFN3T13w==
X-Received: by 2002:a05:6a00:cd0:b0:49f:b198:97a5 with SMTP id b16-20020a056a000cd000b0049fb19897a5mr45444358pfv.80.1637122472418;
        Tue, 16 Nov 2021 20:14:32 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t4sm20813571pfj.166.2021.11.16.20.14.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 20:14:31 -0800 (PST)
Message-ID: <91972e78-78cc-2b38-f730-a26a8a1b607c@acm.org>
Date:   Tue, 16 Nov 2021 20:14:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 01/15] libsas: Don't always drain event workqueue for HA
 resume
Content-Language: en-US
To:     chenxiang <chenxiang66@hisilicon.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linuxarm@huawei.com,
        john.garry@huawei.com
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-2-git-send-email-chenxiang66@hisilicon.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1637117108-230103-2-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/21 18:44, chenxiang wrote:
> [ ... ]

Where is the cover letter of this patch series? Please always
include a cover letter with a patch series.

Thanks,

Bart.
