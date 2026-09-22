Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793FC443E4D;
	Tue, 22 Sep 2026 09:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790069127; cv=none; b=DETIxWtq5ZNPL1VN+S7RVe80p8yt9Kd4bLawscsOr8dwpOuVPsUVYwjwuBgx1NlzILEADlVEl+uKOpZDJIelE40OrmRNFMi0gMRmUUCp+3tvqU1oWAspmxox09NWzslyxRb6RlviLzdf4kL5cueVRfNnWafukhCyf0z6do3z0ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790069127; c=relaxed/simple;
	bh=Q9gZjzEG8eqqtIXa1GCIg+oajKTGvuL2w+lld+u2M7w=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=svS5+kc6N2tUz4SGl1If0oAXdNm4vWtuXqRgtxm82rv4DnsUR+BBSRqkH543pd9DSnJhPJYU0zZxJzbmN4Tn8ifnapRSzXEGtL+iBeP4VzjbFqTdTjWk+73egYGspsFS7J4vzyPqTRKNVnQFSl1ZpH8chRrvAG/O/8s5/M75Y0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.spacemit.com; spf=none smtp.mailfrom=linux.spacemit.com; dkim=pass (1024-bit key) header.d=linux.spacemit.com header.i=@linux.spacemit.com header.b=kNI2Pems; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.spacemit.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.spacemit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.spacemit.com header.i=@linux.spacemit.com header.b="kNI2Pems"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.spacemit.com;
	s=mxsw2412; t=1790069113;
	bh=MqF3JT5Ag+/84VYxDV0JRl7knayiQkoPpeM2DvkLl/0=;
	h=Mime-Version:Date:Message-Id:Subject:From:To;
	b=kNI2PemsI3mY3iPxh23NyUdkDxShOx+36z5xZeKT+SReRM6OlihukcbXeTczh3SpQ
	 Ia9Xv3hZsQDft+ZQgQ+aUc9msHn+fpUM6u12uzgSvBAoIvBChA2Lo0UWmgDHGGs1ri
	 SvxTrIgHM1jr/I5mFUSbzbixdJ2z7G0oClJnW3JA=
X-QQ-mid: esmtpgz10t1790069108teb6a8f46
X-QQ-Originating-IP: X3aDg93GYWSWkmWKw2TeisR1sv3OIpjcWXfaT9hhycM=
Received: from = ( [120.237.158.181])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 22 Sep 2026 17:25:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 18293615287119513376
EX-QQ-RecipientCnt: 23
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=c50080b08dfc874b0cb25ecf11d489b0d1e616c2128732cb9c89443b278c;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 22 Sep 2026 17:25:03 +0800
Message-Id: <DLLQJDEA91FU.18Q1TSX09AUR3@linux.spacemit.com>
Cc: "Anirudh Srinivasan" <asrinivasan@oss.tenstorrent.com>, "Aurelien Jarno"
 <aurelien@aurel32.net>, "Jennifer Berringer" <jberring@redhat.com>,
 <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <spacemit@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, "Troy Mitchell"
 <troy.mitchell@linux.spacemit.com>
