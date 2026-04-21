Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A2326E71F;
	Tue, 21 Apr 2026 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776791036; cv=none; b=ei3Zu5H5Ss7AvgahH5OQbU1kwT7oAFdFZ4lHxEW5cUPfG71YI3OsT5+1klw6wlTOPQ2xb3BL0q0j+v5ULQc7cATqiTW4GgNNAg1YSREiGVnqC2N/C5fsxLYpBOZSxgcJftb5i70nRvvLx1dQ++FHRQT8u4h8KNF4KPCJAB8CSvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776791036; c=relaxed/simple;
	bh=0vjQ9Y6dD5TiOFno1Q68yXI5D0Y2pLi1DknZIvVD400=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QjxJHqYMC/HimL2RFilLFItU59M2IBLK6NLXQmCml+cGlqvHT1XhJaYh3MADEYjTsplyPV00+z1hgPzJYxVowcfaV1hqTWs+dGm3C/M3kuNk1fD6M1NXG727NxwwMGpwdSIJnNNcfcwsKgCnTNgjLdff/Gb6rUsYQAUuzZ31hho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1Cut8L5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1Cut8L5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39614C2BCB0;
	Tue, 21 Apr 2026 17:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776791036;
	bh=0vjQ9Y6dD5TiOFno1Q68yXI5D0Y2pLi1DknZIvVD400=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q1Cut8L5nPZLACraL34et+ZDudtOmllGmjvGe4FctvAaXredYdyhE7FtLihMVckV1
	 b3RFRH+oIiaJxvEI8cfHLE1vB3Ug0yMnwTHRY2zZ4FzBhDd+0UaJ1tGYFN1eHeWoEw
	 P/MO0dwrBEmmChUGpf0a7YOL6h2Ckgi+cLdmEWF1j/K++tV5dsb/0mYIoKix6ELpWv
	 5ZZAI2FsK6aBzwI9njKh9+wiCDxSb6r3xd+OTDE1HCD/h4enKGjC9w10yd0m7Lewso
	 DiYpW5YNhU64cbkIPqYBdRNVeTS/TC/Fx+ujxP1TPayZ2YrW44tdOk0GsfrGB8wqk5
	 hgSRXpnwUhHNw==
Date: Tue, 21 Apr 2026 18:03:50 +0100
From: Conor Dooley <conor@kernel.org>
To: Minda Chen <minda.chen@starfivetech.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v1 1/3] scsi: ufs: dt-bindings: starfive: Add UFS Host
 Controller for JHB100 soc
Message-ID: <20260421-appetite-vowel-ce0837f5625b@spud>
References: <20260421091215.120632-1-minda.chen@starfivetech.com>
 <20260421091215.120632-2-minda.chen@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BeD+x9onsyh/EoOc"
Content-Disposition: inline
In-Reply-To: <20260421091215.120632-2-minda.chen@starfivetech.com>


--BeD+x9onsyh/EoOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 05:12:13PM +0800, Minda Chen wrote:
> Add devicetree document for UFS Host Controller StarFive JHB100 SoC.
> The UFS controller is based on the Synopsys DesignWare UFS controller.
>=20
> Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
> ---
>  .../devicetree/bindings/ufs/starfive,ufs.yaml | 76 +++++++++++++++++++
>  MAINTAINERS                                   |  5 ++
>  2 files changed, 81 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/starfive,ufs.ya=
ml
>=20
> diff --git a/Documentation/devicetree/bindings/ufs/starfive,ufs.yaml b/Do=
cumentation/devicetree/bindings/ufs/starfive,ufs.yaml
> new file mode 100644
> index 000000000000..c408973dd0ce
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/starfive,ufs.yaml

Filename should be starfive,jhb100-ufs.

> @@ -0,0 +1,76 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/starfive,ufs.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Starfive Universal Flash Storage (UFS) Controller
> +
> +maintainers:
> +  - Minda Chen <minda.chen@starfivetech.com>
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +properties:
> +  compatible:
> +    const: starfive,jhb100-ufs
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    items:
> +      - description: UFS reference clock
> +      - description: UFS main enable clock
> +
> +  clock-names:
> +    items:
> +      - const: ref_clk

Think "ref" suffices here.

> +      - const: ufs
> +
> +  resets:
> +    items:
> +      - description: UFS main reset
> +      - description: UFS PHY reset
> +
> +  reset-names:
> +    items:
> +      - const: main
> +      - const: phy
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  starfive,syscon:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    description:
> +      The phandle to System Register Controller syscon node.
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - resets
> +  - reset-names
> +  - interrupts
> +  - starfive,syscon
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    ufs@11b10000 {
> +        compatible =3D "starfive,jhb100-ufs";
> +        reg =3D <0x11b10000 0x20000>;
> +        interrupts =3D <105>;
> +        clocks =3D <&syscrg 4>,
> +                 <&syscrg 5>;
> +        clock-names =3D "ref_clk", "ufs";
> +        freq-table-hz =3D <26000000 26000000>,
> +                        <100000000 100000000>;
> +        resets =3D <&syscrg 10>,
> +                 <&syscrg 7>;
> +        reset-names =3D "main", "phy";
> +        starfive,syscon =3D <&syscon>;
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 32bd94a0b94c..3792c51da63c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -27190,6 +27190,11 @@ L:	linux-scsi@vger.kernel.org
>  S:	Maintained
>  F:	drivers/ufs/host/ufs-renesas.c
> =20
> +UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER STARFIVE
> +M:	Minda Chen <minda.cheb@starfivetech.com>

Typo in your email address here.

pw-bot: changes-requested

Thanks,
Conor.

> +S:	Maintained
> +F:	Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
> +
>  UNIWILL LAPTOP DRIVER
>  M:	Armin Wolf <W_Armin@gmx.de>
>  L:	platform-driver-x86@vger.kernel.org
> --=20
> 2.17.1
>=20
>=20

--BeD+x9onsyh/EoOc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaeet9gAKCRB4tDGHoIJi
0h0hAQD1C2lWY7cSC00wSe7joATUSIpjBI6Cx3TuNjrVrWb06AD/XGUJZEm9k8qw
mfhfFn0AgmdvixEu6ZccTqYwM6IfrAk=
=i4yy
-----END PGP SIGNATURE-----

--BeD+x9onsyh/EoOc--
