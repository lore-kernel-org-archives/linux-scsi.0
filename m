Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8727C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 16:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380396AbiDTQM0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 12:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240259AbiDTQMZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 12:12:25 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B56731DEC;
        Wed, 20 Apr 2022 09:09:39 -0700 (PDT)
Received: by mail-oi1-f169.google.com with SMTP id 12so2533418oix.12;
        Wed, 20 Apr 2022 09:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OhCnw5qnNGBr1bA+KL7V/0FvwpAO5JS/JOmi7r/yJss=;
        b=x5sawBezj4U56kZiv6e1jl1Cu6MLDzUOUsQUWaICfmDUhWmJPubUoUOubr65qhpeyY
         R8z3+3hUCqkrP8zX+SHxaQNlAgjWP4L/L0p5yD6tnEsHYBnRaXXr+TOCrSFNWqQbu4pw
         06GqGoXl4CgaFBGRNzm6jtXSRzvr0eoqiDL8bsielnL05AIrFbvtiemItG3M0w2lTgpS
         v+pvw18jJ6U3sOt1zNnL0EH5gR64jR2pdGRerQBs+zuNVBYULGxGZrFrZPPEBF3REQmE
         Nx57zZJ0uKOIhouukXqAn8eYToJtwdQg++uDNFxLCSizyTysSuDopLQiEUoszhPzLk06
         4eaA==
X-Gm-Message-State: AOAM531vSyM9UIytu+rnXjaj4ti1uILbT9eVqPBZDKmOO5OaEdfKqQJn
        4rdJ7fQZSE7LOXAojKP3Uw==
X-Google-Smtp-Source: ABdhPJwdjzSx+B4IQhiW20q34pYPOPjx5/ed3l0Rl5JWfORxHRIysuIdOLr6VVCpYhxFUbsmgezb2Q==
X-Received: by 2002:a05:6808:1704:b0:2f9:bb17:21f6 with SMTP id bc4-20020a056808170400b002f9bb1721f6mr2027420oib.23.1650470978728;
        Wed, 20 Apr 2022 09:09:38 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z3-20020a056870d68300b000e2a0a74f9fsm141550oap.37.2022.04.20.09.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 09:09:38 -0700 (PDT)
Received: (nullmailer pid 1397324 invoked by uid 1000);
        Wed, 20 Apr 2022 16:09:37 -0000
Date:   Wed, 20 Apr 2022 11:09:37 -0500
From:   Rob Herring <robh@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     martin.petersen@oracle.com, alim.akhtar@samsung.com,
        linux-renesas-soc@vger.kernel.org, robh+dt@kernel.org,
        avri.altman@wdc.com,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        devicetree@vger.kernel.org, krzk+dt@kernel.org
Subject: Re: [PATCH v4 1/7] dt-bindings: ufs: Document Renesas R-Car UFS host
 controller
Message-ID: <YmAwQU6mutk/oyC7@robh.at.kernel.org>
References: <20220420025450.289578-1-yoshihiro.shimoda.uh@renesas.com>
 <20220420025450.289578-2-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420025450.289578-2-yoshihiro.shimoda.uh@renesas.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 Apr 2022 11:54:44 +0900, Yoshihiro Shimoda wrote:
> Document Renesas R-Car UFS host controller for R-Car S4-8 (r8a779f0).
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../devicetree/bindings/ufs/renesas,ufs.yaml  | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/renesas,ufs.yaml
> 

Acked-by: Rob Herring <robh@kernel.org>
