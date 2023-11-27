Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372F61C292;
	Mon, 27 Nov 2023 17:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBlp5pNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBD9C433C8;
	Mon, 27 Nov 2023 17:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701106952;
	bh=qglVjzsLYuACzu0+FICh+JqZnBV8rbxXDMwLeP40ut0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iBlp5pNzxJcEub77PR2l8jiM8+nBXcyFTFG+sdb6uSknyRgw6PxlMtj3So8f3B6iO
	 SCpLjfMMfh/+3P6OUIbjujtaqcQfQXmPE8Had+x9WqOam+upB96QuVm4Ddwiz8PwLy
	 Sm9PZ+0nHmjDQ+hIXSMzR1JBXUQS2fzpOhQwpR2+wbwyn31+QNxxa25x4btjZhNQOd
	 zLLlrFV3FloXQQTIKHwZ3s2MO70Z6fIL1ptzrBOmcTtGsS8zCV/w/r7iyKCs7CXkuh
	 3ubammimbnOUHTFxHgfm2AhXkDbAQ5GUemYVNwGC9bxvkWyeSYiyk7DoJVBSWhhAPF
	 G7el3IP1yZHsg==
Date: Mon, 27 Nov 2023 17:42:25 +0000
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
Message-ID: <20231127-opposite-haste-4c9049cecf91@spud>
References: <1701063365-82582-1-git-send-email-quic_ziqichen@quicinc.com>
 <20231127-glimpse-demotion-6adae40eee30@spud>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sDDXzRYQ9u2VJHe4"
Content-Disposition: inline
In-Reply-To: <20231127-glimpse-demotion-6adae40eee30@spud>


--sDDXzRYQ9u2VJHe4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 27, 2023 at 05:40:45PM +0000, Conor Dooley wrote:
> On Mon, Nov 27, 2023 at 01:36:02PM +0800, Ziqi Chen wrote:
> > The Message Signaled Interrupts (MSI) support has been introduced in
> > UFSHCI version 4.0 (JESD223E). The MSI is the recommended interrupt
> > approach for MCQ. If choose to use MSI, In UFS DT, we need to provide
> > msi-parent property that point to the hardware entity which serves as
> > the MSI controller for this UFS controller.
> >=20
> > Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
> >=20
>=20
> > V2 -> V3: Wrap commit message to meet Linux coding style.
> > V1 -> V2: Rebased on Linux 6.7-rc1 and updated the commit message to
> >           incorporate the details about when MCQ/MSI got introduced.
>=20
> This should be below the --- line FYI. With that fixed,
> Acked-by: Conor Dooley <conor.dooley@microchip.com>

Also, you omitted an ack from Krzysztof in
<ae2f2dc9-4c08-4db8-bfae-80608723d8c3@linaro.org>

Cheers,
Conor.

--sDDXzRYQ9u2VJHe4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZWTVAQAKCRB4tDGHoIJi
0qcCAP9bHZ49nXmURZnHmlf2EEcInhjXjeZ63oj1Q/CL79VJfQD9GIlDKTFTdnti
UyGxMfITQWLXzCi2g64ZneSu6p1HEgE=
=OQCh
-----END PGP SIGNATURE-----

--sDDXzRYQ9u2VJHe4--
