Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794973070;
	b=XUOmV6Kg97+2Oj4Z/cIHsTS83M9XpZvSylqjE2Co8y6DxyDNFOVuyK4NgM4X77pn4Dk8
	 Z/phF3BdcJ4EFGulX3ehJTtWIBE/8HiFoZmIZ+phCKUfexU5dl/8BGweQKQrYucdxW3sk
	 cBKLv+mOzWF45i/YSeKSNSIrfjOJMNWyXiw1NKfiUIxOPkek1eduEtr5S5c17oTAAJ9Rt
	 BfCR2RPxfj5y2Us8P9p4V8BiHvdsAoPJmou0sEQcRrd6XvjGxV8Xu0q/TMJUVsX0yUvt1
	 RHH7TZ5H1SQcIu4W+cdmfAAXIwbbAusNtxPR37q2Yee5XXjCGYPrTOXOLn6hVgnnfWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794973070;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=q77G2/VBj8G7DQAjnZaHOQkJmDBChOlZQ7Pd8r3+vCc=;
	b=3aGtRjYZCTFkX5Ypt6VqSdbz5DhSPvXDrWxzlisZESiEnp3IC5/VVA1RV6aE6vw5i9BT
	 jWSzzFABvgkFAh6lBcN1c4LpU7r6977kNTpGNeWFBHO/RucI+To+EOsn/HmXwSxNe8mRv
	 NfTMocgp6S8qrU3iuSPCzuQvmn3BDqokIQDe9A+8FEzr1/QSGx2J6kitwr0SxijoSdF2o
	 pScFBeHYFgwVp39GlcLGRKkvMth63KeVOmxvwpf0yUargnJOa5osqZOQ/anQqPyly8Erp
	 ExYAGjht60TSNoygh/glSCyMbI/grk4oHO8N0MMZ/VgUYRRVM1RkZrMC38wUk73ctew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GJFPG8B3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC65A606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 03:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GJFPG8B3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EDC1F000C4;
	Wed, 18 Nov 2026 03:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794973070;
	bh=q77G2/VBj8G7DQAjnZaHOQkJmDBChOlZQ7Pd8r3+vCc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GJFPG8B3wcZY3KwGWKFaxjYLZ4qz3ob/R/KNyJ9gkoCIcj9SsKbUxsBaGQ4O0aWe5
	 j0HzGLgnCyJCIvV+N2uiF98XVwJVQwxyoh5JKyoYlOLH6UApSIxzgURW8hACayeMn3
	 XqJ7rE7gmPHV4C5BsZlpE2tuUiD7F/868xZJNVnygV1EXlDq24/9MfWc0HuryLHe8i
	 q+ASIIcD4TIzARrdkMTHgGEpAEzagf99vlJ6grK8Sd+6DrwAwc+zjzAMIt+6JiYtYK
	 yz42UVYvAhUpFx7jWr1e4FSYP0i/TLyOUnk6jnbEyUc37uYxTLnt4NEjdUJJKynBOf
	 ISNj84FoWzKmg==
Message-ID: <sashiko-outbox-220026@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs-mediatek: keep mphy state in sync when
 va09 disable fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xiangwu Lai" <laixiangwu@cmss.chinamobile.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261118032015.974-3-laixiangwu@cmss.chinamobile.com>
References: <20261118032015.974-1-laixiangwu@cmss.chinamobile.com>
 <20261118032015.974-3-laixiangwu@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 03:37:50 +0000
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
- [Medium] scsi: ufs-mediatek: reg_va09 enable_count leak in
  ufs_mtk_mphy_power_on()
- [Medium] scsi: ufs-mediatek: M-PHY left off during ufs_mtk_suspend()
  error recovery
--

commit 228f00d5e6d65bb4a18b8cbe9dee1c4060e6f74c
Author: Xiangwu Lai <laixiangwu@cmss.chinamobile.com>

scsi: ufs-mediatek: keep mphy state in sync when va09 disable fails

This commit sets host->mphy_powered_on to false unconditionally in the
power-off branch of ufs_mtk_mphy_power_on() so that a subsequent power-on
attempt does not bail out early if disabling the va09 regulator failed.

Link: https://lore.kernel.org/r/sashiko-outbox-219916@kernel.org

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 4895fe3b2a99e..b1ad983f80ae9 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -543,6 +543,14 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba=
, bool on)
>  			ufs_mtk_va09_pwr_ctrl(res, 0);
>  			ret =3D regulator_disable(host->reg_va09);
>  		}
> +		/*
> +		 * The M-PHY is off regardless of the va09 result, so keep
> +		 * the state in sync with the hardware.  Otherwise the next
> +		 * power-on bails out through the
> +		 * !(on ^ host->mphy_powered_on) check without powering the
> +		 * M-PHY back on.
> +		 */
> +		host->mphy_powered_on =3D false;

[Severity: Medium]
Does setting host->mphy_powered_on =3D false when regulator_disable() fails
leak an enable_count reference on host->reg_va09?

When _regulator_disable() fails in _regulator_do_disable(), it returns the
error before calling _regulator_handle_consumer_disable(), so
host->reg_va09->enable_count remains 1.  With host->mphy_powered_on cleared,
the next ufs_mtk_mphy_power_on(hba, true) call invokes
regulator_enable(host->reg_va09) again and increments enable_count to 2.
Subsequent power-off calls only decrement enable_count once from 2 to 1,
preventing VA09 from ever being physically disabled and triggering
WARN_ON(regulator->enable_count) in _regulator_put() on driver unbind.

[Severity: Medium]
Does returning the regulator_disable() error with the M-PHY powered off
break error recovery in ufs_mtk_suspend()?

When ufs_mtk_mphy_power_on(hba, false) returns an error to
ufs_mtk_suspend(), ufs_mtk_suspend() jumps to fail, calls
ufshcd_set_link_off(hba), and returns -EAGAIN to __ufshcd_wl_suspend():

drivers/ufs/core/ufshcd.c:__ufshcd_wl_suspend() {
	...
	ret =3D ufshcd_vops_suspend(hba, pm_op, POST_CHANGE);
	if (ret)
		goto set_link_active;

	goto out;

set_link_active:
	...
	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
		ufshcd_set_link_active(hba);
	else if (ufshcd_is_link_off(hba))
		ufshcd_host_reset_and_restore(hba);
	...
}

__ufshcd_wl_suspend() aborts the suspend and immediately runs
ufshcd_host_reset_and_restore(hba) without calling ufs_mtk_resume().
Because neither ufshcd_host_reset_and_restore() nor its vops callbacks call
ufs_mtk_mphy_power_on(hba, true), host reset and link startup run while the
M-PHY and VA09 power control are still off.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118032015.974-=
1-laixiangwu@cmss.chinamobile.com?part=3D2
