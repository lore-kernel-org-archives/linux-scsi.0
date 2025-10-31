Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282ED2BD580;
	Fri, 31 Oct 2025 15:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761924320; cv=none; b=kYNzzOLwUSvotXKHccikIbxE1H0QmfieDN8R/+g+UhkHw/agK9iNppevIEOO/U7L5mvq0zr3++KI2JHkBd4AtkyDp/DycEei5iUJMJ7s/zxTBlx734u97RJKUmuDQknyKgx3QRjsK6gm0kEsHA1Pp953uDw3P7PxmVvHtc/T6Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761924320; c=relaxed/simple;
	bh=KFhm8QSHFsaBzVtjUGvWFwTajdebEfWzr4twGJPGSbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emJlgzWU7x2h46I+eqD6+cHO+aje8IW0T+TpoM4KDimxSGHueLt3YuF7PJd7EsnZToL6gu47MU9kSAHfSHqehKXMy19kkj4sDApreiwbA5/sly3kltKJN+CVsHeaIna4ftTKinE8+fnuZ+20myDOysOmkuK/FIU2kI5nhGtarXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1ijWR18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1ijWR18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60665C4CEE7;
	Fri, 31 Oct 2025 15:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761924320;
	bh=KFhm8QSHFsaBzVtjUGvWFwTajdebEfWzr4twGJPGSbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A1ijWR18kMG/0SkKaVg7f3w9jv18uN628InDoCYiZkZjUPvp5nvKELsS0mRqR5nxg
	 ZYEBsmM39/GvJGLwuFP8biHGj5U7k+2B6IyiA+wSub7yP46Zp2uLevvirb5IiBq9Qn
	 27aA2ymj1KiowLIu7POr+6KOEJTj3Kr8x/B8nO7OXG24zpxMGvSwSd4K2vm/zYT20i
	 IKF9lwpbYOKByVoQ6VwKgURufVDLdLOQNuzN7E6b7iIWEmbq7gP4uJuV3jHByaJkPl
	 nH2OMvAG3C2LagyKuFTHwIt9SDYAFI5FShmIsCUu57B74h5CspkWdKbiZFfpRgKN1z
	 74Du7awCWQTUg==
Date: Fri, 31 Oct 2025 15:25:13 +0000
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
	michael@walle.cc, conor.dooley@microchip.com, chu.stanley@gmail.com,
	chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
	naomi.chu@mediatek.com, ed.tsai@mediatek.com
Subject: Re: [PATCH v1] dt-bindings: ufs: mediatek,ufs: Update maintainer
 information in mediatek,ufs.yaml
Message-ID: <20251031-chokehold-whimsical-f170ff80a3df@spud>
References: <20251031122008.1517549-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FZhgm9MdlRUb4vyf"
Content-Disposition: inline
In-Reply-To: <20251031122008.1517549-1-peter.wang@mediatek.com>


--FZhgm9MdlRUb4vyf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2025 at 08:19:12PM +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
>=20
> Replace Stanley Chu with me and Chaotian in the maintainers field,
> since his email address is no longer active.
>=20
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--FZhgm9MdlRUb4vyf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaQTU2AAKCRB4tDGHoIJi
0lxDAQDnqUv3F3CoI6VNQS/YLHR+P/uzSEC4D8N+dRkjtTURqAEA6gZf8OgzCdGv
/YO0n/TF4LFqZP8UAriDm1Ac3yPkfgc=
=0uFI
-----END PGP SIGNATURE-----

--FZhgm9MdlRUb4vyf--
