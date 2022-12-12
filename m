Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7FAC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiLLVTV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiLLVSj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:18:39 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6568B186FB
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:18:33 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id 124so863393pfy.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:18:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kKjyHXTJtZ7xQjwFzHWFI+ygfYZq9SPXXMf09ROwrAs=;
        b=A1PIGRY2qqyPMqyPzTm3PrCrqQEXSzo4yGMEU/Rk3XxtVoorkw4Ai8oI8F8BbGxPOt
         lQ+eX7+LBnaXb9xHtSjrtawVUCIu2cN3lDwug+9BqluEegHLF7Y1xKOB91JEdrUqYBUG
         O8a/TREkM19cuzvAY+iVSTGT0aifQ11UJuLbGEnJ8yaUGOq1imjKXN1RAvUGOJtLcq0S
         XWt9saDpHRJn8T8uSw3tp1yHGTF4OkKYVhOiCvhjXIOMeotHK6ucoGMR7HTx5Cg6sf4d
         hRKZ+M+vcqN3kB2T/MEhkKUfklUkJ/6pmKCRer6AyGY/2dKRfJvSxMMNxMNjpqILgu8Y
         SYvw==
X-Gm-Message-State: ANoB5pk4Nc62LO/5OajvHPvm9tvbvBzfWd9hAsLm1bB6er0OFGRyQ3Ci
        Jm82sWpNtn/mZncXr0QKYB4=
X-Google-Smtp-Source: AA0mqf6ZXIN9aQ1o+1tVG+Naq05xs1TjVTS+VfF52fbwRG8rnnXviNFsr2kGeZVgTHeGyay3zX+XNA==
X-Received: by 2002:a62:5fc1:0:b0:566:900d:4667 with SMTP id t184-20020a625fc1000000b00566900d4667mr17930232pfb.1.1670879912815;
        Mon, 12 Dec 2022 13:18:32 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id w19-20020aa79553000000b00575ecd1d301sm4990506pfq.177.2022.12.12.13.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:18:32 -0800 (PST)
Message-ID: <28d84f1e-4eea-62f0-7973-98a25065018c@acm.org>
Date:   Mon, 12 Dec 2022 11:18:29 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 11/15] scsi: sr: Convert to scsi_execute_args/cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-12-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-12-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert sr to scsi_execute_args/cmd.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

