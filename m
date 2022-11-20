Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66AC2C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Nov 2022 16:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiKTQtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Nov 2022 11:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiKTQtI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Nov 2022 11:49:08 -0500
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E79413E1E;
        Sun, 20 Nov 2022 08:49:07 -0800 (PST)
Received: by mail-oi1-f169.google.com with SMTP id v81so10423594oie.5;
        Sun, 20 Nov 2022 08:49:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53uEYpSA+4eoQGytR32S8grohfFXG49rcIylHhuzFj8=;
        b=A+B1SD5W5RHMMKs8C/Oy2sqHs1mqXFzmtAGRxcbMECE9QyAclBhVtdYMzJgMBBESnP
         9JSKsss120EQXRQgFUmBq5HQrQNW0ELT5Iw1Wv245K6OlZUHiB1M8osgv0qBhDkdimmR
         ZNBN0KMi5t5ogOTpd60nDYf86AxsMTAwS3w5o5RoP0OENHiinlpMyDhDbjMJsmoG/1F7
         xzm7o+EXj8qGNYWqV07z4N0Eb8t/p+x/xkzYdhp1uNtnzE5LomuP3emLpUlv1ewYJWqH
         TV8TyuvZdy6KmsgJNvRKxXOpZF99TqjLarNqFEP20hHXZkz7l6YDpdMVo97+wVSnztMh
         2SUA==
X-Gm-Message-State: ANoB5plOCDECALf4yHOa6pygdz4/v9pjxnVZ6K9Z75mTJ17qtLEhvJMx
        uk631KIa+sz78cRbuz0z6Q==
X-Google-Smtp-Source: AA0mqf7x6qnZPCjOM9cXRy24E90vfPYfyfopCFQ0GLp/jBjyQctgIwLUHd8hzrLRpgDhzANMJxzJBw==
X-Received: by 2002:a05:6808:5c4:b0:35a:4aed:5904 with SMTP id d4-20020a05680805c400b0035a4aed5904mr10131960oij.198.1668962946663;
        Sun, 20 Nov 2022 08:49:06 -0800 (PST)
Received: from robh_at_kernel.org ([2605:ef80:80f8:5cb3:df5a:23c3:86fb:15a6])
        by smtp.gmail.com with ESMTPSA id z12-20020a05687042cc00b0013ae39d0575sm4835620oah.15.2022.11.20.08.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 08:49:06 -0800 (PST)
Received: (nullmailer pid 3186692 invoked by uid 1000);
        Sun, 20 Nov 2022 16:49:07 -0000
Date:   Sun, 20 Nov 2022 10:49:07 -0600
From:   Rob Herring <robh@kernel.org>
To:     Zhe Wang <zhe.wang1@unisoc.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        krzysztof.kozlowski+dt@linaro.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, orsonzhai@gmail.com,
        yuelin.tang@unisoc.com, zhenxiong.lai@unisoc.com,
        zhang.lyra@gmail.com
Subject: Re: [PATCH v2 1/2] dt-bindings: ufs: Add document for Unisoc UFS
 host controller
Message-ID: <20221120164907.GA3183451-robh@kernel.org>
References: <20221116133131.6809-1-zhe.wang1@unisoc.com>
 <20221116133131.6809-2-zhe.wang1@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116133131.6809-2-zhe.wang1@unisoc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 16, 2022 at 09:31:30PM +0800, Zhe Wang wrote:
> Add Unisoc ums9620 ufs host controller devicetree document.
> 
> Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
> ---
>  .../bindings/ufs/sprd,ums9620-ufs.yaml        | 78 +++++++++++++++++++
>  1 file changed, 78 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml
> 
> diff --git a/Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml b/Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml
> new file mode 100644
> index 000000000000..ce9d05be1a6b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml
> @@ -0,0 +1,78 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/sprd,ums9620-ufs.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Unisoc Universal Flash Storage (UFS) Controller
> +
> +maintainers:
> +  - Zhe Wang <zhe.wang1@unisoc.com>
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +properties:
> +  compatible:
> +    const: sprd,ums9620-ufs
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 4
> +
> +  clock-names:
> +    items:
> +      - const: ufs_eb
> +      - const: ufs_cfg_eb
> +      - const: ufsh
> +      - const: ufsh_source

Sounds like a parent clock to 'ufsh'? If so, it doesn't belong in 
'clocks'. Use the clock API to get the parent or use 
'assigned-clock-parents'.

Rob
