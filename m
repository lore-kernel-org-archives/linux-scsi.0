Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795870;
	b=jOV7IxCodNH8S9OWUl8Yp7+U8dVwqngSJr8c1Q5SrjsHtR8low2Id0Xp5WuhuqHXZ3Ta
	 7WN6NLBQX2ORKeFzWAiAEtTQH3A87F2oOIV1D5TD13I36Fs5RHNc43fUk4yspTeYHiqHC
	 ClO+Zv//+5h7ocTL+NiM4z6b3gpSvYFcySb0YjZU0RVH/CifmrgtBahRb3J8shVehk1+Y
	 s+BnDokyOBJgViMhMLp3XGsR8v1kbrwqLI6By5S6jBND+WImZVn3w3lO/7u2AHqK+h1uQ
	 exAca6xUUDogQ4Wy3It49JNKgGHX6AGuJL4U38GhrpKOX6mM6tzu946700BkYNMhc9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795870;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xMo6OFbZiERAuy+5msGQEpNEdcyP65mRm2aq/lFG9/A=;
	b=qcgUL/zv4Mtbk/7JEOzr8N5OjLRijTzHV5CrM1DCd9IHEpaKa9nYE7f7MmcGaQmNICPY
	 S56pcFmuPdpaHXEC7SE4kGQOQ2P5I2ehjNN3nyNjhl0pF0O78RvvLYDGEeAnIUdWLPqnI
	 cuD/vQKROc1CIKUqacoIuFV57PJk78KnTBhlaBtC5qUhIS3bpQP0n/rqpWFYnAlyHkxu7
	 i6VPbXY3GwdH9s4u4fE1TEsppklDHxjHlZpM5WHOPTgl9Vpn+Zax3mERuZR/Vb1hsFxnL
	 RUhyuRhj7OImu6WzCNzkH3qGN1WWIX0FyrIS5pO/+fM3xUthOE+nI3rzht1nApVTBvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cVF6Iy1A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BDA606A31C;
	Fri, 27 Nov 2026 16:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cVF6Iy1A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C501F000C1;
	Fri, 27 Nov 2026 16:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795870;
	bh=xMo6OFbZiERAuy+5msGQEpNEdcyP65mRm2aq/lFG9/A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cVF6Iy1A2nfHMRpv9AVyXTtVbcJlU3i+qd7sXChBgrXsof4lMiBXigfXU7REWe8ep
	 a4DZjCqyH6p7ffZ8v0DvaJ6zeGOT3B42IszBmtb3m8H7SEh0SN8sXO+blswRL7vECw
	 xKZWu84XpOAosBxDQiCFWSLxzyNctsaoczS11+fK5TBoj9zsQub7UkphWBJhNy5k5+
	 Sbmd0DR5Q7FG7bBvi4+YrfGSW16k4bac/UqA4TuQ/9ijrrhAo6whlfkXY6vs94t7Au
	 g7xBzgarTxzhqTvyYAyqUSx4+E8yYgn2S5sfshygQxhuTiTpNKKShENbQjQGnxz532
	 /5D9ZRQtxNONA==
Message-ID: <sashiko-outbox-237846@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 13/23] scsi: ufs: mediatek: Remove vendor kernel
 quirks cruft
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261127-mt8196-ufs-v16-13-6f2568f7c119@collabora.com>
References: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
 <20261127-mt8196-ufs-v16-13-6f2568f7c119@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 16:11:09 +0000
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
- [Low] scsi: ufs: mediatek: dead VCC definitions left in
  ufs-mediatek-sip.h
--

commit 9b4c30d640a0f622db3905feadca5442c2f1cc01
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Remove vendor kernel quirks cruft

This commit removes the ufs_mtk_vreg_fix_vcc() and
ufs_mtk_vreg_fix_vccqx() regulator fixup helpers and their calls from
ufs_mtk_fixup_dev_quirks().

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index e768afdbc3bef..33ed5e6dabfeb 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1074,73 +1074,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hb=
a)
>  	}
>  }
> =20
> -#define MAX_VCC_NAME 30
> -static int ufs_mtk_vreg_fix_vcc(struct ufs_hba *hba)
> -{
> -	struct ufs_vreg_info *info =3D &hba->vreg_info;
> -	struct device_node *np =3D hba->dev->of_node;
> -	struct device *dev =3D hba->dev;
> -	char vcc_name[MAX_VCC_NAME];
> -	struct arm_smccc_res res;
> -	int err, ver;
> -
> -	if (info->vcc)
> -		return 0;
> -
> -	if (of_property_read_bool(np, "mediatek,ufs-vcc-by-num")) {
> -		ufs_mtk_get_vcc_num(res);
> -		if (res.a1 > UFS_VCC_NONE && res.a1 < UFS_VCC_MAX)
> -			snprintf(vcc_name, MAX_VCC_NAME, "vcc-opt%lu", res.a1);
> -		else
> -			return -ENODEV;

[Severity: Low]
Should UFS_MTK_SIP_GET_VCC_NUM, enum ufs_mtk_vcc_num, and
ufs_mtk_get_vcc_num() in drivers/ufs/host/ufs-mediatek-sip.h also be
removed now that their only caller ufs_mtk_vreg_fix_vcc() is gone?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-mt8196-ufs=
-v16-0-6f2568f7c119@collabora.com?part=3D13
