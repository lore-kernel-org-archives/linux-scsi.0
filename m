Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CE816C697;
	Thu,  8 Aug 2024 05:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723094990; cv=none; b=GlAw5Uni2Lq3UjDFF9tKnvjWxGbwlIUqwpbPrAUre0mf4Fh2qXU6KU0raGY4p1I8psMDHxJ2aLBRmjxp072pik46C9/fTqbBdfSPE+DrH/SNiPedVc0Hb9DGVHZ+P7MkiXycHX3KmsbmLVa34/J4afDzBa4Z0t/s0ysPZVJUdZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723094990; c=relaxed/simple;
	bh=k1asoSN3ZcnhJ7YFF5EGFbIiXfRPenkQjLfVfwhmoos=;
	h=Date:Content-Type:MIME-Version:From:To:Cc:In-Reply-To:References:
	 Message-Id:Subject; b=tNZ7rZX+9SjawRlt6Hx4xD7ZuDZsNEX5kiBLOrukx9FxIh6DuoJCh/thB03sLBltbQ/3a08Fhf1c0SrBHbLsplMZJPY3bIjQkVGWOHRQlhVEs5zvMNPJ1awcvuNzy0vFb8R5VPD3KN1XCYNKno9GVzpSTnKIZqFHZ+/OdWtiGBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhZ5Rjd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhZ5Rjd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E3FC32782;
	Thu,  8 Aug 2024 05:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723094989;
	bh=k1asoSN3ZcnhJ7YFF5EGFbIiXfRPenkQjLfVfwhmoos=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=NhZ5Rjd2r53e2BoQdl2rEDVB1zYrc0LsZZ78wMuMOO7371x/+NkFLHtn/FTuQMjy8
	 Ai4Cp5P7UkrgcsJXlhoiPnlRPsnDoz3NevClA24HJoWMq9dasX1zsVIiPe4Sr1enZa
	 fLYMZakgOe2U0BSudBFsgvB7NjV37rlH17P0A8C25gqFs1KEEqtzwez2nE+E7Uc8xu
	 dKLx3yVN6YWCaJLqKLK2OtYYq20uXaE8UNp+Js/ultwd/Q7qA1VRtqQcgP0HH19EMB
	 ca6ILfw9uI2t1bGiwarlkmN+KlLFuvALIxsMUAKywga83YSXKS1vdkzItZipMfqYe7
	 qdwi0jJPAeMuA==
Date: Wed, 07 Aug 2024 23:29:48 -0600
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: linux-rockchip@lists.infradead.org, Liang Chen <cl@rock-chips.com>, 
 Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 Conor Dooley <conor+dt@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
 YiFeng Zhao <zyf@rock-chips.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 devicetree@vger.kernel.org, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Heiko Stuebner <heiko@sntech.de>, Avri Altman <avri.altman@wdc.com>, 
 linux-scsi@vger.kernel.org
In-Reply-To: <1723089163-28983-3-git-send-email-shawn.lin@rock-chips.com>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-3-git-send-email-shawn.lin@rock-chips.com>
Message-Id: <172309498853.3975217.8775988957925335272.robh@kernel.org>
Subject: Re: [PATCH v2 2/3] dt-bindings: ufs: Document Rockchip UFS host
 controller


On Thu, 08 Aug 2024 11:52:42 +0800, Shawn Lin wrote:
> Document Rockchip UFS host controller for RK3576 SoC.
> 
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> 
> ---
> 
> Changes in v2:
> - renmae file name
> - fix all errors and pass the dt_binding_check:
>   make dt_binding_check DT_SCHEMA_FILES=rockchip,rk3576-ufs.yaml
> 
>  .../bindings/ufs/rockchip,rk3576-ufs.yaml          | 96 ++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml: $id: Cannot determine base path from $id, relative path/filename doesn't match actual path or filename
 	 $id: http://devicetree.org/schemas/ufs/rockchip,ufs.yaml
 	file: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.yaml
Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.example.dts:24:18: fatal error: dt-bindings/clock/rockchip,rk3576-cru.h: No such file or directory
   24 |         #include <dt-bindings/clock/rockchip,rk3576-cru.h>
      |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
make[2]: *** [scripts/Makefile.lib:427: Documentation/devicetree/bindings/ufs/rockchip,rk3576-ufs.example.dtb] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/builds/robherring/dt-review-ci/linux/Makefile:1430: dt_binding_check] Error 2
make: *** [Makefile:240: __sub-make] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/1723089163-28983-3-git-send-email-shawn.lin@rock-chips.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

