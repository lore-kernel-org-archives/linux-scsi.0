Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794423246;
	b=mmtNC81efuHT8WNNMjPbEqWsngdmqtxLtnnDCtT5ikoDlKShmCvudp8DQKRVY61B60kD
	 Niljh2BIuDdWEozRBvAv/mWniBYjVNEz49i2rWyLDTSKBp+xSNknpGT4qNMzCKN/FUQKm
	 VXwjAcIu9RW39Rud4ZnoXzLOFZIJmBsK6eNil4OiGUWvQMvQSes9r3Nyekb28i6rRppIk
	 m6UZEE+R7R716FlG4IH5vGo4UkYnHBKzMO8vaamBQOzobI8gc28jy4i9BeDNP/8uRqtFD
	 xRWnddDTytLqNZZ8IVHeUmwwq/80oqk3Nx090KOdSY9/hRGNPoY2qFNIDYkNqEy7PoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794423246;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KiFkp2Vsg12XVMJLOSqhizgJQNf1YDUKY1+h6KSVwZg=;
	b=EHTGoEIpjVIjGjFupifKeg5tkf91Nkvg2YGR9tkdB4JuMj9tPwgv3ATwn0S9nbic8AoC
	 SSv9H5am1k9afBEAyDcUKxd+K0ILPPz0JdQlTGkhXMWKIhd5bNfkZ6uNIKt+NlvNd6Xle
	 k0F3uJxEtAMp+gWGCduCTlKTGFeyrwuqyBfud8pFrKomdbzHJxKRH/mDSSQ9gkJXI37DV
	 myCvbeKwfpFZhg5rIzTPFuH6S3vkUPR8pVN3/MN0AlcAYtwHXrC9Euq9lusmIEeJwwLys
	 fFDog18JxmG9I3/THLEmqrrA44VC8oWvehUDrEOsmyJhCBPz9d2SYX7i36U4mOlDPyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W6gFArpl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C794E606A336;
	Wed, 11 Nov 2026 18:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W6gFArpl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1F21F00A07;
	Wed, 11 Nov 2026 18:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794423246;
	bh=KiFkp2Vsg12XVMJLOSqhizgJQNf1YDUKY1+h6KSVwZg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W6gFArplMOoaiWGFsapXAYMAsrIllhvLsb06tEVB8jWOMWOCgUej3w86/70CnkS9i
	 rYX6kEui2HjCKRsRI4dv3e/BnZJOSOjuEttx1q73ejQWSEfE/pxB99wLOTiiX4ctEd
	 O5g8izE22Usv4zGdmMqDkILumwsr96uPgzPBqhQfiwMGEby1Xp/BrL0I2EV7l6qg7K
	 nkK857gJvqjg2kRJyqGJNKuRKxfoS25rjJLkgb+88BbghhR9x/oiJ2pznAwpdC8ugA
	 jnl2ez6o67jPMlgsNySy60npPrd8zFpKIZOurtrCK8AmnijmEO9HPhTOtmgtkcTqHj
	 Ghx0ME1mC0BLw==
Message-ID: <sashiko-outbox-209503@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND] scsi: Consistently define pci_device_ids using
 named initializers
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VXdlIEtsZWluZS1Lw7ZuaWcgKFRoZSBDYXBhYmxlIEh1Yik=?= <u.kleine-koenig@baylibre.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261111183844.1906794-2-u.kleine-koenig@baylibre.com>
References: <20261111183844.1906794-2-u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 18:54:03 +0000
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
- [Low] scsi: stex: shifted model comments in stex_pci_tbl mislabel
  st_P3 PCI IDs
--

commit db5880bd5d82ae26b6fc5fffb19956c877343ba5
Author: Uwe Kleine-K=C3=B6nig (The Capable Hub) <u.kleine-koenig@baylibre.c=
om>

scsi: Consistently define pci_device_ids using named initializers

This commit converts struct pci_device_id arrays across SCSI drivers to use
PCI_DEVICE*() helper macros and named initializers for fields such as
.driver_data, .class, and .class_mask.

> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index d4899816f7dc8..057aa4b026740 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -1489,47 +1489,80 @@ static const struct scsi_host_template driver_tem=
plate =3D {

[ ... ]

>  	/* st_P3, pluto */
> -	{ PCI_VENDOR_ID_PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE,
> -		0x8870, 0, 0, st_P3 },
> -	/* st_P3, p3 */
> -	{ PCI_VENDOR_ID_PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE,
> -		0x4300, 0, 0, st_P3 },
> -
> -	/* st_P3, SymplyStor4E */
> -	{ PCI_VENDOR_ID_PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE,
> -		0x4311, 0, 0, st_P3 },
> -	/* st_P3, SymplyStor8E */
> -	{ PCI_VENDOR_ID_PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE,
> -		0x4312, 0, 0, st_P3 },
> +	{
> +		/* st_P3, p3 */
> +		PCI_VDEVICE_SUB(PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE, 0x8870),
> +		.driver_data =3D st_P3,
> +	}, {
> +		/* st_P3, SymplyStor4E */
> +		PCI_VDEVICE_SUB(PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE, 0x4300),
> +		.driver_data =3D st_P3,
> +	}, {
> +		/* st_P3, SymplyStor8E */
> +		PCI_VDEVICE_SUB(PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE, 0x4311),
> +		.driver_data =3D st_P3,
> +	}, {
> +		PCI_VDEVICE_SUB(PROMISE, 0x8871, PCI_VENDOR_ID_PROMISE, 0x4312),
> +		.driver_data =3D st_P3,
> +	},

[Severity: Low]
This isn't a bug, but placing the opening brace of the 0x8870/0x8870 entry
between the pluto and p3 comments shifts the model comments for these four
st_P3 entries by one element, mislabeling 0x8870/0x8870, 0x8870/0x4300, and
0x8871/0x4311 and leaving 0x8871/0x4312 uncommented.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111183844.1906=
794-2-u.kleine-koenig@baylibre.com?part=3D1
