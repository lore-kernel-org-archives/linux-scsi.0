Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E0BC64EC7
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 04:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjBIEck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 23:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjBIEb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 23:31:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72B940BC0;
        Wed,  8 Feb 2023 20:31:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26D0AB81FDE;
        Thu,  9 Feb 2023 04:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F6FC4339C;
        Thu,  9 Feb 2023 04:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675916491;
        bh=V1yFiOFLlUiCMYYtK9uwh/w8LtamDdLjpjdOHa7EpeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1gb/Fe033U8pNmoeNp47b021CVR7cFQW+BDbhCzWer7d9d9cs7Eaew6TK3z97RFt
         3Kkhy4gkebLOGTcO0l0Bg/oRHfbvzAwtOt/dI2lt2Uke2KQmrdqt+MQRYYTXuzzV/J
         DzIaCF6MuskcueRlghpIS7C66NcspCovqZoG4rHYiW9tso7G9CltpFsglBT/wwYI7X
         3TuC23edCifmC4A4zG1ektWBiS+6IAU9DGt6Ol2xK5To1vOb/cRLIPKL4aFv5zHd89
         sqckJ7955WOqnirTl3ZOGrFPaSf0o18yCu+k8zfVP+F8sWGFIdB1HdW3288YG+6XIR
         AhiPVlpDDyrRg==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Andy Gross <agross@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: (subset) [PATCH 0/2] arm64/msm8996: enable UFS interconnect
Date:   Wed,  8 Feb 2023 20:22:48 -0800
Message-Id: <167591660365.1230100.15614374850514931090.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230119144326.2492847-1-dmitry.baryshkov@linaro.org>
References: <20230119144326.2492847-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Jan 2023 16:43:24 +0200, Dmitry Baryshkov wrote:
> MSM8996 requires a vote on UFS interconnects to work in a stable manner.
> The first patch is a rework of older patch from Brian, see [1]
> 
> [1] https://lore.kernel.org/all/20221117104957.254648-2-bmasney@redhat.com/
> 
> Brian Masney (1):
>   scsi: ufs: ufs-qcom: add basic interconnect support
> 
> [...]

Applied, thanks!

[2/2] arm64: dts: qcom: msm8996: enable UFS interconnects
      commit: bc72f13e4456afa34ccbd1dfc61aaea18f877b88

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
