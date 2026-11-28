Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828245;
	b=IzdyKIQMg95i2hk8nPEDqmibK+UJgp42CdFYmEcFaaN6wenJwVzswPHipXwZB15CoAv+
	 HNq2sHrjLv/AxIQL7OuVvzCRtchNc4cNq6jeisQyPtQ5N4GGIhGcYYkixUt9wwzLURl3c
	 7PMhA22g04phwEntJ5epSMcSPrrUXuozYnlL/i7nXeLxKYY3A96hrxmqeYCq+n89mOaXC
	 vBxXveb6nObXoNKYJ2wHnzZH6K3+IY3I+INDosDT1vILBFEpDyuXNsN6b/XQ/Bg4e0fqZ
	 YjHv+R1XDRiRe9DLXmlrnZ3EdBOpZ5hB2hX0cr47cNwsFHWvdjSDTUgWG42DmXvEBpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828245;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oA6+axFWdbvfyylMGbfdz9tnLwCnTfNZuB0xGxk5pO0=;
	b=AiQ3wLpHuJnc/3ORPXL9DtCtI7sGfXgZ6EGVxz5A9uWF3qzGPaDXEV5j/bZUD0PGiTyS
	 YTup5YrPBWky0/nKNAY0vKErdsIZGHigEWIg/wGFA/e4MZtGL8KZfS/O0hpEX1aJ4Avcs
	 rIBY5NVWQRtNZSbNpv5ET2DUHGW1Z1SUBaWcdwKnEwqIWVGW6F8wL3nHmG6Vh4gEVf/oZ
	 HyQ30NlRqEjPRUzuH6nfJR2SD6WTStRKkJUq5Bg1xynSx4eaRvjzmcEecqc87lY1H5cPK
	 C6No/s2KV7BetQAsvb9ZW2Q20jiC9Owm6kLOBsu6eAvTDYfM5HD3muvjpzRRjSinWXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HixYHQEm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3F8606A31C;
	Sat, 28 Nov 2026 01:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HixYHQEm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB42E1F000C1;
	Sat, 28 Nov 2026 01:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795828245;
	bh=oA6+axFWdbvfyylMGbfdz9tnLwCnTfNZuB0xGxk5pO0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HixYHQEmY4huq9YL9isf4KMEWMGe1ojrsvMzk13z89JSYxrx27dcsv1dSHkG5wlCP
	 talO7ze4y1aQZQ1Q2MHKSWQPpHlwLoGjm0Wd/E6ssxya05e2/tIMueP3+vj2xc+9an
	 OjGw9G3HHCbNx0/2dcm+N++38DoV/k8Z2dEXPcsmjMKnC20aNfzTvrTiZ7NrVuYobR
	 86NloAt0fLqR07j5DK91bPECTIH3J/zY1Y+iV44RHAckGD6/TW+fCodyG5FyjOCzG/
	 PqsiApyL3fY76WEE2vfwSFgA9xVO5cZZ3Jgt7ixS1x84Aza+Z6YysjGRKPGUECNdpC
	 8/h3hrA02eMAw==
Message-ID: <sashiko-outbox-238396@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org
In-Reply-To: <20261128-08-k3-ufs-support-v9-2-d27deb096d1e@kernel.org>
References: <20261128-08-k3-ufs-support-v9-0-d27deb096d1e@kernel.org>
 <20261128-08-k3-ufs-support-v9-2-d27deb096d1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 01:10:44 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Low] scsi: ufs: spacemit: incomplete kernel-doc comments in
  ufs-spacemit.c
- [Low] scsi: ufs: spacemit: positive UIC error codes missed by negative
  err checks
- [Low] scsi: ufs: spacemit: unused variant struct, headers, macros, and
  duplicate tag
--

commit d1110f647e4d5741aaea4207a41324cfd65f105b
Author: Yixun Lan <dlan@kernel.org>

scsi: ufs: spacemit: k3: Add UFS Host Controller driver

This commit adds the UFS host controller driver for the SpacemiT K3 SoC,
supporting UFS 2.2, MIPI UniPro v1.61, and M-PHY v3.0.

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> index 0000000000000..8024b2c1f4381
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c
> @@ -0,0 +1,619 @@

[ ... ]

> +/**
> + * ufs_spacemit_mphy_init
> + * @hba: host controller instance
> + */
> +static int ufs_spacemit_mphy_init(struct ufs_hba *hba)

[Severity: Low]
This kernel-doc comment is missing a short description after the function
name and a Return: section, and ufs_spacemit_init() below is also missing a
Return: section, which causes W=3D1 and W=3D2 kernel-doc warnings.

[ ... ]

> +static int ufs_spacemit_link_startup_pre_change(struct ufs_hba *hba)
> +{
> +	u32 value, sys1clk_1us;
> +	int err;
> +
> +	err =3D ufs_spacemit_mphy_init(hba);
> +	if (err < 0)
> +		return err;
> +
> +	err =3D ufs_spacemit_uniprov1p6_init(hba);
> +	if (err < 0)
> +		return err;

[Severity: Low]
As reported by Troy Mitchell on v6 [1], ufshcd_dme_get() and
ufshcd_dme_set() return positive 8-bit UIC command result codes
(0x01..0xFF) when a DME command fails at the UniPro layer.

Checking "if (err < 0)" here and after
ufs_spacemit_quirk_host_pa_saveconfigtime() in
ufs_spacemit_apply_dev_quirks() misses those positive error codes and
allows both functions to continue past failed DME operations instead of
aborting early. In addition, ufs_spacemit_pwr_change_notify() ignores the
return value of ufshcd_dme_set() in POST_CHANGE instead of returning it.

[ ... ]

> +/**
> + * ufs_spacemit_init - init phy and prepare clk
> + * @hba: host controller instance
> + */
> +static int ufs_spacemit_init(struct ufs_hba *hba)
> +{
> +	struct device *dev =3D hba->dev;
> +	struct ufs_spacemit_host *host;
> +	struct reset_control *rst;
> +
> +	host =3D devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +	if (!host)
> +		return -ENOMEM;
> +
> +	rst =3D devm_reset_control_get_exclusive_deasserted(dev, NULL);
> +	if (IS_ERR(rst))
> +		return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset control\n=
");
> +
> +	host->hba =3D hba;
> +	ufshcd_set_variant(hba, host);

[Severity: Low]
This isn't a bug, but struct ufs_spacemit_host is allocated and passed to
ufshcd_set_variant() here without ever being retrieved via
ufshcd_get_variant() anywhere in the driver.

Also, drivers/ufs/host/ufs-spacemit.h includes unused headers
(linux/regulator/consumer.h, linux/pm_qos.h, and linux/workqueue.h) and
defines 15 unused macros (UFS_LOCAL_PORT_ID_REG, UFS_PA_ERR_CODE,
UFS_RETRY_TIMER_REG, UFS_CFG1, DEFAULT_CLK_RATE_HZ, BUS_VECTOR_NAME_LEN,
UFS_HW_VER_*, UFS_DME_VS_CORE_CLK_CTRL, UFS_HCLKDIV_REG, and
MPHY_RX_FSM_STATE), and the commit message has a duplicate Tested-by: tag
for Aurelien Jarno.

[1] https://lore.kernel.org/r/DLLQJDEA91FU.18Q1TSX09AUR3@linux.spacemit.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128-08-k3-ufs-=
support-v9-0-d27deb096d1e@kernel.org?part=3D2
