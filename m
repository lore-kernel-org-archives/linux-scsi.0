Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F741BDA86;
	Tue,  6 Aug 2024 10:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722939533; cv=none; b=hxoheS6zJsjpyM/EtzH6EsJvNf/n6qMd2V4c8KFhVJVkj6lBgY+UcafMv9e2Yp1P29X58OFW/OnYrURK3pcb2Ttc79lnw2wM3N5L2ipr660F54rxHHAxpdHPU0sSamWzKqwg9LhuPXM3I7kG2OuSwbGqdyUf/8A1281q3Vp+0Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722939533; c=relaxed/simple;
	bh=tF0qjnYximJMqHXdOuRBPd07BvDP+1RETk8lBbegNus=;
	h=Date:Content-Type:MIME-Version:From:To:Cc:In-Reply-To:References:
	 Message-Id:Subject; b=VhfWr5KjTxdxNHoMtzTrEU7tbX8c6DC3rdcYgABIx/Q1tBydEkTAJVjTaQkl+1sgG2VrnVqKouq377+zXfHe2rX7UpmE/Letjhcl6ZmEggGrxIibkqubiRANP0Mb8IqKRI4KVX9Sn52+4mqfrfS5rQfRdcIpQxaMyY6XkDgNgTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6teTVXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6teTVXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F15C32786;
	Tue,  6 Aug 2024 10:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722939532;
	bh=tF0qjnYximJMqHXdOuRBPd07BvDP+1RETk8lBbegNus=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=G6teTVXMpXkvXvwEm1eqcxD+f2dxW9AtJaoh1XUdCghJVgE9sD7g88FiFcf2I8jrn
	 Zi6RDeTm1vENbDa+4gm8tZLgBfHVke0nII/6kaI9kKiqrNUDy0Qg17VcQVbklrS8nt
	 2s2zr5cke7yRuR+Ue7vFKwNuuRk3sZ2+vFSY4/i33vl3oHuLQKDJ7PMv2GoAhM8r4J
	 ppR4vfsJSGfiANkhFhuoiZQbPw7HSG6z6QTw9UJehmgRbyVZfFRYoy1eKbiFPWgTqX
	 4mD+uzvgET5JeO6Xw7xCAb08Ej/Ob/QQ04+f6LM2ap8eJOyshfeWBpr/Sid8SF0Soc
	 Ckadafl7TQLHQ==
Date: Tue, 06 Aug 2024 04:18:51 -0600
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
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, linux-rockchip@lists.infradead.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 Bart Van Assche <bvanassche@acm.org>, Liang Chen <cl@rock-chips.com>, 
 devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>, 
 Rob Herring <robh+dt@kernel.org>, linux-scsi@vger.kernel.org, 
 YiFeng Zhao <zyf@rock-chips.com>
In-Reply-To: <1722928800-137042-3-git-send-email-shawn.lin@rock-chips.com>
References: <1722928800-137042-1-git-send-email-shawn.lin@rock-chips.com>
 <1722928800-137042-3-git-send-email-shawn.lin@rock-chips.com>
Message-Id: <172293953136.567331.12860236483720130246.robh@kernel.org>
Subject: Re: [PATCH v1 2/3] dt-bindings: ufs: Document Rockchip UFS host
 controller


On Tue, 06 Aug 2024 15:19:59 +0800, Shawn Lin wrote:
> Document Rockchip UFS host controller for RK3576 SoC.
> 
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> ---
> 
>  .../devicetree/bindings/ufs/rockchip,ufs.yaml      | 78 ++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml:24:6: [warning] wrong indentation: expected 6 but found 5 (indentation)
./Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml:65:1: [error] syntax error: found character '\t' that cannot start any token (syntax)

dtschema/dtc warnings/errors:
make[2]: *** Deleting file 'Documentation/devicetree/bindings/ufs/rockchip,ufs.example.dts'
Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml:65:1: found a tab character where an indentation space is expected
make[2]: *** [Documentation/devicetree/bindings/Makefile:26: Documentation/devicetree/bindings/ufs/rockchip,ufs.example.dts] Error 1
make[2]: *** Waiting for unfinished jobs....
./Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml:65:1: found a tab character where an indentation space is expected
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/ufs/rockchip,ufs.yaml: ignoring, error parsing file
make[1]: *** [/builds/robherring/dt-review-ci/linux/Makefile:1430: dt_binding_check] Error 2
make: *** [Makefile:240: __sub-make] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/1722928800-137042-3-git-send-email-shawn.lin@rock-chips.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

