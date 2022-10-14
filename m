Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82051C43219
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Oct 2022 21:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJNV2Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 17:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJNV2X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 17:28:23 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48A8C09A5;
        Fri, 14 Oct 2022 14:28:22 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1324e7a1284so7331873fac.10;
        Fri, 14 Oct 2022 14:28:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8VDrG8gwWiSTL+8w326fUr7NJNMlWkK+uBEJMrv9dLE=;
        b=CxBEvHGDeCwYYKxgPbafeEo3a7D3melvuYOj6ZR+IixTmUdV728vpv3lI67AxIIuW5
         BzhGBpiphju7SgZqZl24OWmNUC4d/NhXbLgViKwIc96HcB0JfsW0OakdTS9v3Zxo8efH
         /GORaKjnQL6nMiLQaWapBtq3taOt/Lk0O0miUlLbLtmBiaOXFrs5e65bDcHDDljP7o50
         JaF21KFkq0oQhJBbaz8fVtwVRbN3Qfd9idBb39CbNA0vQS6vYu55ZiqB5PNkVI38Zr4t
         f2f8Jeproc7RsCfAFlHlAkYDOfmVh7yLfRZ3DKBAvL4IzarxPa33AB2S6KFZ6dJHVZIT
         CiCw==
X-Gm-Message-State: ACrzQf1dcVKX+nsuqCm4p0InVLWiOCo1JhxQubk9G826gkdfmbYkWVIm
        Hss2icqEzRZcl49kljGMXw==
X-Google-Smtp-Source: AMsMyM7qrSv9+CDGloU5Hq3jf9lh0GGMGCkyV0sSOJsdTgoMBsbPNUaD8dDfE17wid9x0U6VhXSLbA==
X-Received: by 2002:a05:6870:9599:b0:132:f754:4ffa with SMTP id k25-20020a056870959900b00132f7544ffamr3826502oao.266.1665782901843;
        Fri, 14 Oct 2022 14:28:21 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r6-20020a056830418600b00661b6e1eb3csm1679537otu.38.2022.10.14.14.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:28:21 -0700 (PDT)
Received: (nullmailer pid 2932278 invoked by uid 1000);
        Fri, 14 Oct 2022 21:28:22 -0000
Date:   Fri, 14 Oct 2022 16:28:22 -0500
From:   Rob Herring <robh@kernel.org>
To:     Matt Ranostay <mranostay@ti.com>
Cc:     krzysztof.kozlowski+dt@linaro.org, linux-scsi@vger.kernel.org,
        vigneshr@ti.com, devicetree@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH] dt-bindings: ufs: cdns,ufshc: add missing dma-coherent
 field
Message-ID: <166578290097.2932204.9966446989931384399.robh@kernel.org>
References: <20221013194559.128643-1-mranostay@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013194559.128643-1-mranostay@ti.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 13 Oct 2022 12:45:59 -0700, Matt Ranostay wrote:
> Add missing dma-coherent property to schema which avoids the following warnings
> 
> ufs-wrapper@4e80000: ufs@4e84000: Unevaluated properties are not allowed ('dma-coherent' was unexpected)
> 
> Signed-off-by: Matt Ranostay <mranostay@ti.com>
> ---
>  Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Applied, thanks!
