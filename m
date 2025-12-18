Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DC6279DC2;
	Thu, 18 Dec 2025 19:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766086719; cv=none; b=rGiul7GoiB2AhZzBey42CV5KCIgklS4fsxfs2zCYaf54vBYMI8PM8Hfj+fZJi1DZGrPU4umJQxoUb34oF5XJP8L6QEwd3q7ANC0QEhBEBR/YiMKRGAGqp+aUWK5HrTWnDtjWeWCEvVoANKwQe4ivQsEeMY2cZQjK8mvkZO8a0SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766086719; c=relaxed/simple;
	bh=XJjLZdefB3rFjATsz57WhyB21r3EJBYz8JYK0SddZl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NAQDpG7lsnZA+EjKVUMJEKPld2Bwf2EHe52uzoulsVaUpYdtHDesm/6mdRWo3wq+M/6WkI7UONZO2LDz8p7tMWa9WG060UPcDp+7tCXrSVVf3UTxLNRjIsq5NkTym1BFOTmdW7Jr4a0kFEMMKD0VUe47dF2gQFZzX4jjTGZzO7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aE4uGfGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aE4uGfGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC84C116D0;
	Thu, 18 Dec 2025 19:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766086718;
	bh=XJjLZdefB3rFjATsz57WhyB21r3EJBYz8JYK0SddZl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aE4uGfGSE1RZd+bmVNuLg6Qrcu3P+HfwD3boH2MpXLW/ZLWvns5bEUicKNpGgS9D/
	 Rnh6be4JCCHnyuq6KKSyDyQIyDnW4UrxRC9fz98lUh8/2LKCPdMzOu/p29S4Cyhrke
	 1dJGsFbYd8DE6yR9YGV/d1YIxa/fRnw4Apf7xJIo3d3wFQiqv+zem5QqChFg/0aJId
	 64FXhXwB1WepTSTVT457ZUQfw7tQq6D3qZYJeWkqkUx0M/FE8KHD3NDovVqT+THutA
	 2stygJ9bNzUFL5tcnPh9nm7DMmjhYlmxCfWR80/RZ7XwQN+IhuwMZ1hNRJDLq19PHN
	 uek0BBTTyNPCg==
Date: Thu, 18 Dec 2025 19:38:31 +0000
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
Subject: Re: [PATCH v4 02/25] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Message-ID: <20251218-vineyard-exalted-08fe7d9bcb55@spud>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
 <20251218-mt8196-ufs-v4-2-ddec7a369dd2@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="e36ubsezNTceBFN4"
Content-Disposition: inline
In-Reply-To: <20251218-mt8196-ufs-v4-2-ddec7a369dd2@collabora.com>


--e36ubsezNTceBFN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 01:54:52PM +0100, Nicolas Frattaroli wrote:
> As it stands, the mediatek,ufs.yaml binding is startlingly incomplete.
> Its one example, which is the only real "user" of this binding in
> mainline, uses the deprecated freq-table-hz property.
>=20
> The resets, of which there are three optional ones, are completely
> absent.
>=20
> The clock description for MT8195 is incomplete, as is the one for
> MT8192. It's not known if the one clock binding for MT8183 is even
> correct, but I do not have access to the necessary code and
> documentation to find this out myself.
>=20
> The power supply situation is not much better; the binding describes one
> required power supply, but it's the UFS card supply, not any of the
> supplies feeding the controller silicon.
>=20
> No second example is present in the binding, making verification
> difficult.
>=20
> Disallow freq-table-hz and move to operating-points-v2. It's fine to
> break compatibility here, as the binding is currently unused and would
> be impossible to correctly use in its current state.
>=20
> Add the three resets and the corresponding reset-names property. These
> resets appear to be optional, i.e. not required for the functioning of
> the device.
>=20
> Move the list of clock names out of the if condition, and expand it for
> the confirmed clocks I could find by cross-referencing several clock
> drivers. For MT8195, increase the minimum number of clocks to include
> the crypt and rx_symbol ones, as they're internal to the SoC and should
> always be present, and should therefore not be omitted.
>=20
> MT8192 gets to have at least 3 clocks, as these were the ones I could
> quickly confirm from a glance at various trees. I can't say this was an
> exhaustive search though, but it's better than the current situation.
>=20
> Properly document all supplies, with which pin name on the SoCs they
> supply. Complete the example with them.
>=20
> Also add a MT8195 example to the binding, using supply labels that I am
> pretty sure would be the right ones for e.g. the Radxa NIO 12L.
>=20
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--e36ubsezNTceBFN4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaURYNwAKCRB4tDGHoIJi
0q7sAPsEFBYWe7WteUvYRPLscugO7jF/qeqwh5oNpsK5iTFYHgEA4FfIV6OJUU/h
uy3jGyM2gNo0F1otONhbNZUky5Matgg=
=JyRf
-----END PGP SIGNATURE-----

--e36ubsezNTceBFN4--
