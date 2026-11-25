Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795599322;
	b=WFthPrcEZ/tEQI5hakBgZVznwF1dN4YX8eLCwxINPys4qzYHSRw7c8u1mUh6XKKC7Bnr
	 F9MILedB+J14J/2KAqoanshiQL4J9kJyFlQCwE2lMk+PIWgh6Y3JhkTmziNZ81ijceYtP
	 LmHLvRA7VYTWufo9jptn4L9LmXYyFRC9RAAcX5PoLch3cs2v8lxDrkpNT8g/HyzoEhXVd
	 7C8qa2CmlouFwFtPrZqou0eCHXA9FKjGatoRLxHS2N3W5Miw1apUw6gvMBVsjTb7nPDNt
	 nMq/uV/T4E9Z5qkxLinDrjKyEbnRh//knLT1gVDD+q8Q512C2zbmK5oofe/HNsczeLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795599322;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xvoTqWnZqbRil1rJQswW0AyEBDmrdmKRGPk/m+Zf6hM=;
	b=XTo8JHOKdpdjeV30HQxzVjAeUBrzCnvFprhJdGLSPUGBSVJy+YAbJCooYxoEuhs5WvFt
	 5nTN5YLS+H2I8CgXONGgmQYc8Iv5uGTNRnqBKXYBCxO+2PL9Onee2RAqjuwDlPq5kAwli
	 Y1rjWPf6Uq6WkR5W0iXfQMUNDULyaSDOJUGM+16OK4EELWu/Ta8+6uxhUwdQGVVnVptB2
	 KdWnUv19L7agZ0OPxZhSWJ7Qn5+APW/Gnd6kv2WTsWGXJNbgCL8JOkEY+aUJlqqRC9NGf
	 msiugkAn/vfp2lc2jnGQKq3/Mz++H7rScdpHztDpGh1YLlWj3qbX3UxibFYmYB1qBfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7I4WyPr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706C0606A6AD;
	Wed, 25 Nov 2026 09:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7I4WyPr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE961F000E1;
	Wed, 25 Nov 2026 09:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795599322;
	bh=xvoTqWnZqbRil1rJQswW0AyEBDmrdmKRGPk/m+Zf6hM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h7I4WyProJmK3f1livIixTcjQVoDKJk+MJDjZX/9SHW6Kqq1NryvH1axMhVIokAYx
	 mreQrWqfuHQ/qb/WcnfHQmS9rYlmPGYJHCGj40bF94ZFJ/ZYdEsEXvacjTI3YKWES8
	 CcjxRswxGx2aEI6AP+XJZdAc1dIHvcQj0d665qizSgLwlKAav8BdgPiLQ5yfUZzge4
	 y51NGM+GHbNJm4TKulxuF/+bPhYVrCZ2skWDGuTQfMtJbGPUjXXvXM/Y7m2j3PqSv9
	 umbyBX2fR5DOkyWN5+FqqHJtkuUaWCiheeUJMd8M0DqmyefzrdqRDdxgB4k97+1yuE
	 KlhrGLwqFT7Qw==
Message-ID: <sashiko-outbox-233016@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] dt-bindings: ufs: amd,versal2-ufs: Add reference
 clock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ajay Neeli" <ajay.neeli@amd.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org
In-Reply-To: <20261125092351.2807658-3-ajay.neeli@amd.com>
References: <20261125092351.2807658-1-ajay.neeli@amd.com>
 <20261125092351.2807658-3-ajay.neeli@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 09:35:21 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] dt-bindings: ufs: amd,versal2-ufs: ref clock name ignored by
  ufshcd_init_clocks()
--

commit 533c5c18f1ac18e00d180f090ca93237f628f615
Author: Ajay Neeli <ajay.neeli@amd.com>

dt-bindings: ufs: amd,versal2-ufs: Add reference clock

This commit adds the reference clock and its "ref" clock-names entry to the
AMD Versal Gen 2 UFS devicetree binding schema so the driver can program the
device bRefClkFreq attribute.

> diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml b=
/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> index c00ec342d5743..11138578975f5 100644
> --- a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> @@ -20,11 +20,14 @@ properties:
>      maxItems: 1
> =20
>    clocks:
> -    maxItems: 1
> +    items:
> +      - description: UFS core clock
> +      - description: UFS reference clock
> =20
>    clock-names:
>      items:
>        - const: core
> +      - const: ref

[Severity: Medium]
Will naming this clock "ref" actually allow the UFS core to parse the
reference clock frequency and program bRefClkFreq?

Earlier commit "scsi: ufs: core: Support "ref" clock name" updated
ufshcd_parse_clock_info() to set clki->keep_link_active for "ref", but
ufshcd_init_clocks() still only checks for "ref_clk":

drivers/ufs/core/ufshcd.c:ufshcd_init_clocks() {
    ...
		if (!strcmp(clki->name, "ref_clk"))
			ufshcd_parse_dev_ref_clk_freq(hba, clki->clk);
    ...
}

With clock-names set to "ref", hba->dev_ref_clk_freq remains
REF_CLK_FREQ_INVAL, so ufshcd_post_device_init() skips
ufshcd_set_dev_ref_clk() and leaves UFS 4.0+ devices at their 52 MHz defaul=
t.
ufshcd_parse_operating_points() in drivers/ufs/host/ufshcd-pltfrm.c also
checks only for "ref_clk" when setting clki->keep_link_active.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125092351.2807=
658-1-ajay.neeli@amd.com?part=3D2
