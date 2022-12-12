Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F40AC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiLLVbC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiLLVa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:30:59 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68FD10A7
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:30:58 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id a9so13451044pld.7
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:30:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YelYc0D3sHMYTJAdqGwwHFeUlPoGI9K/sUUo4Mrhblo=;
        b=APNKkWhdwtGQUMwLtmgR8ATTP9jXjEsqd8qpmfEeuZlzfoo9VLCEuZeUrzkCAl5Rij
         mnhJqsW5gpBUnReAvmV3ZQHZ/WnN7rd5jzoHBgoJroFid/pW8Dd1d4HxGxQszIXGyrXM
         e7aCVQH7gD4hqEOR4pmb0k8Oo+rdj/o5jJpyrTwQr6LTJm6jr8q5OSuTYRqwj4DpJ9X9
         omIXxfNqXFfo87tDCKMJCk3gQ2irVkdppN/izhNvnd1czSewFJsqDS62e9LUMsNo2I8j
         EE2oSgP3vmjY+EhURdOM3Gz4ruEUtiOoZaDHEyA0DrQCGhN0pvVxe9ZtFdiTOibvxiwN
         KKQQ==
X-Gm-Message-State: ANoB5plCgZZ+Anprya2svSjwv7d+ZktnrcDfMM5c4FYMNzexDrdfYosY
        sOd7vv448ZYi3iqwO38VEoI=
X-Google-Smtp-Source: AA0mqf5JK4MGjiMVOPnRVD8CerjnpXE5PyzgBTzWdBd1qnRleneWBS9YsKZFPzWtPBVN9B3EnbONsw==
X-Received: by 2002:a17:902:ee45:b0:189:894c:6b48 with SMTP id 5-20020a170902ee4500b00189894c6b48mr18472542plo.59.1670880658328;
        Mon, 12 Dec 2022 13:30:58 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id jf15-20020a170903268f00b00189f69c1aa0sm6831520plb.270.2022.12.12.13.30.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:30:57 -0800 (PST)
Message-ID: <33d1e667-8c16-fa8f-cefb-f1506b47737e@acm.org>
Date:   Mon, 12 Dec 2022 11:30:55 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 14/15] scsi: cxlflash: Convert to scsi_execute_args/cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-15-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-15-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute is going to be removed. Convert cxlflash to
> use scsi_execute_args/cmd.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

