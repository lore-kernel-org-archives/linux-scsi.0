Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564A42D978A;
	Wed, 22 Oct 2025 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154710; cv=none; b=nZsLejocZEapg5a4ic+NOH+NiyBmdlKRlKnyOpYnWI4esN6CAdkuM4ybiyo/vS9YZYAaFxGvpz3AdWfxB6L8qhu6DVaHeBi+AWT/4QxZOhH9x0h0omulhzgQAY4ko2WVh3BE00cZ0CYFK07331LdqlgizcsdbfEQH0boqWSsqqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154710; c=relaxed/simple;
	bh=a1713ONLo4RRLM5SYdpDsSJ1reTF4CU+Bkx3+uaYeUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UYGO5dKuDb5Qmm5TfZXFhg53DgsK/cnoHi7oGRcDeFEIuqIzKy6qDF3mznd5qobMxBZy+M99oP25KtgRSeiTK8czKzcILE89Si0bXXKojP3S6TphZz2VEh7XlHk5PyjAIcOB5xshbaHDT9mJWCRsxwCmH56Wrfd1yo2+ObbMkzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXwRMOxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXwRMOxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF5BC4CEE7;
	Wed, 22 Oct 2025 17:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761154709;
	bh=a1713ONLo4RRLM5SYdpDsSJ1reTF4CU+Bkx3+uaYeUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nXwRMOxQzPi/uWx8kqqPhc105lzgifneVm0cxnDOtGQZpxG0jhlcCiYYxqeF57x+g
	 C0uBg5A0OnKTklrIp6vQ+TKzGGi2WZr7Oi1vCr/JvABCJrQGGD9iJngCe7n5IC57ij
	 ngHZuz2F8jd0IE5JutXqMcyrioQNPGDyvqh7NarKU1tyd+RvVQEYbye3KxCn+yZd9W
	 u773CHia1mMu36022nIQz0IY9aUae4qpApaiBCYno25C6DnCIh3M+jpbccTi9oMhhO
	 lCtUpBg2C5Hhp12ONLh8MkF9IjDfy9grc44k4IwnQIvnQDSh6c3KlqEU9IyfHD7pNz
	 uAorG/wL6vL2w==
Date: Wed, 22 Oct 2025 18:38:24 +0100
From: Conor Dooley <conor@kernel.org>
To: Ajay Neeli <ajay.neeli@amd.com>
Cc: martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com,
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	pedrom.sousa@synopsys.com, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, git@amd.com, michal.simek@amd.com,
	srinivas.goud@amd.com, radhey.shyam.pandey@amd.com,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Subject: Re: [PATCH v2 1/4] dt-bindings: ufs: amd-versal2: Add UFS Host
 Controller for AMD Versal Gen 2 SoC
Message-ID: <20251022-collar-relation-48c77e7649cb@spud>
References: <20251021113003.13650-1-ajay.neeli@amd.com>
 <20251021113003.13650-2-ajay.neeli@amd.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YMFu5lM+sEy/WU91"
Content-Disposition: inline
In-Reply-To: <20251021113003.13650-2-ajay.neeli@amd.com>


--YMFu5lM+sEy/WU91
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 05:00:00PM +0530, Ajay Neeli wrote:
> From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
>=20
> Add devicetree document for UFS Host Controller on AMD Versal Gen 2 SoC.
> This includes clocks and clock-names as mandated by UFS common bindings.
>=20
> Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
> Co-developed-by: Ajay Neeli <ajay.neeli@amd.com>
> Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--YMFu5lM+sEy/WU91
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPkWkAAKCRB4tDGHoIJi
0tFeAQC5wO+4QHuc/nza8lgJiNnzXpQpd/t7M113YD3RktfwbwEA7H9xWVRI2j60
O4mTnvVfLvvWAHKmkj03OzvdIt95/Ao=
=ZXJP
-----END PGP SIGNATURE-----

--YMFu5lM+sEy/WU91--
