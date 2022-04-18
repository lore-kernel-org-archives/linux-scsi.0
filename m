Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4872EC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Apr 2022 11:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbiDRLwJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 07:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiDRLwI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 07:52:08 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C57319291
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 04:49:29 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t25so17174882edt.9
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 04:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Su46te7HNW++2zKgguxu+adMxrQIv2yQPrMKfptRGag=;
        b=Wow3Xq7cPhtHQfiCZO1z4xGsOQSgEraNXhtcAJR+p9ahYFh+UIfpwJjb9ewnX9N810
         rceUBq35zYdLxYRlbvVGzDAVGaBNZqCA7bMp1VlUs9QZ6WUuiqIgGTvoR8eEb5tutur7
         vpdfCjxVi4d6+oN10r4XW/BXHm619ZVAhb2OKaqFhHpDItUc7jJ/87xRjWkMwd3JCg3K
         +peY2iRIUzoCyGLAc4DXiMeFiV44Xqo1KgQLqu2oa60LUldbHs2aROrHQpSdhm+ChGa4
         ags2SP48yGsoglA5lbFxWFP+fqvxKXSxTlkAeJlp0Ipoc7eL32wrkSjftiXeUXauetrB
         NuKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Su46te7HNW++2zKgguxu+adMxrQIv2yQPrMKfptRGag=;
        b=Qu08XpasW54XPR12VyIuwEia4DTcaHLSzXVYWLJbzNHrTUaHa5I8aJwA4f7dZJvpGl
         nzeojzn7dSsMpSm++itwzJA6cHeOLtl4NkqrbI4v9yAKR/ch7bA+NOhWPWB0as4LjgTB
         bQIfkAsSLSS4F4r48g6miI1kcPwFDXLPcsgZndmuJ2q6U0YcmYUXhPHWWzpBQQrwygrm
         2zWPPgoLe3LoPengtAu8vLViehzZhlNpWPgsmG1PXXbiBPuLk8x3XxAwQQLJkD83MYvt
         1bA2vTC4wFLDUYbPZSueKvbLdgWa9CjTvQBrnRKdEiSXbAMwX6xGzp+cCNcP96pnAezB
         5z5A==
X-Gm-Message-State: AOAM533ZwkS8mxDIoFqe/7CDIzF+L9dYnOGYioIj2C3ykFY7mCvncck2
        REgca8y1cnceNbJ1ZdocrmV24Q==
X-Google-Smtp-Source: ABdhPJyjLcgXf19Bziy6YywbbTjReCFm8EmqOP+nJT4RSe4RjCjRYH99uE2rINOfOjdDhXQpbYrSpA==
X-Received: by 2002:a05:6402:2689:b0:422:15c4:e17e with SMTP id w9-20020a056402268900b0042215c4e17emr11945878edd.33.1650282567594;
        Mon, 18 Apr 2022 04:49:27 -0700 (PDT)
Received: from [192.168.0.217] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id t4-20020a1709067c0400b006ef810aab6fsm2338044ejo.213.2022.04.18.04.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 04:49:27 -0700 (PDT)
Message-ID: <fb275639-096e-78c2-3cbb-1bb10f4bbb08@linaro.org>
Date:   Mon, 18 Apr 2022 13:49:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] dt-bindings: ufs: mediatek,ufs: add compatible for
 MT8195 SoC
Content-Language: en-US
To:     Fabien Parent <fparent@baylibre.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220415165939.1861470-1-fparent@baylibre.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220415165939.1861470-1-fparent@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/04/2022 18:59, Fabien Parent wrote:
> Add bindings for the MT8195 UFS support.
> 
> The MT8195 SoC requires more clocks to be enabled compared to MT8183 and
> MT8192. Document the clocks required for MT8195.
> 
> Signed-off-by: Fabien Parent <fparent@baylibre.com>
> ---
>  .../devicetree/bindings/ufs/mediatek,ufs.yaml | 27 ++++++++++++++-----
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> index 32fd535a514a..5ed36e95e933 100644
> --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> @@ -14,16 +14,31 @@ allOf:
>  
>  properties:
>    compatible:
> -    enum:
> -      - mediatek,mt8183-ufshci
> -      - mediatek,mt8192-ufshci
> +    oneOf:
> +      - enum:
> +          - mediatek,mt8183-ufshci
> +          - mediatek,mt8192-ufshci
> +      - items:
> +          - const: mediatek,mt8195-ufshci
> +          - const: mediatek,mt8183-ufshci

Are you sure that these devices are compatible? Amount of clock
differences suggests that not (or original bindings were not complete).

>  
>    clocks:
> -    maxItems: 1
> +    minItems: 1
> +    maxItems: 8
>  
>    clock-names:
> -    items:
> -      - const: ufs
> +    oneOf:
> +      - items:
> +          - const: ufs
> +      - items:
> +          - const: ufs
> +          - const: ufs_aes
> +          - const: ufs_tick
> +          - const: unipro_sysclk
> +          - const: unipro_tick
> +          - const: unipro_mp_bclk
> +          - const: ufs_tx_symbol
> +          - const: ufs_mem_sub

Add allOf:if:then: which specifies these clocks per different compatible.

Best regards,
Krzysztof
