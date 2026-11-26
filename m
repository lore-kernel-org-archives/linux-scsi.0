Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795654797;
	b=d5fZipE4cQrjWEeuFbNC3Y0W1WsUe/8Xogm+VnbYGyUGmftZgmiD0knz6ucdtldsuEmo
	 4RzSBLFSwp7NNw/xXrnR7hvIjcgSMmKLZGHFe2KYXBFHrJunFz5hHXu9kd+PRbA+kdKy6
	 hteNQ2W+3ufrWUpoTuDiDdyNRqO72Az/cBGM9L5UyJZAVuy8q00bXInQqhf+y6ZCnbJ86
	 HGg/x/48IJIHrHyucupg5b461n4pfBrXDfnWG93C5D9idFHvoQBvCz7o4SWbyIYDoObxL
	 LVUXwjBt8EV3ZOxuSoiv7zNObZPDiOCJZ4KuWTk6VSGJrERd5udCrYGB18mYt0ZDl1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795654797;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XttvFwCDNdxRvFGqVwEhqwoOFHbTAFAgsDy5lpWTNxc=;
	b=qEifQAJeIP2bgLWMG0e51YI+PUS8InwVh3L4pXd7boZOynCut1dEs2PgwA+QqltOsgjj
	 Ss3jHIJDeNL44/rog4X2vTi6LrGOoIkFIJZMzOfpE22jKneagOOAc4IbjsX5Ez7cY87lw
	 36EEinaEapIPV18lJnTuKU1ECLEf6J7JFlFQFLmbNJY2RW7ZqIcfevk1ot8AmOXluKBxl
	 NQCh6G46o/yi9hdlUbVcL5vyFc23WeWBwyegr9am/SERnHGKELNfPgiVvvVaLeHYYVzfN
	 cNen5+s9uauxVDC/SoogJRgEubBjNuCj11PXfhp/WnqKx8FGZz8aaoYw66Vf6cOSVWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orjRRRk8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67E9606A31E
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 00:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orjRRRk8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBA11F000C4;
	Thu, 26 Nov 2026 00:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795654796;
	bh=XttvFwCDNdxRvFGqVwEhqwoOFHbTAFAgsDy5lpWTNxc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=orjRRRk8BI1kg8lNpExT2hsKZkeMZ9X+O4O2JvJYOEFupmzygMHB/RyHd3daV6G5s
	 Kgg+SzsdtUS3RIzcifL8M1RvtziqfjmvQ77zEjqBzu4DBOQ5RIEY8dlM92OT7HlZy9
	 a09UYXyR0zl3at+236FjtB4F//VXKL5AAHmG2sUaRD4CRn5YoGZRRT9i3NzmSIezI/
	 IA7nBpP2z2/vHsgA+/zmIcH3GCHq3s2LS8MtwwZc4337KzWAFfrnwc212QXayjeAw9
	 RhN85QTNibXXnp27U1YkeDx554qzK2fGTtpMAXed3QDFSIsep14bLr5m+eliH4wSUw
	 YfJifowCwOo8Q==
Message-ID: <sashiko-outbox-234511@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] scsi: ufs: mediatek: skip PA_TXHSADAPTTYPE on
 pre-UniPro-1.8 hosts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ilia Snezhkov" <iasnezhkov@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261126005329.72010-2-iasnezhkov@gmail.com>
References: <20261126005329.72010-1-iasnezhkov@gmail.com>
 <20261126005329.72010-2-iasnezhkov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 00:59:55 +0000
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
- [Low] scsi: ufs: mediatek: inaccurate Fixes tag for
  ufs_mtk_pre_pwr_change()
--

commit 7768df4fa0e6861ba7a4e62b4a777b086e4e8d42
Author: Ilia Snezhkov <iasnezhkov@gmail.com>

> scsi: ufs: mediatek: skip PA_TXHSADAPTTYPE on pre-UniPro-1.8 hosts
>
> ufs_mtk_pre_pwr_change() calls ufshcd_dme_configure_adapt() on every
> power mode change, which writes PA_TXHSADAPTTYPE (0x15d4) even when
> passing PA_NO_ADAPT. PA_TXHSADAPTTYPE was introduced in UniPro 1.8, and
> ufs_mtk_get_controller_version() sets host->hw_ver.major =3D 3 only when
> PA_LOCALVERINFO >=3D UFS_UNIPRO_VER_1_8 (leaving older hosts at major =3D=
 2).
>
> On pre-UniPro-1.8 MediaTek hosts such as MT6789 (UFS 2.2, HS-G3 rate B),
> the DME write fails on every gear change with
> "dme-set: attr-id 0x15d4 val 0x3 failed 0 retries". Because the failing
> status is returned from PRE_CHANGE, ufshcd_config_pwr_mode() discards
> the negotiated parameters and applies the caller's desired parameters
> instead.
>
> Return early from ufs_mtk_pre_pwr_change() when host->hw_ver.major < 3
> so pre-UniPro-1.8 hosts do not write PA_TXHSADAPTTYPE, and simplify the
> remaining major >=3D 3 branch.
>
> Found on hardware and drafted with an AI coding assistant.
>
> Fixes: e1e25d1b8996 ("scsi: ufs: ufs-mediatek: Use common ADAPT configura=
tion function")
> Signed-off-by: Ilia Snezhkov <iasnezhkov@gmail.com>

[Severity: Low]
Should the Fixes tag reference 7212d624f863 ("scsi: ufs: host: mediatek:
Fix PWM mode switch issue") instead?

In e1e25d1b8996 ("scsi: ufs: ufs-mediatek: Use common ADAPT configuration
function"), the call to ufshcd_dme_configure_adapt() was still guarded by
if (host->hw_ver.major >=3D 3).  The else branch calling
ufshcd_dme_configure_adapt(..., PA_NO_ADAPT) when host->hw_ver.major < 3
was added by 7212d624f863 ("scsi: ufs: host: mediatek: Fix PWM mode switch
issue").

Also, the description of ufshcd_config_pwr_mode() discarding negotiated
parameters on PRE_CHANGE failure no longer matches the current tree, as
d3eba21c7170 ("scsi: ufs: core: Introduce a new ufshcd vops
negotiate_pwr_mode()") moved negotiation to
ufshcd_vops_negotiate_pwr_mode() and ufshcd_change_power_mode() ignores
the return value of PRE_CHANGE.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126005329.7201=
0-1-iasnezhkov@gmail.com?part=3D1
