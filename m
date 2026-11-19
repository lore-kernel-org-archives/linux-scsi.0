Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101473;
	b=L/N4euvr7mZtccMV+CABDl7tpyg5iPjRiOwE6R24YosKmW5kCkXCHckM8aBDDx9NIjgT
	 Uz0IgNUtymQfWJtiL7gqiEgQIypUs7UZgzVvwjupaUgfS+JJDNHz9LxKZKnV9fsAThzXl
	 nLpjSVBcax4XphoOxtbGUdgG8c/2Gil8M68Lno/qAz/CYleadSv8z941vngbPyINRJ7HT
	 onBwDEfDaUTN/MQNmzhxfUu6oZAWeC6P/hQencV177LH5KKCaRRDXue1e/eAMaDVanbBU
	 lr2Nn1Zj2ZeVsNldGL8e7JNKT34tFp5h0KDqJv/EUynIPzjKOdlOxUDC38qm4pGq1dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101473;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1yBhK8DzlTFvVGFf7TNM8ewNHyj6enCfbqFsZn6LpEk=;
	b=0eq3racVnsGEh9Bpw8GC+fZlZiQAYDR7zCXgJfFoTcYkLSjtf0R4Ccc8RyxJXcDUVGjL
	 4LHiN/Rh7f7IPh9ECKc9dVEVomGu01usoXVS+AFXflnyVUvEGsgwXOkF/yZMegyA9IQzy
	 8xc4ZQqYLuLJeRPRDlFcm/YkpkRb8z77CA7CCvzTroftPtH7CjvCX+PR9KzYCCcP5wRlX
	 3T3EmE3DXTUNw63hCRBMLvoJAFBjgkVT4FlkXvUu5UnTUXVvDFTP4Fo6enB/T4dXfuGKm
	 lBnLeU+SUOK/m0vEE+MQUlGCWX7kww5updkYLS2t1qyxYFj0iEQC7IfBUTvarw5iIVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ANb40fzP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026E3606A320;
	Thu, 19 Nov 2026 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ANb40fzP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A8F1F000C4;
	Thu, 19 Nov 2026 15:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795101472;
	bh=1yBhK8DzlTFvVGFf7TNM8ewNHyj6enCfbqFsZn6LpEk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ANb40fzPs8wTgrqkgrgJCj1YYvFlgFOj9apufe8p7k0lA7lmtosnDm4LF4W1QQ/l9
	 GwcWUFRl58SYl32C7JJQhbcAZxksWm4kZLovBLPbyu1H+Vx7u3zY9auMLgrWYmHkb3
	 zKhvwRiKvhbo0ghpSWrJbcEwvg2Ze9XXaxrnhWUlp66Ko7CHe4IP8sL5N3ps+HDypy
	 OGEUOdiAA0WbowzPyKYMfsyRcoVwRWxtHoWgYi+yT+kadqel7cAksZtuAW5mJAk2VP
	 pSnbLF8VvoTF2JvDEpIA/cZixXgWnaYErD4clh3UwHJcLEUSAQlZSrXtsSL0l/jdes
	 UJ3Vdc9z5tHHg==
Message-ID: <sashiko-outbox-223360@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v15 13/23] scsi: ufs: mediatek: Remove vendor kernel
 quirks cruft
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261119-mt8196-ufs-v15-13-aae1eb0382e8@collabora.com>
References: <20261119-mt8196-ufs-v15-0-aae1eb0382e8@collabora.com>
 <20261119-mt8196-ufs-v15-13-aae1eb0382e8@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 15:17:51 +0000
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

commit 6eb15fdb7923519860f06ff3289f50b279237ee3
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Remove vendor kernel quirks cruft

This commit removes the ufs_mtk_vreg_fix_vcc() and
ufs_mtk_vreg_fix_vccqx() regulator fixup helpers and their calls from
ufs_mtk_fixup_dev_quirks().

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 907b5fe6eb22c..fec0fb24e7a2c 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1068,73 +1068,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hb=
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
removed now that ufs_mtk_vreg_fix_vcc() was their only user?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-mt8196-ufs=
-v15-0-aae1eb0382e8@collabora.com?part=3D13
