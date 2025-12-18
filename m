Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024012C0299;
	Thu, 18 Dec 2025 19:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766085960; cv=none; b=R4366xz0CMCdknRcs3a4G50VJZ2aWqwgCd4Bxxvc4EsHP1n/cEqdZFOgOagOG8opd1W65nGKJMRzRb+cOGMeUDds3N4uvilJlB/soEPQ3eGJK2XUejHcN+qBOJCjXsO68UFFD47PdmMIukp2u41c3d78JUa/FXJMrLB2E3GY9+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766085960; c=relaxed/simple;
	bh=VmqIvCaDEBfkl1zQLnJDo+nqogSVFDTwXWujErxqEy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APjanT1W3ETk5Qxnc2UVQAgH1hv8RAOh54AOMDNapq0v4FNDNNfxLtPNjfPwC3Uw2VvdZFJa6fCgzxXHDPOu/ijNO01HKBSWISmM4+GVPRlEDTJs6d3/MS5TkCM6Wwm8Cn7n/aWgvSdcXLsUAGk58/pIB9kP586VBVnOgHpiSGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GyHdh7l/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GyHdh7l/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7647FC4CEFB;
	Thu, 18 Dec 2025 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766085959;
	bh=VmqIvCaDEBfkl1zQLnJDo+nqogSVFDTwXWujErxqEy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GyHdh7l/mAyTrZcfR6f5ePTnC2/YvWmX0fLaG9QC1apjSTXILEXTadVu5Cull2JKc
	 Bn71LQj6X3St+RrBoU5xVoeSWG9Gn80BZPd+pk23ZRE4xjxNmtB08hjPHTf3/aFojw
	 85HAaptSMNMk8il8yuXg0TQUBUruC+917wy/N8avbmWjb4716gbTN3xA12AYP9DEdo
	 OnKz71JEWAl6M34mgQBFtsjwUJcbDVZr9IUomuMpS5OAKuc9MgaqQbPztY9FK0ugIl
	 4u1sCV5QdDCvNg7q0kmKibaGPtWSb9RFuJFhsbleHuy0bsL7+Q51BNd5n26EoRe94Y
	 23bAJsDBQD3pQ==
Date: Thu, 18 Dec 2025 19:25:52 +0000
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
Subject: Re: [PATCH v4 01/25] dt-bindings: phy: Add mediatek,mt8196-ufsphy
 variant
Message-ID: <20251218-spur-uncover-04320ae6df16@spud>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
 <20251218-mt8196-ufs-v4-1-ddec7a369dd2@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+6lhiMDFrFVfpZtN"
Content-Disposition: inline
In-Reply-To: <20251218-mt8196-ufs-v4-1-ddec7a369dd2@collabora.com>


--+6lhiMDFrFVfpZtN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--+6lhiMDFrFVfpZtN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaURVNwAKCRB4tDGHoIJi
0vlsAQDH8HhrkWqkKxEwnqwdVW1PUodcKR+KR0Tt8dUe0temKQD9HWA715OQFthv
nNC+30DA7E44y9cBr7tuFNHkhhGcvg8=
=Rc5D
-----END PGP SIGNATURE-----

--+6lhiMDFrFVfpZtN--
