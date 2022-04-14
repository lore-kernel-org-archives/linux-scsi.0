Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA982C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Apr 2022 07:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbiDNHyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Apr 2022 03:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240474AbiDNHyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2022 03:54:22 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D3F377F7
        for <linux-scsi@vger.kernel.org>; Thu, 14 Apr 2022 00:51:58 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z99so5302230ede.5
        for <linux-scsi@vger.kernel.org>; Thu, 14 Apr 2022 00:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4kA3CM2rqbmneB8L2UH1I3TcMQuTf5ivjchAoMqbX7U=;
        b=x3EmNIl39+e060P3gumsTLBwQ/dYp5pzbB8c9v6xqbd9tPLnuQwxOwOpuCx/0b9HRg
         XDYlj9eut824d9ZK2O1rXfgSacT517UotlzV6646kvrpdm9RbBzMokpzEL3kxZ3/kSIs
         Ko/yz6scKpqOVk9BuV5YoHTBhAAV/r+MpzIBhlMa5nP09ao8C2k/dV5iT6P++V734EYQ
         eoNwqRnF/6o5j8VQkL0Y/O61t0s27qvT4wJQ2XRhvqEdDAeQy+PkTqxC0icPgIhNnua1
         6blTx/E1YKCHJd89Az7mazOLDQq/ECeuTs+7xPcLhe6WaSHolaHJeeRim3vD/b/AyyT8
         Ce5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4kA3CM2rqbmneB8L2UH1I3TcMQuTf5ivjchAoMqbX7U=;
        b=0vPgF48Jog1mpDY13XnO1k4GAMta9g9lwiMGrJrxoyiykmxI7hSaX6Go4K6Oxwd7Wq
         kNOkqfbhm08EfeUNYf/GOl+yT9fF7Ax89Nd8THmvt6OtZ1Qo1SGxPZiXhbHZK2+sHS4F
         3xWC99oNiuJ/kippej3xp3GOguXbUd8dV+7haBXBVdFtIVccc1iWXJs+5+lsw6D/Zvbz
         CITINhgA67SbLAeQkW12lrmwOjxHe7jnDsKxijrZ/5Y+77oSHiES89fb77jRAdYZig8N
         fenTpUnmmI8KDA6N1Nd4p0rkAecuoFwP6zMI7+oCsL27WIlXCH1ASOjHMQphHF15iMOx
         +2Sg==
X-Gm-Message-State: AOAM532OxV5GgMAdGmlTUm0JTT7GTBJeRD0NNe6AUZJypjCriB2cs8Vi
        0RYLnYnSc/9C3JXhCTjg4mAJVQ==
X-Google-Smtp-Source: ABdhPJyQHEbyUkRlPGNxcTF+ftkjVPdnxvbiROEmFI7FfJTEOfPhnkdz2kLA7/nMBMeanSfXPrNSnw==
X-Received: by 2002:a05:6402:128f:b0:41d:7e85:8421 with SMTP id w15-20020a056402128f00b0041d7e858421mr1616661edv.352.1649922717401;
        Thu, 14 Apr 2022 00:51:57 -0700 (PDT)
Received: from [192.168.0.209] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id lg4-20020a170906f88400b006e869103240sm378635ejb.131.2022.04.14.00.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 00:51:57 -0700 (PDT)
Message-ID: <61be2078-1b3a-4049-6b14-5947ea64cf33@linaro.org>
Date:   Thu, 14 Apr 2022 09:51:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/7] dt-bindings: ufs: Document Renesas R-Car UFS host
 controller
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, robh+dt@kernel.org,
        krzk+dt@kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20220414023115.4190736-1-yoshihiro.shimoda.uh@renesas.com>
 <20220414023115.4190736-2-yoshihiro.shimoda.uh@renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220414023115.4190736-2-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/04/2022 04:31, Yoshihiro Shimoda wrote:
> Document Renesas R-Car UFS host controller for R-Car S4-8 (r8a779f0).
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  .../devicetree/bindings/ufs/renesas,ufs.yaml  | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/renesas,ufs.yaml
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
