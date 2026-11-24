Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795518607;
	b=dMZz+R/8zIf4hZJWbW7lyZCtFuC51fsVK4S0JXNgGq0BvWKYkfrweRfA/KD4J5t79Zyn
	 qzhIiQwtOVT3c+kLUsj5cR5+9mmpTq+t2Bcm8s1HPqXlVb5W3EhX5MdXtaN/uwa3ub3XQ
	 zd7HV6TV2H1L2aWJMBU8uScBTxgh3+QopUu+xMY9Qc1xv9VNomyOsu2NlLD/s3AjMMiiM
	 PFx26kNIsB+V/ncqvaE8kGU9Uh2K/613pN+chFPpVufEJQj2PjG0G7TaBFJjQsnI5mhcj
	 tc0h3N0Qd+o0UE7AAwZqZp6RJSuDNjV3+Uf5F/a6aINOGRvcQ56wyNNF1zHZ6cRQInw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518607;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9Uc4JfCpumODPMijRTnBTi5b0zIZfgKr+QSoPMZhijs=;
	b=q72uYosvy71+WZyS6uPx4gVbS1/0BdIU/Tj5hMOCHdPrHW/Muc8eQKCpbGPsb/ToVv1z
	 qgWAIQk1DmI+/10O0RRswsGY5rsFh4yUtcjooMe0Qz1+a9Ea2hMXSN+YqOwwpT5R29+nW
	 NgYclHvf1C0cNzS/uFJH5kgV5ZFtGDuBF6xz2nFxcqVaNFIR7hShuMJkcgIp+fQWwjKPG
	 NhXjDmdVoQa6skJAr993339h53JprRvlyBbQ7a3jiTzQBOYfE2P7zBdjhSwkj8hOWEb9M
	 7slL4jcZs3zgeWslNtJ3jYlcHuqGmOhMnwFGvDUJ7eZWeNipMu5jkhUQCJboE0SxraQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Xk3xuaa/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E8D606A31E;
	Tue, 24 Nov 2026 11:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xk3xuaa/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63DF1F000C0;
	Tue, 24 Nov 2026 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795518607;
	bh=9Uc4JfCpumODPMijRTnBTi5b0zIZfgKr+QSoPMZhijs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xk3xuaa/N5uXyYcRyMEpHNDrB5D1+eHa7NqcjVwAx3wOPES3y2Hi+0jaHatDHcuOI
	 NM9YLecUnGW7nfHNhb8SGnFQCa/14sn5tJvt1witsDZkXAT2HEGwuoEMVATgsa6p+2
	 ps10XURSxtCOr6La8VFwEWrW+QxkzLbS5LbVKZP7HlRgc6P6Y0ui1dg/4si6c+H3wf
	 LvbBwy5C98hMGI3EcbiXxh62iv82G90ijgRkMfI6u4RqYV0j+kqAlCL9P+0M0jkUSP
	 2RyQxtkZMUvXWYEKGrs+AZPgREvCd5+YB57cUB2vWeKTNnq+ziK/ptOwOFNTGg9HzK
	 5H/224DWLjf9Q==
Message-ID: <sashiko-outbox-231022@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: dt-bindings: Add compatible for Seca UFS
 Host Controller
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yadu M G" <yadu.mg@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org
In-Reply-To: <61136dcb5cde2c0cfe1b8f3a488e9edcf36043cf.1795517687.git.yadu.mg@oss.qualcomm.com>
References: <61136dcb5cde2c0cfe1b8f3a488e9edcf36043cf.1795517687.git.yadu.mg@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 11:10:06 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] dt-bindings: ufs: duplicate compatible items block in
  qcom,sa8255p-ufshc.yaml
- [Low] dt-bindings: ufs: mismatch between Seca commit message and
  qcom,secaau-ufshc
--

commit b11281b04c340241867d637b437dc8dcec5dc5bf
Author: Yadu M G <yadu.mg@oss.qualcomm.com>

scsi: ufs: dt-bindings: Add compatible for Seca UFS Host Controller

This commit adds the qcom,secaau-ufshc compatible string with the
qcom,sa8255p-ufshc fallback to the SA8255P UFS host controller DT
binding schema.

> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yam=
l b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> index 66d73e9025d6b..4a5dbc780b0d6 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> @@ -16,6 +16,9 @@ properties:
>        - items:
>            - const: qcom,sa8797p-ufshc
>            - const: qcom,sa8255p-ufshc
> +      - items:
> +          - const: qcom,secaau-ufshc

[Severity: Low]
Is "qcom,secaau-ufshc" the intended compatible string when the commit
title and message refer only to "Seca"?  Other Qualcomm codename-based
UFS compatibles in Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.=
yaml
use "qcom,<codename>-ufshc" without an "au" suffix (such as
"qcom,glymur-ufshc" and "qcom,nord-ufshc"), so either the compatible
should match the SoC name or the commit message should explain the
"secaau" variant naming.

> +          - const: qcom,sa8255p-ufshc

[Severity: Low]
Should this compatible be grouped with "qcom,sa8797p-ufshc" in an enum
under the existing items block rather than adding a duplicate items block
with the same "qcom,sa8255p-ufshc" fallback?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/61136dcb5cde2c0cfe1=
b8f3a488e9edcf36043cf.1795517687.git.yadu.mg@oss.qualcomm.com?part=3D1
