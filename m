Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022CB1C701F;
	Fri, 24 Oct 2025 17:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761326537; cv=none; b=V/2XXyzX7h0lQO25KlIUPmRGZhlvwxGrfXHfYKWWMvP87NUpFDiC6ftvcnJAP5RhLEjqvEgEsvLjv5J7zd+xifUdW/k9sUw3Kp+26E/+86jd6ZGGgA4gO9/AKPydKxbzzKCtRtgp3SqWejXpg136fDvGv6TpGndayl7j/+ye6JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761326537; c=relaxed/simple;
	bh=I28tj+5p1lYh91jL3bRG2Q0tjvvTsVTFnIaEJgJIkyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVUHSvTUA1PRfi9pYaAYe/OBDIW2OZEtUEsQOlBSdi+Hb6w7ENBC456nWYTDBFeVov7PfqNHjFfTNV0nN/G5MQ8qKWOQUlUIlcI0inA+x9/8aTth2fbo8j9vj6/quhuGdan3Vh3jb0mJx6QRXX3yaYO1wf/JBKtE37sJRdTr+3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUa1Cnrt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUa1Cnrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4763C4CEF1;
	Fri, 24 Oct 2025 17:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761326535;
	bh=I28tj+5p1lYh91jL3bRG2Q0tjvvTsVTFnIaEJgJIkyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KUa1CnrtPNrwbyc9xwjIax/HdQ2x3NsIhO7pb6nClIhH1HYrZm/pecefHnbdI/AFE
	 XKmg9qW7lAVps/bhq52idx/TMs+BGBtjNRp6IxGiDR2JyfhTvs/gNQAnq+LFXHzg5J
	 kEp2wtLF0ScSk5v1GHouz8Y3snLJ3eGlWDChCPUPr3e3ESzAattpK7p3g0QhxZ80z7
	 Agsmaq/4rxfXSUymVOSxXkXtki/JOutcZ773KHCWNQX5b6CbgtNRN3McR2floLh3Uh
	 LPSgSMrnxFvHSlnIFQKmaKJkYXHYPUjxif1yqFkNNsLgw99QoZTbDDOAtFDLtBQzik
	 0/d9q29YuIRoQ==
Date: Fri, 24 Oct 2025 18:22:08 +0100
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
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	kernel@collabora.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH v3 00/24] MediaTek UFS Cleanup and MT8196 Enablement
Message-ID: <20251024-startup-glimmer-64480e02bd26@spud>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="neMgzJxl9Udqmnxf"
Content-Disposition: inline
In-Reply-To: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>


--neMgzJxl9Udqmnxf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 09:49:18PM +0200, Nicolas Frattaroli wrote:
> In this series, the existing MediaTek UFS binding is expanded and
> completed to correctly describe not just the existing compatibles, but
> also to introduce a new compatible in the from of the MT8196 SoC.
>=20
> The resets, which until now were completely absent from both the UFS
> host controller binding and the UFS PHY binding, are introduced to both.
> This also means the driver's undocumented and, in mainline, unused reset
> logic is reworked. In particular, the PHY reset is no longer a reset of
> the host controller node, but of the PHY node.
>=20
> This means the host controller can reset the PHY through the common PHY
> framework.
>=20
> The resets remain optional.
>=20
> Additionally, a massive number of driver cleanups are introduced. These
> were prompted by me inspecting the driver more closely as I was
> adjusting it to correspond to the binding.
>=20
> The driver still implements vendor properties that are undocumented in
> the binding. I did not touch most of those, as I neither want to
> convince the bindings maintainers that they are needed without knowing
> precisely what they're for, nor do I want to argue with the driver
> authors when removing them.

Some of these are pretty recent too, it would be /wonderful/ if the ufs
maintainers would do what everyone else does and require that these new
devicetree properties come with binding changes.

I had a skim of them, and on the surface at least some of them some
reasonable, but it is difficult to ascertain whether the information
could be gathered from another source. Others though (the supply stuff)
seem bogus at first glance.

>=20
> Due to the "Marie Kondo with a chainsaw" nature of the driver cleanup
> patches, I humbly request that reviewers do not comment on displeasing
> code they see in the context portion of a patch before they've read the
> whole patch series, as that displeasing code may in fact be reworked in
> a subsequent patch of this series. Please keep comments focused on the
> changed lines of the diff; I know there's more that can be done, but it
> doesn't necessarily need to be part of this series.
>=20
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

--neMgzJxl9Udqmnxf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPu1wAAKCRB4tDGHoIJi
0vj7AQD/qMUfkmvkG5iyPjCXcZDX8DMNZCwnz8m5hn6oc9PBqgEAn3C/Eixdj5+2
V5Ordm3MjSUlMvxa4MDfaFftrECzpwE=
=dTaQ
-----END PGP SIGNATURE-----

--neMgzJxl9Udqmnxf--
