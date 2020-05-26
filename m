Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9302C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 18:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8EDC2065F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590516530;
	bh=imWs4ah6WzLsF7HUgbEz+ghYEeQx18mGuyl9PlBOMCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=W0qDVgHULZna2Vq9JPT7l6yiPvYVmhWOMEWD0tay2odRGPDN+AsmK318EvgR3LQ8i
	 cQUL9y+4zRMBmQHUOe82h7w/bvu6fejTBkSf22JTJ5TJhyDkA6pjCG4zRe6X2TXqvN
	 ShapnkMtJVevUw241j+KX2ihnKwd5DMKKHmTWaAM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgEZSIr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 14:08:47 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39841 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgEZSIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 14:08:47 -0400
Received: by mail-io1-f65.google.com with SMTP id c8so2715548iob.6;
        Tue, 26 May 2020 11:08:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ShRmryyfPituzUaTF9xqzITMDWyV5MMJxj9+4c5azDc=;
        b=C9KvwuUFntPN9VrbKhVQfdEmBoI2rw0FpghH97V6yw5WLmTMue7Iob6YgwtUUfkRiw
         3tXPuOehPOp57Of2WnEElaRiK/fHBWkuV5+lzJ2TNT6YwJaoY0OmSAnPASYsCP3ITQWf
         iConQqnkMMzvXE0MNNWAGqHSaCl8bv/xJYPaoRZIxkD/lcYuNOTw4f9NfkgUdzCtiwi8
         hhOPYxJIUhnU5HSPP5aKURMIWWCrGyrIgHRssH7e5+ZaDUvXF+QXz6kYzj0fi5LFVsGi
         qdduB1650U4d0+P1kn3uEMeVnJI/EKq6RQuzbUuE2z6wswqaot9XQerAvhrLnbm/vt8E
         k8NQ==
X-Gm-Message-State: AOAM532IqvSsAgHSDp4oFfc8m2FOeiAWDkeVjlqiYtkilK7MHduLsYFU
        MPGs4Z8vEbBx8YeppO5gNA==
X-Google-Smtp-Source: ABdhPJw3FHEFautJYIk4tPlQQMhfWPm80jnVw4i0iIIULhGB0bIvWnQ4K1CyzKMAwU5hjhBOO6TKQA==
X-Received: by 2002:a05:6602:134d:: with SMTP id i13mr18153812iov.50.1590516525215;
        Tue, 26 May 2020 11:08:45 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id z13sm324592ilh.82.2020.05.26.11.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 11:08:44 -0700 (PDT)
Received: (nullmailer pid 91004 invoked by uid 1000);
        Tue, 26 May 2020 18:08:43 -0000
Date:   Tue, 26 May 2020 12:08:43 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 08/10] dt-bindings: ufs: Add DT binding documentation
 for ufs
Message-ID: <20200526180843.GA81537@bogus>
References: <20200514003914.26052-1-alim.akhtar@samsung.com>
 <CGME20200514005309epcas5p3ccd2b44c1bf20634eea3e232d1c2b62e@epcas5p3.samsung.com>
 <20200514003914.26052-9-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514003914.26052-9-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 14, 2020 at 06:09:12AM +0530, Alim Akhtar wrote:
> This patch adds DT binding for samsung ufs hci

Subject should indicate this is for Samsung in some way.

> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  .../bindings/ufs/samsung,exynos-ufs.yaml      | 91 +++++++++++++++++++
>  1 file changed, 91 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> 
> diff --git a/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> new file mode 100644
> index 000000000000..eaa64cc32d52
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
> @@ -0,0 +1,91 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/samsung,exynos-ufs.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Samsung SoC series UFS host controller Device Tree Bindings
> +
> +maintainers:
> +  - Alim Akhtar <alim.akhtar@samsung.com>
> +
> +description: |
> +  Each Samsung UFS host controller instance should have its own node.
> +  This binding define Samsung specific binding other then what is used
> +  in the common ufshcd bindings
> +  [1] Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +
> +properties:
> +
> +  compatible:
> +    enum:
> +      - samsung,exynos7-ufs
> +
> +  reg:
> +    items:
> +     - description: HCI register
> +     - description: vendor specific register
> +     - description: unipro register
> +     - description: UFS protector register
> +
> +  reg-names:
> +    items:
> +      - const: hci
> +      - const: vs_hci
> +      - const: unipro
> +      - const: ufsp
> +
> +  clocks:
> +    maxItems: 2

maxItems is redundant.

> +    items:
> +      - description: ufs link core clock
> +      - description: unipro main clock
> +
> +  clock-names:
> +    maxItems: 2

Here too.

> +    items:
> +      - const: core_clk
> +      - const: sclk_unipro_main
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  phys:
> +    maxItems: 1
> +
> +  phy-names:
> +    maxItems: 1

What's the name? (Though a name is kind of pointless when there is only 
1.)

With those fixed,

Reviewed-by: Rob Herring <robh@kernel.org>

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - phys
> +  - phy-names
> +  - clocks
> +  - clock-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/exynos7-clk.h>
> +
> +    ufs: ufs@15570000 {
> +       compatible = "samsung,exynos7-ufs";
> +       reg = <0x15570000 0x100>,
> +             <0x15570100 0x100>,
> +             <0x15571000 0x200>,
> +             <0x15572000 0x300>;
> +       reg-names = "hci", "vs_hci", "unipro", "ufsp";
> +       interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
> +       clocks = <&clock_fsys1 ACLK_UFS20_LINK>,
> +                <&clock_fsys1 SCLK_UFSUNIPRO20_USER>;
> +       clock-names = "core_clk", "sclk_unipro_main";
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
> +       phys = <&ufs_phy>;
> +       phy-names = "ufs-phy";
> +    };
> +...
> -- 
> 2.17.1
> 
