Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795796077;
	b=U1aDM20i2K/sZCPJbJBNtR7a7jzXZWnWyh02IV1I3/Ue1rwx6pzhrdSnhHj1dcSerPeS
	 b/csyKcVCe1B++7eYTNTG0WXSFL6uQIEl329iRK3oszMC3m1o9N1jiXwrUei1gqBLmPtp
	 h6X8DEABWFUYtWH1RujTNh5wic7tqBsBwYnuOUSN07/NzirOkulT5GwbLBOoorcMPMvK1
	 azr/o4M/qUqU3mm0Ptqr5izkq0lKwSBUGyqZFPubiQgSdwVpnLUuE8lSJ81FbvfJmu9pN
	 ztkUtOLh5pSycTAT/2eQsqEM9qI3TaHQYuz3nXZSf4+4RUpnMEZlvwtzzd1hLrWRptw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795796077;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jrypLR0X0eLwSt5FL6Fsdv4qNePy86+fgdrhz4CbdLU=;
	b=OQNnzjv3B6/j0PJl1iTvREV16hSRSahkfTt14m3KIdx2VE8/oTmnJ1PtPHpS1SpGck5s
	 N/L9iNVr3u0o9qDEZuS6xWNG2abw9w+6tG7u1Q3ALNI4xjmmptBP+v9cfT2UWlpxrPQXR
	 WKFPBlKbbc6Mmpu7z/Caj4fK+hedI1tKoCNILeMxfiCaMqQdS2FCCH7Te0wLJxNVGc7ep
	 qTp1AwmAR2O+0CmR+OUmafUHvhmE5RKYw5mp9tZMOuEcbu3xJSgy8uzguAIaMH6z51jEJ
	 WZAPOdmTCXX7drV3vNq72KcZ2+30VBRAUyYNqeh99Vd9YEXqG2fz2WJHS/shfPq6wCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k9GrE7MG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94A2606A31F;
	Fri, 27 Nov 2026 16:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k9GrE7MG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8A21F000C1;
	Fri, 27 Nov 2026 16:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795796076;
	bh=jrypLR0X0eLwSt5FL6Fsdv4qNePy86+fgdrhz4CbdLU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k9GrE7MGjynZTWoqPJOH1mhcg2vVTwEydcRDGpkLe/iTCppVZkoBlyCFHGClDMbSj
	 G/YKyzWI5fZNlGHqT0tIOL2e94IlBOT8nFDHK+pLlg/Aw1G6D0+lIWofmBk3qmHwdp
	 NsfT5zbJKZVhVVKgcQe30J9o5FNTR8HsyiqEimk0TA3UniqU96n9a2oBWxDyq3cH/I
	 s8obDvdG+xr4RHwB3Pt530KBhUIgOsM5jUopX9IY6VZkQaJ7VnBIXOx9v63Q3GCr78
	 ITQQsXu4G365Bv+cwoSM4ife5NHddXAHRAau0PllvuUwaVrJcE+4Tfs4fxdDUbDFFQ
	 ByXxRl9M4ry2w==
Message-ID: <sashiko-outbox-237853@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 14/23] scsi: ufs: mediatek: Use the common PHY
 framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261127-mt8196-ufs-v16-14-6f2568f7c119@collabora.com>
References: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
 <20261127-mt8196-ufs-v16-14-6f2568f7c119@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 16:14:35 +0000
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
- [High] scsi: ufs: mediatek: premature phy_exit() and power leak in
  ufs_mtk_exit()
--

commit 7f178c3fbe09182cf227562674a16dbb3d7b6d01
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Use the common PHY framework

This commit replaces custom OF parsing and runtime PM management of the UFS
PHY device with devm_phy_optional_get(), phy_init(), and phy_exit() in
ufs_mtk_init() and ufs_mtk_exit().

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 33ed5e6dabfeb..9d7e4bc96203b 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -1336,8 +1308,15 @@ static void ufs_mtk_exit(struct ufs_hba *hba)
>  {
>  	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> =20
> -	if (host)
> -		ufs_mtk_mphy_power_on(hba, false);
> +	if (!host)
> +		return;
> +
> +	ufs_mtk_mphy_power_on(hba, false);
> +
> +	phy_exit(host->mphy);
> +
> +	/* Set MPHY to null so it is not used anymore */
> +	host->mphy =3D NULL;
>  }

[Severity: High]
Does ufs_mtk_exit() call phy_exit(host->mphy) and clear host->mphy while a
second phy_power_on() reference is still held?

ufs_mtk_init() calls phy_power_on(host->mphy) twice: first in
ufs_mtk_mphy_power_on(hba, true) and then in ufs_mtk_setup_clocks(hba,
true, POST_CHANGE) -> ufs_mtk_pwr_ctrl(hba, true), leaving
mphy->power_count at 2.

During teardown, ufshcd_hba_exit() ungates clocks in
ufshcd_exit_clk_gating() and calls ufshcd_vops_exit() before
ufshcd_setup_clocks(hba, false):

drivers/ufs/core/ufshcd.c:ufshcd_hba_exit() {
    ...
		ufshcd_exit_clk_gating(hba);
		if (hba->eh_wq)
			destroy_workqueue(hba->eh_wq);
		ufshcd_vops_exit(hba);
		ufshcd_setup_vreg(hba, false);
		ufshcd_setup_clocks(hba, false);
    ...
}

ufs_mtk_mphy_power_on(hba, false) only drops mphy->power_count from 2 to 1
and turns off the 0.9V supply before phy_exit() runs and host->mphy is set
to NULL.  Because host->mphy is already NULL when ufshcd_setup_clocks(hba,
false) runs (and uic_link_state is still UIC_LINK_ACTIVE_STATE during
ufshcd_remove(), so ufs_mtk_setup_clocks() skips ufs_mtk_pwr_ctrl()
anyway), the second phy_power_off() is never called.  This leaks
mphy->power_count, the PHY runtime PM reference, and the PHY clocks, and
causes phy_init() to warn and phy_power_on() to skip powering on the PHY
if the driver is re-probed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-mt8196-ufs=
-v16-0-6f2568f7c119@collabora.com?part=3D14
