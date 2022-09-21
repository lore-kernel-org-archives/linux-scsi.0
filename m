Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E55ECAAD8
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Sep 2022 14:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiIUOAG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Sep 2022 10:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiIUN7s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2022 09:59:48 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCBA85AB7;
        Wed, 21 Sep 2022 06:59:10 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id p18so5741177plr.8;
        Wed, 21 Sep 2022 06:59:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=XcrH19rkVkrzaIEdLr1nJOEgaNcx3faC+s92DUduPqk=;
        b=hE2c9DMooRXpSNFD1KneZwNWLmPJ8xVyj+7qAHpkSA/mtAqBWnvcv31l8TNp7IYh1F
         4ysi0r3/ygFuW7dOZeXgCE32HNKKzZIvQAREsx/x1O3LlZc1BVm5KYPdnx4Ux/2cUGyv
         OoKxI3cV1x4lKyccZsHeBWrvwakOY6oNuMsqZaN4J+MICn/UqP6jtOOnEAUaSC1Gsh8y
         GWk9+YJ6JuwUdfDrp0VQYLdPZuBLpCs0qmxzYDGd+5kk2cbCwDsINSY3d8HfYJ3gNkzp
         KNxLfLgIr/dBI4Nqs0VhzXojXTw0exYh/V9Ld6Fh0OtpYt18tSzhftUm6f8Fr0445V6H
         ZEvQ==
X-Gm-Message-State: ACrzQf0TFE87PiV0oNHOCZ3HKmf85+/xdRtM8mh3MqtD9h5VRu9us7bD
        /4nIwiZKlrOCAcBTGgMIox8=
X-Google-Smtp-Source: AMsMyM4yJW6okjrqzTegmVWGzcvp8/Ui57uAp7IyEAXUrUXvQ5UGb9vl+nrXHWlQrpeWdoxBRwHsLw==
X-Received: by 2002:a17:902:7c05:b0:178:1f92:288e with SMTP id x5-20020a1709027c0500b001781f92288emr4859560pll.92.1663768749275;
        Wed, 21 Sep 2022 06:59:09 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id b7-20020a170903228700b0016c78f9f024sm2106648plh.104.2022.09.21.06.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 06:59:08 -0700 (PDT)
Message-ID: <cbe64efd-9fef-70a7-898b-995acfd2f88e@acm.org>
Date:   Wed, 21 Sep 2022 06:59:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] scsi: ufs: Remove redundant function definitions from
 ufshcd.h
Content-Language: en-US
To:     Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        martin.petersen@oracle.com
Cc:     -cc=avri.altman@wdc.com, Avi.Shchislowski@wdc.com,
        beanhuo@micron.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1663761485-2532-1-git-send-email-Arthur.Simchaev@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1663761485-2532-1-git-send-email-Arthur.Simchaev@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/21/22 04:58, Arthur Simchaev wrote:
> v1->v2: Remove redundant comment, modify commit message
> 
> This patch removes Query-Request API functions declaration from
> include/ufs/ufshcd.h. Those declarations solely to
> ufs core private header.
> 
> Signed-off-by: Arthur Simchaev <Arthur.Simchaev@wdc.com>
> Reviewed-by: Bean Huo <beanhuo@micron.com>

The changelog (v1->v2) should occur under the three hyphens (---) and 
Reviewed-by tags should occur before the Signed-off-by tag.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
