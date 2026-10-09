Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A64C4C7539;
	Fri,  9 Oct 2026 10:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542948; cv=none; b=bXUvxH444gzrYNSGAOLKvf3cTqo60qCc9565rIQHFDPnb+zeF87+TcX0jnPYC+keVWehBfnbiARWailgLMCSSze1DXrMV/N1sjfaJuo2r9dbrI9AACaRJ2WDl0cPGhgRNmBz0iEZNab+bKm7VWkXPWS2ttBBBXMFnI+/gsILaeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542948; c=relaxed/simple;
	bh=S5Rm6sueVRCXfqjuLrrZ/vJbfMOZpVhiglmxRWFBrAY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=PIEDyZYVc4brCZRquv9GTVdKSRDgK8hdPONbNpQ9nbIrLweolremKzNkCaQ78eSED7ZoHzPVY8/Sem5LMQSOX238QKgnCAqkgv22a44lcB+VSd1vRqEpaV6BUC3ATHjePLgOwrH5hSwgt/KkL8TU34Lvwz6txqLjQC5B7LKzlss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfjkJgxd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfjkJgxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C26B1F0089B;
	Fri,  9 Oct 2026 10:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791542931;
	bh=Yj19hqBWFoDeHd/sJCxG3+F2qK0LAHRVQu3vZzeZC7I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PfjkJgxdsuX6q2hLoJZDnS1a/CAy6DompnqdspvlCUqsnS+65D+3pWtUSXhM8HRNL
	 kiUWO887e5jIDjDv/fR3Xnuqb0Er2WzAMs/5CHGk6KQHwR6CA5xtfdIcvdKArblYpX
	 7m9QEs/Iujy0238Bc/cA77jl9gH2qPcAIW2qMfXbBNeF/xAwkfynhU5OL6RaFcjAPM
	 fUYM9azg2LN2jFQ8bWoQKT8Ij0XfHr4TTeQp1PGdqdjmlAezfMmOzgjT9/Q+MR3jt3
	 hF/uPi5H9B8j7wGg2MxGCSaJKpt0UWA4S66cti+APmI6wSDtbUgiEUQxQg3eHcq5lX
	 Sr+lXgbbWLa+g==
Message-ID: <sashiko-outbox-165269@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/5] scsi: ufs: qcom: dt-bindings: Document Glymur
 UFS controller
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pradeep P V K" <pradeep.pragallapati@oss.qualcomm.com>
Cc: vkoul@kernel.org, linux-phy@lists.infradead.org, devicetree@vger.kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org, olteanv@gmail.com, neil.armstrong@linaro.org
In-Reply-To: <20261009-glymur_ufs_qcb_enablement-v4-2-9a6ce83195b7@oss.qualcomm.com>
References: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
 <20261009-glymur_ufs_qcb_enablement-v4-2-9a6ce83195b7@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:48:50 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] dt-bindings: ufs: missing corresponding QMP PHY binding for glymur
--

commit a93bc22aa0502f012705cac0afb0fdda1f1052cf
Author: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

scsi: ufs: qcom: dt-bindings: Document Glymur UFS controller

This commit documents the UFS Host Controller on the Glymur SoC. It adds the
qcom,glymur-ufshc compatible string to the QCOM SM8650 UFS host controller
schema.

> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml=
 b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> index d03295806657f..f132b1a9ebc28 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> @@ -16,6 +16,7 @@ select:
>        contains:
>          enum:
>            - qcom,eliza-ufshc
> +          - qcom,glymur-ufshc

[Severity: Low]
UFS hardware on Qualcomm SoCs requires both a host controller and a
corresponding QMP PHY.

This commit adds the host controller compatible string qcom,glymur-ufshc, a=
nd
a subsequent patch in this series introduces the PHY driver support for
qcom,glymur-qmp-ufs-phy in drivers/phy/qualcomm/phy-qcom-qmp-ufs.c.

However, does this series also need to add qcom,glymur-qmp-ufs-phy to the P=
HY
device tree bindings? As it stands, device tree authors cannot validly decl=
are
the PHY node for the Glymur SoC without failing schema validation.

>            - qcom,hawi-ufshc
>            - qcom,kaanapali-ufshc

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-glymur_ufs=
_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com?part=3D2
