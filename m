Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46D1C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 18:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiI3SG1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 14:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiI3SG0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 14:06:26 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241FD33373;
        Fri, 30 Sep 2022 11:06:23 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id bh13so4798857pgb.4;
        Fri, 30 Sep 2022 11:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YT7X5vhmL1EhBoIh6HU+YtvZMdxEyGw7gDpCuuYCbXI=;
        b=XCfDyVVSIwLmKCwfWHV/w63ihrTP54+BqqVwsvYky0f3QZoXpupKIsuHOmcYugED5o
         KGW4CM7RJ4dUAE1lQAKxDjhmmTvfgqPp8hWPqQfZSZdJF581eosQzps42ibsq5K2hw17
         FYps4LB/5agcghEvcxmTeIK/9ZwjSQxx25WhqVIBQ5+AarTJRJEQLszrZ7/zOxSrOKOk
         S0P01yU6QZR39iNYBznOdJiJHiAdvE1YAEneZ4JOUUFkWreTE69kdmYXrsGwgE69B4Z4
         6q7ehBlAjz/H6Y1nfstZX1eLH8WM8acPzChAavJst6LMjQzyrLMfYPwF0LTbiBhbOF24
         iKGg==
X-Gm-Message-State: ACrzQf0vVeWM1YBLfcjKOdzRr0yuVYEy3Vc35Osf/hMCvMBPw9t1cHuz
        Jn3Kehfg6xyVafaV+mZOdHw=
X-Google-Smtp-Source: AMsMyM56KaNN/+17HC2W0l9EdhWsSnly4xIWql7BBz5mTxA+4i5xBGxuqb0u7cg9kIwySyJZbVOYFQ==
X-Received: by 2002:a63:2c8b:0:b0:41c:5f9e:a1d6 with SMTP id s133-20020a632c8b000000b0041c5f9ea1d6mr8443936pgs.601.1664561181752;
        Fri, 30 Sep 2022 11:06:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:56f2:482f:20c2:1d35? ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id l18-20020a170903121200b0017a8aed0a5asm2217982plh.136.2022.09.30.11.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 11:06:21 -0700 (PDT)
Message-ID: <5eb0ced2-be3f-93be-3b0c-4271495e53bc@acm.org>
Date:   Fri, 30 Sep 2022 11:06:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH -next] scsi: ufs: Remove redundant dev_err call
Content-Language: en-US
To:     Shang XiaoJing <shangxiaojing@huawei.com>, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@somainline.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20220923101217.18345-1-shangxiaojing@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220923101217.18345-1-shangxiaojing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/23/22 03:12, Shang XiaoJing wrote:
> devm_ioremap_resource() prints error message in itself. Remove the
> dev_err call to avoid redundant error message.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
