Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9237B27EC7C;
	Sat, 12 Sep 2026 10:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208755; cv=none; b=LCFguhx1sDRINV+gpoXykuubjOYFS1kAZsMUZVOMYI7rDVLr5McQRlLBCsn0H4Xy1xvPGTz0tEjuvnsNH7YgaaE8Fv8KMJFppuwMDxaQncxnQ0k4hy2KzZfE7MB23eWwZ+q8N7hULE6VuRo/BO1UcV4D+KQ3ZxTnld9Mn/+4EgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208755; c=relaxed/simple;
	bh=eqe+0oyBfwwiDPXBm6T1yEoyCTynnJXvTivRorgg22g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P2RAhMcUYSP8cn0DUsmkECMu1M7z3vsYj9YDw/0kKylHXzd3DUG9SXQR5eYvESdW4TC7MH538wIzpFbiY0XMRwNFLRrN8Gshge27vP4OGXW0OnBA2vHqnIpq5UfuBIRX6KYo6EYKlpWFQmy2Dsh8wDZApiJd6EzBmbQDh+6QlJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+zNXvfx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+zNXvfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AEC1F00893;
	Sat, 12 Sep 2026 10:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789208754;
	bh=suJ0uS71GsbfhhW6sx+FaUUox5/Huy7H+9ZmclYomm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z+zNXvfxYwdcwi+fNVkkIbEFOlOdsa2H6Z9v82HV3yqZQTntAMXfOzeUh1OJiLL4D
	 JgKEvVtr0XBXVpYRJbY0CpEC4VPq5oHoo83EW7+EtDlO0L26igZ7xE9+jHPSUvXX9D
	 Q5qwa5PMS0mgHaR2WXDM9BwyaO66ht9zWkWvtGFfIOkt5PH+akb0+J9iKhMF7Fw8co
	 6jiopUYKBeCeW7XT126kbOCc1Lmg2cPe/YJPwGzaOicT0svJPD3Jnc3zcrPf10B5Dc
	 ORDovhaMBzakCvvvldPllZ8xPkIhoJwZSxCpt8g30XAw+JhsF6ctKM3RlRod9UwVTI
	 /NGMqEI46ltOQ==
Date: Sat, 12 Sep 2026 11:25:48 +0100
From: Conor Dooley <conor@kernel.org>
To: Minda Chen <minda.chen@starfivetech.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/3] scsi: ufs: dt-bindings: starfive: Add UFS Host
 Controller for JHB100 soc
Message-ID: <aqUorPJziAtWeSG0@squawk>
References: <20260911102359.83288-1-minda.chen@starfivetech.com>
 <20260911102359.83288-2-minda.chen@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="E4vetuRmcDP9RnWo"
Content-Disposition: inline
In-Reply-To: <20260911102359.83288-2-minda.chen@starfivetech.com>

--E4vetuRmcDP9RnWo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 11, 2026 at 06:23:57PM +0800, Minda Chen wrote:
> Add devicetree document for UFS Host Controller StarFive JHB100 SoC.
> The UFS controller is based on the Synopsys DesignWare UFS controller.
>=20
> Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
> ---
>  .../bindings/ufs/starfive,jhb100-ufs.yaml     | 71 +++++++++++++++++++
>  MAINTAINERS                                   |  5 ++
>  2 files changed, 76 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/starfive,jhb100=
-ufs.yaml
>=20
> diff --git a/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.ya=
ml b/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
> new file mode 100644
> index 000000000000..a65cc9455a85
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
> @@ -0,0 +1,71 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/starfive,jhb100-ufs.yaml#
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
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: main
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
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      The phandle to System Register Controller syscon node.

This should probably say "that contains xyz" where xyz is the thing that
you need up access in your driver. The jhb100 has a large number of
syscons, so knowing what to look for here is essential! (although
realistically you'll set this in jhb100.dtsi and noone will have to look
it up themselves)

Otherwise,
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

pw-bot: changes-requested

Thanks,
Conor.
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
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
> +        clocks =3D <&syscrg 4>;
> +        clock-names =3D "main";
> +        resets =3D <&syscrg 10>,
> +                 <&syscrg 7>;
> +        reset-names =3D "main", "phy";
> +        starfive,syscon =3D <&syscon>;
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fc320b373656..10b0d0839ca4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -28095,6 +28095,11 @@ L:	linux-scsi@vger.kernel.org
>  S:	Maintained
>  F:	drivers/ufs/host/ufs-renesas.c
> =20
> +UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER STARFIVE
> +M:	Minda Chen <minda.chen@starfivetech.com>
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
> +
>  UNIWILL LAPTOP DRIVER
>  M:	Armin Wolf <W_Armin@gmx.de>
>  L:	platform-driver-x86@vger.kernel.org
> --=20
> 2.17.1
>=20

--E4vetuRmcDP9RnWo
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaqUorAAKCRB4tDGHoIJi
0gcdAQDsmQDTi5UxtOtDUn/z/tvkLPR6wxggvel0JcLarSftcAD/fTHQtqCGusgb
UU3aWxTBuahJd+pECSS11GWWhR3Ewwc=
=OKh5
-----END PGP SIGNATURE-----

--E4vetuRmcDP9RnWo--
