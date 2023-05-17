Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2C7C7EE2A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 05:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjEQFle (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 01:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjEQFlc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 01:41:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8D61728;
        Tue, 16 May 2023 22:41:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E81D64209;
        Wed, 17 May 2023 05:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5AAC433D2;
        Wed, 17 May 2023 05:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684302090;
        bh=eaW7TtDlCkk3TQHk49qcxVBWo9XRtdT3QMda3V2KuUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k8/O3n52y2l02vvPDz4V5KTECiGq2pMxqf+oPdCEazc14sKqHDD7XE67NjCnLyzxB
         DC/mp7awBlFw3lTBdmomEbNKOLn5Ud1ZBNFpi1WZ8nwYfnil0u6H4XVgzpdPpb9OXi
         xACGXsF5HzwCoknWJZK77TTbUQ5RtQZu7cU9g9FhHle0jIXdw7C3I0200DRZ/H9M+q
         YfBp9Q81q5HOB3dgxrHDsk5GREUP/479ETwSMi/oD6MSb2D8ajzo+H6Mb+FB8UUvff
         ywtQr2IclG2qEuRMgOdozJEVPuMXarh1cze1l5zMv476/NRwTsirFzm+yWHDvEBjHZ
         bcFm9MhH4ExWw==
Date:   Wed, 17 May 2023 11:11:19 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH] arm64: dts: qcom: sa8775p: mark the UFS controller as
 dma-coherent
Message-ID: <20230517054119.GG4868@thinkpad>
References: <20230515121908.303432-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230515121908.303432-1-brgl@bgdev.pl>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 15, 2023 at 02:19:08PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> The UFS is cache coherent, so mark it as such in the dtsi.

UFS controller

> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  arch/arm64/boot/dts/qcom/sa8775p.dtsi | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> index c5e2e3256bc4..c0717dac100c 100644
> --- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
> @@ -605,6 +605,7 @@ ufs_mem_hc: ufs@1d84000 {
>  			power-domains = <&gcc UFS_PHY_GDSC>;
>  			required-opps = <&rpmhpd_opp_nom>;
>  			iommus = <&apps_smmu 0x100 0x0>;
> +			dma-coherent;
>  			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
>  				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
>  				 <&gcc GCC_UFS_PHY_AHB_CLK>,
> -- 
> 2.39.2
> 

-- 
மணிவண்ணன் சதாசிவம்
