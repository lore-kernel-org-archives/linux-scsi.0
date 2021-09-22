Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F432C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 19:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08488611B0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 19:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbhIVT7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 15:59:35 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:45616 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhIVT7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 15:59:34 -0400
Received: by mail-ot1-f45.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso5127096otv.12;
        Wed, 22 Sep 2021 12:58:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iaPd+QHHmiMvOvCvDzF4J+PjNGw7QzM9uEOdU0ijBx0=;
        b=lmSUzZwKLoJbi3rV8b14ueTzvSARIS4af4soLPNuuJhDc27EYAF4AQCEwxM9qG4Ldh
         SNblY3E+Ti5x5q51TdLKUvqQI0QJJm2QI5dEG3h6sLV1pRn1FfIBfmH1dQnExZkjNaWy
         EyK1kNhtZk8C3U3APKnabrQCrmpQBaD7IXZOVfnLZwUJtwjktLZPVCZGIRqn06lJ9jw0
         ZRYKwZgjFp0JKPUHctXJldMcUq65m/H4988xC2qM5PjKqTwrMci6CKtIl53xUltQ6iki
         c9xd1xgB1hIgaKTw4/4rx0dj1YHIIRI/XzN3Uxq42D42uZwLk6t9THC87ZttVLIL55J3
         moxw==
X-Gm-Message-State: AOAM530WnV3Nb1xYiEUoSZc0iRzm3zsRmEi/QfJOsLdjYfhWCKyev3cM
        AJaDvQSv73T9JUfsmQWRVQ==
X-Google-Smtp-Source: ABdhPJxYtpvzhIoY0PLePCkbi+/RqQbnPjHxc6x38GmKt2lT/UdKaSb/wKAdy90Adwnkh1e3vG2yCw==
X-Received: by 2002:a9d:6092:: with SMTP id m18mr817222otj.215.1632340684146;
        Wed, 22 Sep 2021 12:58:04 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id q133sm244494oia.55.2021.09.22.12.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 12:58:03 -0700 (PDT)
Received: (nullmailer pid 1191863 invoked by uid 1000);
        Wed, 22 Sep 2021 19:58:02 -0000
Date:   Wed, 22 Sep 2021 14:58:02 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     devicetree@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-samsung-soc@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 17/17] dt-bindings: ufs: exynos-ufs: add exynosautov9
 compatible
Message-ID: <YUuKysgLBtB5jQv1@robh.at.kernel.org>
References: <20210917065436.145629-1-chanho61.park@samsung.com>
 <CGME20210917065524epcas2p455b2900227b6a20994bec4816248f2bf@epcas2p4.samsung.com>
 <20210917065436.145629-18-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917065436.145629-18-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 17 Sep 2021 15:54:36 +0900, Chanho Park wrote:
> Below two compatibles can be used for exynosautov9 SoC UFS controller.
> 
> - samsung,exynosautov9-ufs: ExynosAutov9 UFS Physical Host
> - samsung,exynosautov9-ufs-vh: ExynosAutov9 UFS Virtual Host
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
