Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC5B2C0299;
	Thu, 18 Dec 2025 19:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766085994; cv=none; b=p+JU2wUzifLHgzfN04vRFgav9uSuEh4Vmlb8GjbU98SzefwcU2wB3yQR4cnwxTNxY9sHSqyTV1PCHuJQEtFWAXaZ6QMhKsbSuOrVFg09nw83FiFJlom/Qmwj+odafav1PiiH6yqebTlxOR8tNtKrJrVw9Gc1uq4QY07wQHBA0/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766085994; c=relaxed/simple;
	bh=ck6JnuZO2IHf4mFhwwyyGq/NgmnS+f2cFjCiZKFJGss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RkmGAbCZb9V1cgDzMNsmiSk55PiwaXAzR0ORi2DquM6ilAFGpAv3dlNOncu1iB5xizJoikBA4yRW9/96XLFtlg6puZieyDjbMuqqCWu/HeZBOV67ECOnninRK9BotBMB+VJiwBl7fmQM675M5sT68v8sffniWB43mQJ1E8qvvVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfS6HBdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfS6HBdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D66C4CEFB;
	Thu, 18 Dec 2025 19:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766085993;
	bh=ck6JnuZO2IHf4mFhwwyyGq/NgmnS+f2cFjCiZKFJGss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KfS6HBdHt82WZwMLQLjJSUWAg/kz84o620inHVuyW+kQLja133R76s5UaYNz7Guo2
	 UfuR5OCd5BqyHI2gUdpmdmLXnCY4ZSjZHEY2iARR9+keZ2OH5wpP6Gjlpu8i5LpAVI
	 2bbGNlKkQe1CSj6yaAXViHEQduSLsyAa1pFpc3EPXrw1/Jck6HmO4pyNVKTSUUb01a
	 nHL1TFX48SKvOTR1X743RTsS0EZpuvoKFEw/Gjit23U/hLxv8n1nOXjuRP2eE53SxD
	 2yk8pZoQPwRQFLA4k7E3IY2ITqakRrzzfWc88p67gEdWtth4yy693BUCU4ZsdOqEN5
	 PGlGoJhnGFRkg==
Date: Thu, 18 Dec 2025 19:26:26 +0000
From: Conor Dooley <conor@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Chaotian Jing <Chaotian.Jing@mediatek.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	kernel@collabora.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH v4 03/25] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Message-ID: <20251218-crib-mutilated-0fad21809466@spud>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
 <20251218-mt8196-ufs-v4-3-ddec7a369dd2@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QtbfyB59VQR63T5H"
Content-Disposition: inline
In-Reply-To: <20251218-mt8196-ufs-v4-3-ddec7a369dd2@collabora.com>


--QtbfyB59VQR63T5H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 01:54:53PM +0100, Nicolas Frattaroli wrote:
> The MediaTek MT8196 SoC's UFS controller uses three additional clocks
> compared to the MT8195, and a different set of supplies. It is therefore
> not compatible with the MT8195.
>=20
> While it does have a AVDD09_UFS_1 pin in addition to the AVDD09_UFS pin,
> it appears that these two pins are commoned together, as the board
> schematic I have access to uses the same supply for both, and the
> downstream driver does not distinguish between the two supplies either.
>=20
> Add a compatible for it, and modify the binding correspondingly.
>=20
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--QtbfyB59VQR63T5H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaURVYgAKCRB4tDGHoIJi
0qxYAQD7Sv8qLHWhH0i1qWr84q/8ta4jRgBqJn9ugDnf6JCr7gEAn23RjYh3TAP0
FZSkIbg5O3vu/QV6XTlDz72GWCkj5Q0=
=Gykq
-----END PGP SIGNATURE-----

--QtbfyB59VQR63T5H--
