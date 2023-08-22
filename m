Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59AFEE49A3
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 07:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbjHVHLH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 03:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbjHVHLE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 03:11:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDBEE57;
        Tue, 22 Aug 2023 00:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1830762A66;
        Tue, 22 Aug 2023 07:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAFBC433C8;
        Tue, 22 Aug 2023 07:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692688208;
        bh=PdFf7mr6N7Lhr++kPIiLySdD1Jp9nSryKZaxtvYH8+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aa4A5YNz02YIAwq4GNMlp+tJ8FLcP83jyno8eDgL/qvZQ6jIcAjjNjMOmOd39CZ/p
         FTJd9cHuBO8uZaYrk9/sXNpcmd09sV4RA82jhgwWmz/8Lb0HkVFKqzJYr2tvtikd9X
         XFe+zDlLUTg3GPqFxPZO/4KKoX5SqvI4H13+0fbk4902yHivD78MzwX73s+qhKnqOJ
         DZq6VdWEc2I4ve39m8+hwn+PWMuiSeCwW0mNy1UKgQG49iEl+5Pe349G1/pkPqZCSY
         DO7GM5+kFsZ8Ww1SwV4vPa4nPXZ9teqSu07kh5tVTy/zw+Gx+0bfM8OO8UBY/WWjC5
         k5FxmsJcvTjJA==
Date:   Tue, 22 Aug 2023 12:39:52 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Nitin Rawat <quic_nitirawa@quicinc.com>
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, robh+dt@kernel.org,
        avri.altman@wdc.com, cros-qcom-dts-watchers@chromium.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH V1 1/2] scsi: ufs: qcom: dt-bindings: Add SC7280
 compatible string
Message-ID: <20230822070952.GB24753@thinkpad>
References: <20230821094937.13059-1-quic_nitirawa@quicinc.com>
 <20230821094937.13059-2-quic_nitirawa@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230821094937.13059-2-quic_nitirawa@quicinc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 21, 2023 at 03:19:36PM +0530, Nitin Rawat wrote:
> Document the compatible string for the UFS found on SC7280.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>

Acked-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> index bdfa86a0cc98..861bbf6a57f6 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> @@ -27,6 +27,7 @@ properties:
>            - qcom,msm8996-ufshc
>            - qcom,msm8998-ufshc
>            - qcom,sa8775p-ufshc
> +          - qcom,sc7280-ufshc
>            - qcom,sc8280xp-ufshc
>            - qcom,sdm845-ufshc
>            - qcom,sm6350-ufshc
> @@ -111,6 +112,7 @@ allOf:
>              enum:
>                - qcom,msm8998-ufshc
>                - qcom,sa8775p-ufshc
> +              - qcom,sc7280-ufshc
>                - qcom,sc8280xp-ufshc
>                - qcom,sm8250-ufshc
>                - qcom,sm8350-ufshc
> --
> 2.17.1
> 

-- 
மணிவண்ணன் சதாசிவம்
