Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81542EE57EC
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Sep 2023 09:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbjIHJWq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Sep 2023 05:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242328AbjIHJWo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Sep 2023 05:22:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBC019B0;
        Fri,  8 Sep 2023 02:22:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDBBC433C7;
        Fri,  8 Sep 2023 09:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694164960;
        bh=oU2pawZYk5qOiGg3Bc3ivGcV0FuuszBz15T5UIwt3cY=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=gFaO6fEc2ciaECc1uW6gVknOghMUddCxh8TOQqgrrgP2ww/gIeYOXyi23WO28Q2Cj
         8x068K6WDjES2u0usV6f0fZXbOTdW7Sub8k6NWBpzevZHXRqvvedw/VRJUCtRS7uE6
         EhqRNOTv5M0AdIj3VyEyUx0wwQQlEA8osUw8XVoSnUBs3i7CIWMomZ4V9vFl+0s5vV
         L2zbeMpjjcCLXFaCTtOf1kV0BLKytEh6Tqy+cDqz59BKtv8Odt1EfuupkmCf1bOS3t
         4rHuLCON2HgnluQiFLnbO9pdGMxk/XaNidSx446Dxmmc74VxqC0Jd+PGY1DLCUZyBS
         kBEuyfq6mn7qg==
Received: (nullmailer pid 3429686 invoked by uid 1000);
        Fri, 08 Sep 2023 09:22:37 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Ziqi Chen <quic_ziqichen@quicinc.com>
Cc:     quic_cang@quicinc.com, quic_nguyenb@quicinc.com,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        mani@kernel.org, bvanassche@acm.org, devicetree@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        junwoo80.lee@samsung.com, Andy Gross <agross@kernel.org>,
        quic_asutoshd@quicinc.com, beanhuo@micron.com,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, martin.petersen@oracle.com,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        quic_nitirawa@quicinc.com, adrian.hunter@intel.com,
        avri.altman@wdc.com, Bjorn Andersson <andersson@kernel.org>
In-Reply-To: <1694163203-39123-1-git-send-email-quic_ziqichen@quicinc.com>
References: <1694163203-39123-1-git-send-email-quic_ziqichen@quicinc.com>
Message-Id: <169416495746.3429668.10365019045996473151.robh@kernel.org>
Subject: Re: [PATCH] scsi: ufs: qcom: dt-bindings: Add MCQ ESI property
Date:   Fri, 08 Sep 2023 04:22:37 -0500
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Fri, 08 Sep 2023 16:53:23 +0800, Ziqi Chen wrote:
> Document the description for the qcom,esi-affinity-mask.
> 
> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
> ---
>  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/ufs/qcom,ufs.yaml:102:8: [warning] wrong indentation: expected 6 but found 7 (indentation)

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml: properties:qcom,esi-affinity-mask: 'oneOf' conditional failed, one must be fixed:
	'type' is a required property
		hint: A vendor boolean property can use "type: boolean"
	/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml: properties:qcom,esi-affinity-mask: 'oneOf' conditional failed, one must be fixed:
		'enum' is a required property
		'const' is a required property
		hint: A vendor string property with exact values has an implicit type
		from schema $id: http://devicetree.org/meta-schemas/vendor-props.yaml#
	/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml: properties:qcom,esi-affinity-mask: 'oneOf' conditional failed, one must be fixed:
		'$ref' is a required property
		'allOf' is a required property
		hint: A vendor property needs a $ref to types.yaml
		from schema $id: http://devicetree.org/meta-schemas/vendor-props.yaml#
	hint: Vendor specific properties must have a type and description unless they have a defined, common suffix.
	from schema $id: http://devicetree.org/meta-schemas/vendor-props.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/1694163203-39123-1-git-send-email-quic_ziqichen@quicinc.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

