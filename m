Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794966878;
	b=bKik0nhd4KgA/VMQeLJtvwtX26pZjwFt97SKsNToVswfLXgx1LQ7nwSUkR3DdQ6vrgBA
	 sNG3/0Zt5YSJJkt1yAq8PjzV1mXutVtYr83bwOXbVOERtL5ykzPWgXuy31FhEo6hJB2cM
	 n/aThyq1tSOuhHmagyiNdPk3XzG89YUuS60q+sTa7s/Gx7aaMwQ5UpjTmDcb8fgxFTgLg
	 1lcRMhRsLawfbQ9MDxqz9caxxgAa93NVe2C3xnqNDFBE0QW9m4UfzJGgb0DHQHuokaKhj
	 De9W9Lwfl09/eKPML51zzeNKJu9k2Rs+ErpFSLqe1qTgVeBjN1YYWB17fCD/82FjeXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794966878;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3h+Z4OwPzk1KOPk/q/zM50h5QD7WUQnH6dCC+ZXStuU=;
	b=oW/7Ai6SeFAR1pCY6FCem9Mg74sTehA+iyQNYsMKjtKrvksrimA8A11P4IAwXzBOB58P
	 oIhB0l/VS89YiCVphcY+0hLCxnq7xIIRD0Kvqb3+VX4DveNNGgf9Cgn9b2xy44V0V7ZqU
	 ROpOObzsFKy0j2v+wnTP8EADKq9zy2x8WV8REswjlLMzLCeasHDccduh2/t+/oxMljK5T
	 QWWYUlDDfQh3Qq2jB8A3ki/2ySsKa0fWg0ZHXmKtjysbSdvrUOy2fWRH8RH1LNGABIoSJ
	 5x5KbZO74zrjM4x0EHKn6o7gjHFYIu0Z5BsecS2PiHsffVjlnG4xk6np0Tzt2jGn8hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PPVqn3IQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1C8606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 01:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PPVqn3IQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819AB1F000C4;
	Wed, 18 Nov 2026 01:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794966877;
	bh=3h+Z4OwPzk1KOPk/q/zM50h5QD7WUQnH6dCC+ZXStuU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PPVqn3IQZfmV1eCO57I6qHa/e1PcBuw3V5fqJ22IAhl2sFsR7K62p0DZvCSuVOS3/
	 QNfXAkRj7yXDRgw8unr2Ff6DpxcCNZNV8eFqQ4aAejUfDL4Y45Q/YBdo4X1cyvRI8z
	 gdfLu/ykyV1ikxiR5oJ7N8NHL1v48O5571r2AhdJqOqKwi0jAHTErnJ67xgZo7yqlu
	 GnRzE8YklHTscyL+739bbpwn5xSDMLIvZs7bm9smYuli+5ERJppW/KEed/2z3iET25
	 g7hjkUZukfnnuhO52sTrziVwBoXiNHwxuYAeEaG+amuvTzX2ljFaFi1Jb3IN3tp6x+
	 ep3XPWgPANbQA==
Message-ID: <sashiko-outbox-219916@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs-mediatek: use devm_regulator_get() for the
 va09 regulator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xiangwu Lai" <laixiangwu@cmss.chinamobile.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261118014234.424-1-laixiangwu@cmss.chinamobile.com>
References: <20261118014234.424-1-laixiangwu@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 01:54:37 +0000
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
- [Medium] scsi: ufs-mediatek: unbalanced va09 enable count on devm
  regulator release
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] scsi: ufs: mediatek: state mismatch on regulator failure in
  ufs_mtk_mphy_power_on() [1]
--

commit d21747583e36bae96677aff04541a8dd783fc43c
Author: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>

scsi: ufs-mediatek: use devm_regulator_get() for the va09 regulator

This commit switches ufs_mtk_init_va09_pwr_ctrl() from regulator_get() to
devm_regulator_get() so the va09 regulator reference is released on device
detach.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index c6329d88d1c65..e52a0e2f55c2b 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -692,7 +692,7 @@ static void ufs_mtk_init_va09_pwr_ctrl(struct ufs_hba=
 *hba)
>  {
>  	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> =20
> -	host->reg_va09 =3D regulator_get(hba->dev, "va09");
> +	host->reg_va09 =3D devm_regulator_get(hba->dev, "va09");

[Severity: Medium]
Does devm_regulator_release() call regulator_put() on host->reg_va09 while
it is still enabled?

ufs_mtk_init() calls ufs_mtk_mphy_power_on(hba, true), which enables
host->reg_va09 via regulator_enable().  ufs_hba_mtk_vops does not implement
an .exit callback, and ufs_mtk_remove() -> ufshcd_pltfrm_remove() resumes
the device with pm_runtime_get_sync() without calling
ufs_mtk_mphy_power_on(hba, false).  When devres releases host->reg_va09 on
driver unbind or post-ufshcd_hba_init() probe failure, _regulator_put()
hits WARN_ON(regulator->enable_count) and leaks the regulator enable
reference.

[Severity: High]
This problem wasn't introduced by this patch, but in ufs_mtk_mphy_power_on()
[1], can a failed regulator_disable(host->reg_va09) leave
host->mphy_powered_on out of sync with the hardware?

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_mphy_power_on() {
	if (!mphy || !(on ^ host->mphy_powered_on))
		return 0;

	if (on) {
		...
	} else {
		phy_power_off(mphy);
		if (ufs_mtk_is_va09_supported(hba)) {
			ufs_mtk_va09_pwr_ctrl(res, 0);
			ret =3D regulator_disable(host->reg_va09);
		}
	}
out:
	if (ret) {
		...
	} else {
		host->mphy_powered_on =3D on;
	}
}

When called with on =3D false, phy_power_off() powers down the M-PHY before
regulator_disable(host->reg_va09) runs.  If regulator_disable() returns an
error, host->mphy_powered_on remains true while the PHY is powered off, so
the next resume call with on =3D true hits !(on ^ host->mphy_powered_on) and
returns early without powering the PHY back on, causing subsequent I/O
timeouts and controller lockups.

[1] https://sashiko.dev/#/bug/linux-51b0f8e0-4730-46d4-afe5-42a3d31189f3

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118014234.424-=
1-laixiangwu@cmss.chinamobile.com?part=3D1
