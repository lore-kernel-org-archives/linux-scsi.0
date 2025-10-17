Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00D6330B28;
	Fri, 17 Oct 2025 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715737; cv=none; b=cekGUNEalaSOoXxz6zITPw1Dxs3TDF75ge+iT99j/Jiil98jO6f+cJC+JtrZocjRe4lIgNTaIgYfd20dq3GUjnl/YRYIHiPW9XnaiUmIY6sJlCzFuNhBFdMHwVhm3xgp7bJE/MyCAbfwWW5eUVNK48bVWdeG1fLmhLNmyjy6mFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715737; c=relaxed/simple;
	bh=hH7dF9cQAKchmw5u3mniBQjr14Sz8+exCeFEIusrxh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RN6xWtLr7qlhqZh9Y95LkDEfgpUMBpsM9NwTbbaOKmjEc50t8wP3S0jlcKKne1btlzH4jj2NmBGgXJ+p194xkEd8msXKZcnMr3rK9+ekB/QCA0d1JX0sP0H/Uvod19RtbHa2RehKl9pdCmyU+GGN7wqdUGhorO04bf348RpkfEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KMluMiL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KMluMiL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1137CC113D0;
	Fri, 17 Oct 2025 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760715737;
	bh=hH7dF9cQAKchmw5u3mniBQjr14Sz8+exCeFEIusrxh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KMluMiL5QoCe7NxG9pTDm3lGLS/3U5xqQFUCnxWm0DoLLTuuUJadY6q0V3lhTUjsO
	 gPBwjhIfAHmmhqf4CHufb+JXCBYBAmyym6CFW6SRyBDtiWwqU07+r3jWcY+Xt/tUhd
	 YOdzbe45XsTy7ei8kWhzxU4stCxVOpssx9WHvH1veZoMjle8Ay3qD23l3qd7N/d7jf
	 prACDTrxQAOnWMfoiDNG1gFHA1a7RzyCsz/zqzyA2tczpnjOQRqOJqEemnL1vOrcpF
	 NL1ADDkF/ZRQsFuYew43aqmuVAM80DDEEmzBwfZUuTL+Ujniwg5GqEtdP+mVDWT/IO
	 R3Y1XtUbvlHTA==
Date: Fri, 17 Oct 2025 16:42:10 +0100
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
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	kernel@collabora.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH v2 1/5] dt-bindings: ufs: mediatek,ufs: Add mt8196-ufshci
 variant
Message-ID: <20251017-remnant-spud-a2a21c2385e6@spud>
References: <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
 <20251016-mt8196-ufs-v2-1-c373834c4e7a@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GINMMiGuzGFK5NYP"
Content-Disposition: inline
In-Reply-To: <20251016-mt8196-ufs-v2-1-c373834c4e7a@collabora.com>


--GINMMiGuzGFK5NYP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 02:06:43PM +0200, Nicolas Frattaroli wrote:
> The MediaTek MT8196 SoC contains the same UFS host controller interface
> hardware as the MT8195 SoC. Add it as a variant of MT8195, and extend
> its list of allowed clocks, as well as give it the previously absent
> resets property.
>=20
> Also add examples for both MT8195 and the new MT8196, so that the
> binding can be verified against examples for these two variants.
>=20
> Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collab=
ora.com>
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

I provided a review on v1 of this series yesterday, although I think
after this v2 was posted.
https://lore.kernel.org/all/20251016-kettle-clobber-2558d9c709de@spud/
I believe all of my comments still apply.

pw-bot: changes-requested

Thanks,
Conor.

--GINMMiGuzGFK5NYP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPJjzwAKCRB4tDGHoIJi
0nLnAQCslCfZeTa+X+DOAoIqdM8SHSTrhRFTAANagkMF0n4O0wD9GLihTxkbKovz
a0mrB8+Q494nk9NX6yCVg7GZYid3yQE=
=FIdn
-----END PGP SIGNATURE-----

--GINMMiGuzGFK5NYP--
