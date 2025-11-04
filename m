Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70642D73BA;
	Tue,  4 Nov 2025 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762277348; cv=none; b=baNEd3tcvPLvm0/a3j2gGq/y7r/DBjAH8BPi61YRkBXh7ONmPOEUi8vDWOF6mwtJTLjOq+XhdSPYiNA/gIP2rEp5SI6uK7Ldv5JWSKeOJBmotRusjTg5TGyR22T4SPkFAzQBZvwUCS/FNJMI73dMtp6rr9y9FMTnRoxhHbIvjHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762277348; c=relaxed/simple;
	bh=tI4PyzTCai+yW0q5uOm9mpxVGyRvru6JHvPPumwn9bI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=InPPjRtMowud33H3jnxwklBGH3Iq0f+hy+Ar9Z+2ggDp+uU28JuOYuju8x2JfSa0R5zwC+0T+pgZOBksRmsc7Pve8mn4O+3MzEoZh1NLXHGO62Yw1tnq/Oik0183g0d6Ilgvqtpq1X4va3b/FA3cl0go3PFddQcutIm4rpjTkuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YorEdEhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YorEdEhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA42C4CEF7;
	Tue,  4 Nov 2025 17:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762277348;
	bh=tI4PyzTCai+yW0q5uOm9mpxVGyRvru6JHvPPumwn9bI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YorEdEhWpDhiQn/NJZEVW1RFMt0ZT8Ch/UFT6N941eIHppjapbMWkDnjL/8IkxU1V
	 rhXwaP4RoWBTrswybIRIY9IYXK70xlwE/BnzQWtg3+quYzwcMuTgeH4dO8D1Kwu21z
	 w60S9nxeN9i/cWoQCyocGiPHnXhqQchmwYlWCCKrv8/N0q22MwwybSWK71pvNXtahA
	 7EWfS9HNjlnKR8o6uNQJS2t5zf/xoN8H2qp+cAil4wE4vEaIaK+r9+Vt82qE93aw1/
	 ar0gCro09h99D1kbK+zAY9v0MAq4i/ftbbuwpskFKncsgNZ2+nI296fVjQx/9Yz2yY
	 E0bu2DzTYAssQ==
Date: Tue, 4 Nov 2025 17:29:01 +0000
From: Conor Dooley <conor@kernel.org>
To: peter.wang@mediatek.com
Cc: linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org, robh@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	jejb@linux.ibm.com, martin.petersen@oracle.com, lgirdwood@gmail.com,
	broonie@kernel.org, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, wenst@chromium.org,
	conor.dooley@microchip.com, chu.stanley@gmail.com,
	chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
	naomi.chu@mediatek.com, ed.tsai@mediatek.com,
	chunfeng.yun@mediatek.com
Subject: Re: [PATCH v1] dt-bindings: phy: mediatek,ufs-phy: Update maintainer
 information in mediatek,ufs-phy.yaml
Message-ID: <20251104-banish-engraved-d26d5856d0fd@spud>
References: <20251103115808.3771214-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EqJ9mvMN5ps+fBwp"
Content-Disposition: inline
In-Reply-To: <20251103115808.3771214-1-peter.wang@mediatek.com>


--EqJ9mvMN5ps+fBwp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2025 at 07:57:36PM +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
>=20
> Replace Stanley Chu with me and Chaotian in the maintainers field,
> since his email address is no longer active.
>=20
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--EqJ9mvMN5ps+fBwp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaQo33QAKCRB4tDGHoIJi
0slUAQDaNzoLm5qRDZGmaVZq1Z15G/qDvAUp/mAoKtEmWaHoBQEA7pl5SuOhpCFo
J+x+0i0xR53Wd/iJidGRqGo/gVi+5w4=
=IlDV
-----END PGP SIGNATURE-----

--EqJ9mvMN5ps+fBwp--
