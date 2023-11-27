Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B6E23778;
	Mon, 27 Nov 2023 17:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pvv0aHCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E56C433C8;
	Mon, 27 Nov 2023 17:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701106852;
	bh=ASd7HNOCLvajDqM7bkeIb2gghMVUfzmmdhTIGZqmuTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pvv0aHCW0DtzZKvjvXIZwkYYt259J3Ck3NIpXuR+5WM/LLeVkzZaYNJqLTItQQ+kJ
	 PGDelokDttm0zvlhDXhr1kuViE+b1xi2MVY0riYLQQsGod0MXrqpAlvk+lQOeHIVHg
	 VpHePaeufzwgN1XkqsCXdBb8SJDRsG/O+LzpVKf+1UxOWTsF6gzp2QjngkdXVJpvVC
	 1B5nJiZCoMMESAeu2QtA3oxXeywf7bZPtNCHewgv6Q8uFZwxp2ZmoNQKOxQrbqr/TK
	 Zx1GcMjhpUpZWN1sTi3ztCdUlFRnWpW2xItMid0xLDbCCUuLFP7wnbA8OpbYlZGP8s
	 PaYNuOrx0OCVg==
Date: Mon, 27 Nov 2023 17:40:45 +0000
From: Conor Dooley <conor@kernel.org>
To: Ziqi Chen <quic_ziqichen@quicinc.com>
Cc: quic_asutoshd@quicinc.com, quic_cang@quicinc.com, bvanassche@acm.org,
	mani@kernel.org, stanley.chu@mediatek.com, adrian.hunter@intel.com,
	beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
	martin.petersen@oracle.com, quic_nguyenb@quicinc.com,
	quic_nitirawa@quicinc.com, linux-scsi@vger.kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Wolfram Sang <wsa@kernel.org>,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] dt-bindings: ufs: Add msi-parent for UFS MCQ
Message-ID: <20231127-glimpse-demotion-6adae40eee30@spud>
References: <1701063365-82582-1-git-send-email-quic_ziqichen@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="meYWU9+SxTC9ZooD"
Content-Disposition: inline
In-Reply-To: <1701063365-82582-1-git-send-email-quic_ziqichen@quicinc.com>


--meYWU9+SxTC9ZooD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 27, 2023 at 01:36:02PM +0800, Ziqi Chen wrote:
> The Message Signaled Interrupts (MSI) support has been introduced in
> UFSHCI version 4.0 (JESD223E). The MSI is the recommended interrupt
> approach for MCQ. If choose to use MSI, In UFS DT, we need to provide
> msi-parent property that point to the hardware entity which serves as
> the MSI controller for this UFS controller.
>=20
> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
>=20

> V2 -> V3: Wrap commit message to meet Linux coding style.
> V1 -> V2: Rebased on Linux 6.7-rc1 and updated the commit message to
>           incorporate the details about when MCQ/MSI got introduced.

This should be below the --- line FYI. With that fixed,
Acked-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

> ---
>  Documentation/devicetree/bindings/ufs/ufs-common.yaml | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Docu=
mentation/devicetree/bindings/ufs/ufs-common.yaml
> index 985ea8f..31fe7f3 100644
> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> @@ -87,6 +87,8 @@ properties:
>      description:
>        Specifies max. load that can be drawn from VCCQ2 supply.
> =20
> +  msi-parent: true
> +
>  dependencies:
>    freq-table-hz: [ clocks ]
>    operating-points-v2: [ clocks, clock-names ]
> --=20
> 2.7.4
>=20

--meYWU9+SxTC9ZooD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZWTUnQAKCRB4tDGHoIJi
0lkfAQCvRuG2xjcDa3+t00Vi0nYJlmW0utoE6J+FzXzKoY69mgEA7pfEtowMhenM
81QppLYUmCj2rygQBpmYhDJ6qM4hLA0=
=b2Sv
-----END PGP SIGNATURE-----

--meYWU9+SxTC9ZooD--
