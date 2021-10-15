Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C11C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 13:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FF5061090
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 13:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbhJONxI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 09:53:08 -0400
Received: from mail-oo1-f53.google.com ([209.85.161.53]:33442 "EHLO
        mail-oo1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236238AbhJONxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 09:53:07 -0400
Received: by mail-oo1-f53.google.com with SMTP id u5-20020a4ab5c5000000b002b6a2a05065so3021522ooo.0;
        Fri, 15 Oct 2021 06:51:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZtB0WkE/Lu4IlxTPR48eAN+WhkzmHbXHnEMt9T2roUI=;
        b=huNBTUtKdQUS22BYm3gSW1a1MNl7/l8hlEfcT+5A0OA8vvItlVFi/UK9BEOLKojRpD
         9HPn0+lpuFOTV7aTf2NkWk9ycl2PNnBehfdpEjeqWzYdFuFC27oxfdsc8Mdi8+TZ3UZd
         5CDy3D9pT4naUGrQtpl/RzocNmNJjoA78tUl/1J9Y/gP+Yabh988GhnK7+DRkyjtAuk9
         vwNvN7/MpsQ0teCdp/fZwL+cu/YGRtlukbQlzSC2krsvE/weagt69Cg28i7B1tgRQdj7
         rOkeLGhOOjm/DQVt29D6wBxPfiLWbnPB4muR4voNn46R51uBsyb6q/T0NgoDB8kCMH6T
         UKCw==
X-Gm-Message-State: AOAM532Z5TW4zLaKSV0z6v8gfy1HX8/YRv5XNVknBjHZDVa7Xhid0Tsn
        XcrXhbDzWg4mPR6oN9f8N9KxwHAwEw==
X-Google-Smtp-Source: ABdhPJypDm72yKy9VkOctsoOA3C2T2MPIY3sjyUSUpB7ucQTvL24O0xdWMN+sM9vZcTtx01k6MzztQ==
X-Received: by 2002:a4a:8c01:: with SMTP id u1mr8941557ooj.85.1634305860736;
        Fri, 15 Oct 2021 06:51:00 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id a15sm1358022oiw.53.2021.10.15.06.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 06:51:00 -0700 (PDT)
Received: (nullmailer pid 1426158 invoked by uid 1000);
        Fri, 15 Oct 2021 13:50:59 -0000
Date:   Fri, 15 Oct 2021 08:50:59 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 13/16] dt-bindings: ufs: exynos-ufs: add io-coherency
 property
Message-ID: <YWmHQ5CVQd97JzHJ@robh.at.kernel.org>
References: <20211007080934.108804-1-chanho61.park@samsung.com>
 <CGME20211007081135epcas2p2d577fc8dec75471cf42024eda6a45690@epcas2p2.samsung.com>
 <20211007080934.108804-14-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007080934.108804-14-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 07, 2021 at 05:09:31PM +0900, Chanho Park wrote:
> Add "samsung,sysreg" regmap and the offset to the ufs shareaibility
> register for setting io coherency of the samsung ufs. "dma-coherent"
> property is also required because the driver code needs to know.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  .../devicetree/bindings/ufs/samsung,exynos-ufs.yaml   | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> index b9ca8ef4f2be..d9b7535b872f 100644
> --- a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> @@ -54,6 +54,17 @@ properties:
>    phy-names:
>      const: ufs-phy
>  
> +  samsung,sysreg:
> +    $ref: '/schemas/types.yaml#/definitions/phandle'
> +    description: phandle for FSYSx sysreg interface, used to control
> +                 sysreg register bit for UFS IO Coherency
> +
> +  samsung,ufs-shareability-reg-offset:
> +    $ref: '/schemas/types.yaml#/definitions/uint32'
> +    description: Offset to the shareability register for io-coherency

Make these a single property: <phandle offset>

> +
> +  dma-coherent: true
> +
>  required:
>    - compatible
>    - reg
> -- 
> 2.33.0
> 
> 
