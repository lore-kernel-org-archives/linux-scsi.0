Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3477ECD37BC
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Sep 2023 14:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjIPOZu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Sep 2023 10:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236221AbjIPOZ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Sep 2023 10:25:29 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC20122
        for <linux-scsi@vger.kernel.org>; Sat, 16 Sep 2023 07:25:24 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-68fba57030fso2871715b3a.3
        for <linux-scsi@vger.kernel.org>; Sat, 16 Sep 2023 07:25:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694874324; x=1695479124;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dMX2h1mBU8KfRCC4ogcAZEljZobpy+rCpPGJCpmHIeU=;
        b=r5sAzM1FH3n0zfF+Q1ycvvmMI7Xr+athMfLDr8GBllcMmTybwOdGMj9t3SottV60oU
         eV1/AgFOmK7TFV/z/ap0r5D3zr/cl6Tts6auQ1m+4xLQL0OcHHL8HjoLpkAoyR5y19cV
         zBG3fX20YON3HkSlc00SDxXrtwiS2xsE3l6BCyrU8jn9G1EJWohSXLweEunHoDCiEQeB
         Jd1/6rBWTq1aORVasy9Zo9nBtpxE0H6sgt9wIbTPcJvzaUWTFM2UjVqdVQT9S3oJ4dSa
         Q1ETBtbZgsyF3usYiFG3iVyBOY+8VfrVZtvEP2PQVrDnqluJwXe+hYQ75KRoZC9KrDM8
         ZBbA==
X-Gm-Message-State: AOJu0YwK7cFONF1RvsrUg2hAVZzxN+w3lvo6UT3/lSMru8tiT3O2Mmey
        +gE9X0DZIqd/+dce/UEhrLs=
X-Google-Smtp-Source: AGHT+IHWMV+R10BQ+k2wdPnytSLNPRoweAYyeQl/pMzx0QKb2cQW8i/a55QdHbbkGb1DPtuRYaYh9g==
X-Received: by 2002:a05:6300:8089:b0:14c:4deb:7189 with SMTP id ap9-20020a056300808900b0014c4deb7189mr4442805pzc.26.1694874323773;
        Sat, 16 Sep 2023 07:25:23 -0700 (PDT)
Received: from ?IPV6:2601:647:5f00:5f5:4a46:e57b:bee0:6bc6? ([2601:647:5f00:5f5:4a46:e57b:bee0:6bc6])
        by smtp.gmail.com with ESMTPSA id e5-20020a62ee05000000b0068620bee456sm4546750pfi.209.2023.09.16.07.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Sep 2023 07:25:23 -0700 (PDT)
Message-ID: <7baca11a-7188-4b33-bcbe-f716140d3a8b@acm.org>
Date:   Sat, 16 Sep 2023 07:25:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Do no try to probe for CDL on old drives
To:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>
References: <20230915022034.678121-1-dlemoal@kernel.org>
 <5b0c1aa5-b41b-46f9-af5a-9cf2a325ae95@acm.org>
 <4cb46bbe-3b42-d8a0-d9a0-d40567633c44@kernel.org>
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4cb46bbe-3b42-d8a0-d9a0-d40567633c44@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/23 15:21, Damien Le Moal wrote:
> In any case, such a change is outside the scope of this patch and
> should be a followup.

That sounds fair to me. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