Subject: Re: [PATCH v6 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
From: "Troy Mitchell" <troy.mitchell@linux.spacemit.com>
To: "Yixun Lan" <dlan@kernel.org>, "Alim Akhtar" <alim.akhtar@samsung.com>,
 "Avri Altman" <avri.altman@sandisk.com>, "Bart Van Assche"
 <bvanassche@acm.org>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Philipp
 Zabel" <p.zabel@pengutronix.de>, "Paul Walmsley" <pjw@kernel.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Martin K. Petersen" <mkp@kernel.org>
Content-Transfer-Encoding: quoted-printable
X-Mailer: aerc 0.21.0-reader-ipc2
References: <20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org>
 <20260921-08-k3-ufs-support-v6-2-3479768a2299@kernel.org>
In-Reply-To: <20260921-08-k3-ufs-support-v6-2-3479768a2299@kernel.org>
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:linux.spacemit.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MYQu2r8WPDZyQS9pRmzK13yJMXPw6R3EvclmD3FtQJpfJ5DgcgFzwhMb
	5Q2KKnf2pni9qwQQJj75UsVr8a8BGfEpAicJDPLe0uueSYiY6ve9J/M2QQo3/DkNqYC5P6w
	2cqOSUS+GDslj5czhUMoFG2Rpq6QC31/7ibzFwNSNebys0OSOQjQFlYLnT1zMB1ByiEhnED
	S1l3aPW2R/D8g0CJSqowbGn+Yqdznv/dXx6yKIKwCxUkkghthSgMLnU+bAEnFfbEAshTKLO
	gSFbfLHSVAaRmXfsS0LuhzjYSRHBEGpcD5wBBWU9WJHGuYs5M60E4j2dXm+pdN8ae6qsfD1
	5sYbnzWwek5ne+cekuW8KxXd1cXI1M+vN0UJNmu5W2hpjCuH9qucRLz9VZoiQ6ia8WzSjdJ
	ecgD8YLr0VPaeaeBXCpX2TkqJi8oBIaS4b6XuNZtcEDAcUThrKmZNY9Wul9Ee62ASJIRRhY
	c9PKNLpVxj5CPrNoUhBnbKftnYmvn/qPceZD9yoD1s48fr/RD4rYjvziJwMlBiGJiblHjC5
	gPbsHduwSDPHlsC9oi3UpAhw227Y8OMQGXaF6PKfRL/zo0JOpPPw3aan3AFUW6Ldsx/L0jn
	pQHpldAxM/B23oYzged2NZuqu2frfZ+E3z+3Iu4rDewT4j5Eu9u91GvQD/fgmqe24oC+0vP
	P21t/4IQMBpyr3GkRyqE+/7WuLAc7kl3d0QX+mQDHwSmMX4O9cSTpx6wBwKBINQ2Emh4u4R
	wsAiZqMCLVetmDpmpUtQ7C4EBQpcZ/sxMYBaf+fFMFo7zzCip7rwjvKxlw6f2RdBpKKdanz
	NXOqYVPZ9cUVnCLwGvbf+oJYz0PUI3SkAYY8Yulxmm19dEtlPDkC+E/lFoL7WG48rW0CaEI
	YIYko4N2tVPut9KEWCjQ3qaFJL666tcWgtk0Pexew6ID40RBr4ruA7pltVnlpX3Qe0znkHc
	Gstk6alV68Cfy3v6B8gGlF+GUC9XHO121+dzR2kX8jhPe/mPAZxdxw2UmO5F8Cp8PwVcsrj
	qjXvahj0mWiKaM5Pah1nAgsYsTkmtusjafeFx+TVZhV1FHHlY/QE04vQByeDQ+R9x24F+Lz
	UCoFoNRCbPdnT8QVpkwoVTpHnZX4zM+/A==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

--c50080b08dfc874b0cb25ecf11d489b0d1e616c2128732cb9c89443b278c
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Sep 21, 2026 at 8:36 PM +08, Yixun Lan wrote:
> [...]
>
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
> +

Should this be `if (err)`? The call chain is:

  ufs_spacemit_uniprov1p6_init()
    -> ufs_spacemit_dme_set()
      -> ufshcd_dme_set()
        -> ufshcd_dme_set_attr()

ufshcd_dme_set_attr() returns 0 on success and non-zero on failure,
including positive UIC error codes. The current check misses those.

Also, ufshcd_link_startup() ignores the PRE_CHANGE return value in this
series' base, so returning an error here alone will not abort startup.

> [...]
>
> +static int ufs_spacemit_apply_dev_quirks(struct ufs_hba *hba)
> +{
> [...]
> +	err =3D ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs))=
;
> +	if (err < 0)
> +		return err;
The same `if (err)` check is needed here for positive DME errors.

> +
> +	return ufs_spacemit_wait_mphy_pll_lock(hba);
> +}
> +
> [...]
>
> +static int ufs_spacemit_init(struct ufs_hba *hba)
> +{
> [...]
> +	hba->caps |=3D UFSHCD_CAP_RPM_AUTOSUSPEND;
> +
> +	return 0;
> +}
> +

--=20
Troy Mitchell

--c50080b08dfc874b0cb25ecf11d489b0d1e616c2128732cb9c89443b278c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIMEABYKACsWIQSL4Ay2cExaPXAQcU2YCe+A+TM0LwUCarJJbw0caUB0cm95LXku
b3JnAAoJEJgJ74D5MzQvJ1gA/22uBA65WxxSQ+7npmcBkm5HKq8LkzpjDIOXS2jr
brfJAQCOnLcMv4qGA1z+Oh4psRDSDEz61/5c2j+bZNBXkVZIDw==
=l/Ay
-----END PGP SIGNATURE-----

--c50080b08dfc874b0cb25ecf11d489b0d1e616c2128732cb9c89443b278c--
