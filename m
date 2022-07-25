Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5EEC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 16:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiGYQmE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbiGYQlw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2022 12:41:52 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3304B5E
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 09:41:48 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id ku18so11012704pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 09:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=55H2reE2l3YivWu/Lf9xXm5xDYR89weNnm+BW4V1Jnw=;
        b=pNap6YelojiM7W4owTALhTjGZZ5dMUOHLM132zBT2NLKOMb2gSK3CrbtqTwlx9gxYh
         BoB/qJ5J9TFJTQGR6ubCavQsJAfPlldZJ0fi47LYlv51ATbvkCQmYvSD/qhgZGi9dxoX
         DdfmHXx9k5OYPRQ3q5cEJJPHhpEGNEGUf+bXREGkTwngSownXMKZrLjnQp7g6XOWH0KY
         YsrbHHBehUQgu7lNRgNfi09yPLLUGj3JfJgRpoIteoEdqF3Hfa2LoIl7eTcCIJqEZtgI
         MTCLPyVnKfqA0aMQxwlLBpGDXupXZd/HFBxBG2YOWJJEKJPHwqvfbObzpwwlA6D1/1So
         B/eQ==
X-Gm-Message-State: AJIora+XQxdCK+ZX50Xa3qDa8u/LFZzpjM5jyc1SgnSQx8KdBZclUFXx
        Y6ND7A+DtTwiRE30GnIH8J4=
X-Google-Smtp-Source: AGRyM1sbLVsMtLPstM1620wElVhAD94WkP+AK28VSU1Ml+TmvuHxdASOdJDWcev9ZuZyP2n9qnwY9g==
X-Received: by 2002:a17:902:b497:b0:16d:1280:ebe5 with SMTP id y23-20020a170902b49700b0016d1280ebe5mr12978542plr.70.1658767308376;
        Mon, 25 Jul 2022 09:41:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:54bc:1b55:1813:e7a8? ([2620:15c:211:201:54bc:1b55:1813:e7a8])
        by smtp.gmail.com with ESMTPSA id lb14-20020a17090b4a4e00b001f1f5e812e9sm9505850pjb.20.2022.07.25.09.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 09:41:47 -0700 (PDT)
Message-ID: <e962c613-7bdc-99f3-4273-b91beec614ee@acm.org>
Date:   Mon, 25 Jul 2022 09:41:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] ufs: core: change comment message to popular format
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220725131558.13219-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220725131558.13219-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/25/22 06:15, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> Some editor cannot display ‘0’ ‘1’ in correct format.
> Change it to '0' '1' for most editor can display.

As far as I know checkpatch accepts non-ASCII UTF-8 characters. Using 
this encoding is essential to spell non-English names correctly in 
source files. I don't think it's feasible nor desirable to eliminate all 
non-ASCII UTF-8 from kernel source code files. Maybe this means that 
it's time to switch to another editor?

Thanks,

Bart.
