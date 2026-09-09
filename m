Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BEE2EFD9B;
	Wed,  9 Sep 2026 02:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788920004; cv=none; b=BgnIV51XgyqwYLrpDMUhrQ6HnPXCB66FCUv++vHH37vulbQxB9j/cWKFHVi2qQ0Jr1WO7qiKNY3u9Y4xx0Wx8DUa7em3HZPEEsvH+1NoNUXX/jxvE9l5cR3Er/OCROjDFrIP+j06BpySK4eV0y+GGsPQipkq3chqnP2Tbad9HE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788920004; c=relaxed/simple;
	bh=i5D0sRRNqWJnODBhK6vLZCaGWr7YbhwYLoodbnvoahk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=geqWuJQ9YclCXTl59Le8AmxIDfkBOq+hSstMD8fjkatUQWTRR4HZTFkesjRKTgeetnlFrTtvM3wEcD2tL4HZPhWEQ6Fh6wadd2hn8gcpMk/aQ2zZoR9N3Hf6SJi3bfrFHvmLIp2iZZBOG7NOxmfpNh0CgzTlP51r7qbgGHPNvZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOyiux90; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOyiux90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629F01F00A3A;
	Wed,  9 Sep 2026 02:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788920002;
	bh=aj7lS4wbLim438IKRoJg6uP0XjtEK8zqH0TnLDS7ljM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DOyiux90L4WR4WXBcnBSN8C+56L0qkvN3MzL1Yz66twQXHTaFpr9ydMEJ3wtJx9Se
	 FwOJlpQnoA9ty19of931FX9pnQRvoqH7erIJU7kqrIapmzaaqfhgPS7/Nrq/JTxSma
	 BczN+nn0rxUP98dq7RRXWYcLv1vwn2aQpo9yYhGTCLCzSZWz9XXYNlw/qRhzzclKuk
	 0l3g7p6lelhrreTYyiZxFL5DXjzM+ZWslbavFaOGubsZC52bapl6l/WMsIA9sxj7tA
	 V8uIUpXOzMBhfOazJPsKK9KyxxKK+2c1UZIiAbQT/PJduEhkBHr/zsvuACEMfcyLHv
	 VrZ18rFEPWieQ==
Date: Wed, 9 Sep 2026 02:13:20 +0000
From: Yixun Lan <dlan@kernel.org>
To: Conor Dooley <conor@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Message-ID: <20260909021320-GKG2330@kernel.org>
References: <20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org>
 <20260908-08-k3-ufs-support-v4-1-22aa2bd97d3b@kernel.org>
 <20260908-carnival-curve-5762bb5cdb92@spud>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260908-carnival-curve-5762bb5cdb92@spud>

Hi Conor,

On 18:59 Tue 08 Sep     , Conor Dooley wrote:
> On Tue, Sep 08, 2026 at 07:42:03AM +0000, Yixun Lan wrote:
> > Document the compatible for UFS (Universal Flash Storage) Host Controll=
er
> > which found in SpacemiT K3 SoC chip. Its features are listed below:
> >=20
> > - Compliant with MIPI UniPro v1.61 specification.
> > - Compliant with M-PHY v3.0 specification.
> > - Compliant with UFS HCI v2.1 specification.
> > - Supports up to 2 Tx and 2 Rx lanes, up to HS-GEAR3 5.8 Gbps per lane.
> > - Supports standard low-power hibernate to reduce power consumption.
> >=20
> > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > ---
> >  .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml | 56 ++++++++++++++=
++++++++
> >  1 file changed, 56 insertions(+)
> >=20
> > diff --git a/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.ya=
ml b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
> > new file mode 100644
> > index 000000000000..dda533c852e8
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
> > @@ -0,0 +1,56 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/ufs/spacemit,k3-ufshc.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: SpacemiT K3 SoC UFS Host Controller
> > +
> > +maintainers:
> > +  - Yixun Lan <dlan@kernel.org>
> > +
> > +properties:
> > +  compatible:
> > +    const: spacemit,k3-ufshc
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    maxItems: 2
> > +
> > +  clock-names:
> > +    items:
> > +      - const: aclk
> > +      - const: ref_clk
>=20
> It's the usual refrain here, about having "clk" in clock names.
> "axi" and "ref" perhaps?
Yes, it's axi clock, I agree and will adjust in next version

> Otherwise, looks fine to me.
>=20
Ok, thanks

--=20
Yixun Lan (dlan)
