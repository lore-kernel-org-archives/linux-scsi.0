Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C217BC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 18:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiKISwM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 13:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiKISvm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 13:51:42 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDA22EF1A
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 10:51:14 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id 4so17981487pli.0
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 10:51:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gucSCGcIGu0RPqehNdQUcvMA+fFZ/VYTZL2kkgwXxiE=;
        b=md2lvkSzRISynmBSJzyopnoT3OA7Jnm0rl0tf4jvUInMR3z6sQw6Ke4Hf5NWOAYSgt
         AhcyS+iqpyNpDSC0+mBCgWVUfP0YUpuUqo1WQEqtfZQMxcAbwjX0zoPe7I8GpvYt35wj
         KOd/liCpdjou5LzKDi/UZZXrEWfgFkZD83VEK2ty2CIU+QbaDzJ5eKDr9fMZjFvPmMII
         FjkYprkI31rdBdr7k6Qk+6A27AkY5Bjv9WZDu5fjOBR5SJTjagaaJSC1ThjzI/enOBd6
         hBV+6EHYIdpyZR3Bdg1DInSFuQl8KiRu6nWi30zZJhb8fGzn/2myze7HPmKnBHrHYkm8
         EJhQ==
X-Gm-Message-State: ACrzQf3E4csp9IVQv3KrZ3NfbtAvvGiuDFJEON69lHeA3uuHe/p0f86I
        etFw/zmZzlD14tWaOSiloXw=
X-Google-Smtp-Source: AMsMyM607j9Sfc6Nz78RSLDQW+D/hMNt73M7yo/HT7l+89SITEKJia/h/C/JYTXZ138GE8c6dukiuA==
X-Received: by 2002:a17:90a:600a:b0:213:2a:851c with SMTP id y10-20020a17090a600a00b00213002a851cmr79968917pji.177.1668019874037;
        Wed, 09 Nov 2022 10:51:14 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902ce8100b0016cf3f124e1sm9477206plg.234.2022.11.09.10.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 10:51:13 -0800 (PST)
Message-ID: <ac2ca67a-699a-73d9-04b6-bbe951fa6a73@acm.org>
Date:   Wed, 9 Nov 2022 10:51:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 28/35] scsi: Have scsi-ml retry scsi_mode_sense errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-29-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221104231927.9613-29-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/22 16:19, Mike Christie wrote:
> This has scsi_mode_sense have scsi-ml retry errors instead of driving them
> itself.
  Reviewed-by: Bart Van Assche <bvanassche@acm.org>

