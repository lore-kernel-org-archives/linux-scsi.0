Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F133DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 17:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D938360F02
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 17:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhJRR5G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 13:57:06 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:41829 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhJRR5F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 13:57:05 -0400
Received: by mail-ot1-f50.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so817368ote.8;
        Mon, 18 Oct 2021 10:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AGZT9xrjJpeyLfq3a3SqMyHfqwaQjNQCdOdYZvP4bKY=;
        b=zpJI8CvYzq+tCqR0cro9JBuIKQnXyHe53dOZs7FRvgbuLmLn64RVXEFYNqVWjZMqBs
         lAvv8dw1kBY0WePDoQ6Gsb82NEHoz+wE0zY8GNc0fWbhSG4IlZLvnmQXlhKfdQRBz8+O
         4xaUMRreQKJgBFew3tpjdDs+V/KVdHK33cF0cpIplrL/nHQXe839eGdK7L5uURkpY8SO
         LaQu2nOfR/3CtSW1uOKfuoS1PPSq6Wh2liPf+HQtxepRyIMCNVsfdTZAZ5J/tOWxIdz3
         ZMMfs8HximOfzau5ZS/Hjj/6eFLc0Iwj+BV0tbBGHf0wxVwrbemoLnmU9icG8BZ5jQ/x
         ccPQ==
X-Gm-Message-State: AOAM530LVKvHxTcn9yPlzrJ5RCPNY/krTFsS3FR30UtG/mrTe1Nm67LQ
        8CzpCGhVDYb36r8V1IZnhQ==
X-Google-Smtp-Source: ABdhPJz6Kvx85f5G3LHSK7EFuvtw3k6U3+4Dex/cfKTk5OEQWDH10HlMFDOWHvyhhoaiTp6BGoFXgQ==
X-Received: by 2002:a9d:458d:: with SMTP id x13mr1065443ote.290.1634579692544;
        Mon, 18 Oct 2021 10:54:52 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id e23sm3123509oih.40.2021.10.18.10.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 10:54:51 -0700 (PDT)
Received: (nullmailer pid 2653369 invoked by uid 1000);
        Mon, 18 Oct 2021 17:54:50 -0000
Date:   Mon, 18 Oct 2021 12:54:50 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        devicetree@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sowon Na <sowon.na@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Can Guo <cang@codeaurora.org>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v5 12/15] dt-bindings: ufs: exynos-ufs: add io-coherency
 property
Message-ID: <YW206ifr7v2Bt3mX@robh.at.kernel.org>
References: <20211018124216.153072-1-chanho61.park@samsung.com>
 <CGME20211018124506epcas2p25100e2163029de4ee8b8b87e7ff0f2a3@epcas2p2.samsung.com>
 <20211018124216.153072-13-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018124216.153072-13-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2021 21:42:13 +0900, Chanho Park wrote:
> Add "samsung,sysreg" regmap and the offset to the ufs shareability
> register for setting io coherency of the samsung ufs. "dma-coherent"
> property is also required because the driver code needs to know.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  .../devicetree/bindings/ufs/samsung,exynos-ufs.yaml       | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
