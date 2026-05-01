Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A543C1400;
	Fri,  1 May 2026 17:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777654984; cv=none; b=OdNmM9blqgIy4etjAdOhwRLQwj+DVof+tIayTQRZjuoU5HUN1NGnquDLgFjp23BcFDOVr2i0FG0JzJR87TlGIR3pCPb4v9sXp2FrYk36vFqX3d/ZfdaC5e0TcOVtdMX2aZvn/gSJU1QG5gXp7avlXvyOOxiux+jw2rnK3qbnwm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777654984; c=relaxed/simple;
	bh=8GvZWFD9xh/Bxx1Omdts7uL97aN6epJ/NSyX8QGcdw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Miee7GkJC4rzsgfT3lq/krGZfAQID6oBtPg2s00OTnjurI8bzHmE4/pJnsU/xEidI+Eu0Jtc0/3QSccuCASAL8rq0cvgUBBa2pM2Wi5Y0swFzN/wsyPaewowgLYxILc8b8q88RZbFVOAqMCbijH1BhIGfIeL/0+znPypfl+BY+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SYB3YCTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SYB3YCTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49821C2BCB4;
	Fri,  1 May 2026 17:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777654984;
	bh=8GvZWFD9xh/Bxx1Omdts7uL97aN6epJ/NSyX8QGcdw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SYB3YCTlBgtZ5O7UnGDqbws87GO1iI3MRNp3qDOMBijL+cCbCV+gB8Mj2YSP4lUib
	 364Mi+brhRGSCt7qyVfHBOFvEiYV84DTezlnJaBgcUyUbrjIuOunJncfENZPYHPqVr
	 t44aBnaIZyc7G0KN9XHttW7IR3zkX30XumMSXveRJsAzvWk0UHaOJ3ADwpgBKBK0IW
	 LOZe3ufkZu1vPhrRK5JzOaiKBJHdm37MRnjEMNoMc/NRwtTKrQwyPuJoAUGEN4kCFE
	 8UgCbdWbWX0nw9CEDgxdXxWjVFwDbuF21Cm0v8nGg9iWWwDo4vyj87Ez7qURtWdDyw
	 7qzskZBedd56Q==
Date: Fri, 1 May 2026 18:02:58 +0100
From: Conor Dooley <conor@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
	martin.petersen@oracle.com, mani@kernel.org,
	linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
	Zhaoming Luo <zhml@posteo.com>,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
Message-ID: <20260501-exhale-nutshell-3d80a8a2d791@spud>
References: <20260501134418.863432-1-can.guo@oss.qualcomm.com>
 <20260501134418.863432-2-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zZv6/IXBq9h6cyVd"
Content-Disposition: inline
In-Reply-To: <20260501134418.863432-2-can.guo@oss.qualcomm.com>


--zZv6/IXBq9h6cyVd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 01, 2026 at 06:44:17AM -0700, Can Guo wrote:
> HW design team usually provides static TX Equalization settings based on
> PCB board characteristics. These settings can be passed from the device
> tree to configure the TX Equalization parameters (PreShoot, DeEmphasis,
> and PreCodeEn) for Host and Device across different HS gears.

I'm not familiar enough with ufs stuff to tell, but this commit message
sounds very qcom specific, but this is being added to a common file.
I'd like to see a lot more detail in the commit message, detailing why
this is truly applicable across IP vendors.

>=20
> Add patternProperties for txeq-settings-g[1-6] to support specifying
> static TX Equalization settings.
>=20
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-common.yaml | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Docu=
mentation/devicetree/bindings/ufs/ufs-common.yaml
> index ed97f5682509..bc83948fc168 100644
> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> @@ -105,6 +105,17 @@ properties:
>        Restricts the UFS controller to rate-a or rate-b for both TX and
>        RX directions.
> =20
> +patternProperties:
> +  "^txeq-settings-g[1-6]$":
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 6
> +    maxItems: 12
> +    description: |
> +      Static TX Equalization settings for High Speed (HS) gears.
> +      The settings are specified as an array of tuples (PreShoot, DeEmph=
asis, PrecodeEn).
> +      The array must contain these tuples in the following order:
> +      Host Lane 0, [Host Lane 1], Device Lane 0, [Device Lane 1].
> +
>  dependencies:
>    freq-table-hz: [ clocks ]
>    operating-points-v2: [ clocks, clock-names ]
> --=20
> 2.34.1
>=20

--zZv6/IXBq9h6cyVd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCafTcwgAKCRB4tDGHoIJi
0vYZAP0e5vAEUy82WqTW/s+caijOyxLNxZItemHDAZwOqKIAkAD9GgJNBiixiK4Q
fLlejc8u/KShPy6JLAz2mwFCLPvW/wU=
=ofFG
-----END PGP SIGNATURE-----

--zZv6/IXBq9h6cyVd--
