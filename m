Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0E8C00A89
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 03:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44652205F4
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 03:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388623AbgKEDpB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 22:45:01 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44592 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733135AbgKEDpB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 22:45:01 -0500
Received: by mail-pf1-f194.google.com with SMTP id 133so275237pfx.11;
        Wed, 04 Nov 2020 19:45:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=biDC4E7QW4kY+RCuS593Sf8Q4Qz6TZ6iV3bgi7DMj78=;
        b=hulAdtUT/j3s/XoDcSKBRFVXUMkDWwlSLSNPwf5S6N7Kffx4TIhNGCXKJJag6PACna
         b2s3LUyNqmosY1ppoTlaxWmrhjP39bv4PDAXILdiJO4mfjwDNYSsRsi3FWe7yzaHizht
         zWzd6j1uSL7R48KJfvgRnduYvjFIEwdMhB3yHn+V16mGJQzixj6jxuZhZ+B909sdmcML
         AJ/3kvS8HpGouqGKHIge1TCw+qUYkSP9Vzq4z+6X2PHdruVWKz8MDb/5Kc6MOgKCXBh3
         k45K8uVrXA3hCzstBuME46JkBt1HIHQRgpEgW4bcDkekI/OdksSaH1VxZi+tXkvqpIbN
         1u+w==
X-Gm-Message-State: AOAM532RGR5CncoVolv8heXAEPrXLh2J53DqQjvisWNt4Sn6kMvYOxrx
        vRUsOEB6WGDku5H5jNwWzYY=
X-Google-Smtp-Source: ABdhPJx5BORiKOuVbqxOfWSJu/byHdevMCTXImzbHScfwXHueRyNl+rohYwVY2sGsAXJEUdxUeTmxg==
X-Received: by 2002:a62:1b96:0:b029:164:5161:e393 with SMTP id b144-20020a621b960000b02901645161e393mr462163pfb.7.1604547900680;
        Wed, 04 Nov 2020 19:45:00 -0800 (PST)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id nv7sm173305pjb.27.2020.11.04.19.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 19:44:59 -0800 (PST)
Subject: Re: [PATCH 1/1] target_core_user: make Bodo maintainer
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bostroesser@gmail.com>
References: <1604521666-16573-1-git-send-email-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8b44ced8-b9ae-8e28-ef36-42ab4fea0d41@acm.org>
Date:   Wed, 4 Nov 2020 19:44:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604521666-16573-1-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/20 12:27 PM, Mike Christie wrote:
> +SCSI TARGET CORE USER DRIVER
> +M:	Bodo Stroesser <bostroesser@gmail.com>
> +L:	linux-scsi@vger.kernel.org
> +L:	target-devel@vger.kernel.org
> +S:	Supported
> +F:	Documentation/target/tcmu-design.rst
> +F:	drivers/target/target_core_user.c
> +F:	include/uapi/linux/target_core_user.h

Assuming this patch will be accepted: congratulated Bodo!

Bart.
