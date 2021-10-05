Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70255C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 19:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 585CC61371
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 19:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhJETD4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 15:03:56 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:39535 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhJETD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 15:03:56 -0400
Received: by mail-pg1-f175.google.com with SMTP id g184so230433pgc.6
        for <linux-scsi@vger.kernel.org>; Tue, 05 Oct 2021 12:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aIANqcVrIntmfysP+bq7J22LCcoMMLlhyf8xbm7ALS0=;
        b=5kvEPJkVU161FJ7mFp4Fe5LKSqxu898wkHnwY8ELYUo1+W8lLtzFG6PqVquN3INFLi
         QfktapAiXTWkLNa+CaNDuLgCJ5HmZxZ7EPUoOjSQwLy3dmrsVv9RqV989Sbth8L2zrAD
         jKV6H0AbxpnjcfWGrdhjDew3oJh/XEsEm2nm9482vB6+q9SDkfXKGKSLobOp8fRfg26B
         dlZYQf4WkGV45vFElxHoez8Bm4yqcCznceqatYV+ad0VN37cC9zNFrzMl2M+cR1IXZfo
         UP1QAU5Ho9xWUbEnTosN2I9KQ0shVDxObxGgmfk1yTHcpvsg5DB5AqYYA2nQxkrWGaFo
         4ApQ==
X-Gm-Message-State: AOAM532G+flv+i3TsG5QE57L4NdicD1zRGSrwF737iQMF3lESrO8Lsqj
        m5L2gLxZE1n9fdNOelAPdv4=
X-Google-Smtp-Source: ABdhPJzeILe4dVQU1m/ZcIDL0f+Bj128PBhnF2fipPPYcbkEFKTi3aUw/pjqp8vvProeVyHj0KItog==
X-Received: by 2002:a63:e651:: with SMTP id p17mr12254202pgj.66.1633460524889;
        Tue, 05 Oct 2021 12:02:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:e8fc:af57:dd49:3964])
        by smtp.gmail.com with ESMTPSA id g22sm22195183pfj.15.2021.10.05.12.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 12:02:04 -0700 (PDT)
Subject: Re: scsi: ufs: support vops pre suspend for mediatek to disable
 auto-hibern8
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        jonathan.hsu@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com, mikebi@micron.com
References: <20211005132738.14820-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e8f8cb97-c681-0fca-56f0-30c442264761@acm.org>
Date:   Tue, 5 Oct 2021 12:02:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211005132738.14820-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/21 6:27 AM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> Mediatek UFS design need disable auto-hibern8 before suspend.
> This patch introduce an solution to do pre suspned before SSU
> (sleep) command.

This series is not bisectable. Please combine both patches into a single
patch.

Thanks,

Bart.
