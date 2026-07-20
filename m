Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF101385519;
	Mon, 20 Jul 2026 16:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784564562; cv=pass; b=cL2MlLVLEg2xlnjrZs+ncnYkMmWi0KpqyR6gB4nux6P9nHyEHk/+znL05pRgMdS3INyM/aB97RDiTeTIGvFVMol7URTGlVMSK4w4E3OGcB9APvYLPQi7l4lMFRTDWJz/jYjw1qLR7FzeNTAJwu+N4Ko6qR21FiM8yrN1vjknzjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784564562; c=relaxed/simple;
	bh=lwQUQLjTNbpBIphWUbMxPz0kEUt9B2K2jVWc6+WyxN8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bpnIq8C4gJmqmZSP7Y2easciR8W2Io9R0qy7b74UtLpQYWQ5/bVMLrOOMaGy7x4gz/wCRpSsHECZyCAi8AwJGHPY8oYrIu7O+He8SvIRmJMuUX1U2t7kzSdRcRfK6DQFqEPXYDPGkIRLBrKPyEEasaxxAEKBecMFvDFYKYWO8T8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=louisalexis.eyraud@collabora.com header.b=VJrRY3yz; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=louisalexis.eyraud@collabora.com header.b="VJrRY3yz"
ARC-Seal: i=1; a=rsa-sha256; t=1784564506; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=bxjn/lrbz8f3iTEFS5kTXhb+Oce5wmwZVsNZpZpVrAPk/gfkafShCeRvZqOa+Zq3kXVVuenPYHLKExIs5Xo0qAmZUnkSUuIoOX6L21F8BK6f1+VvBoFBoVLvgTswcxRE52rWzL/ZJcSl7HeW6Ncm+lSOEWKg2CZATmy9/x/qR58=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784564506; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=lwQUQLjTNbpBIphWUbMxPz0kEUt9B2K2jVWc6+WyxN8=; 
	b=SlvxJxxp/5iBQsaXRs9MrqDK1tIW3rgLq1fugjNAg1Vvhl3kkDeWHWvEAU1K0UBFxhdHT3Pdr6QVg2in6/Zn7bNceMp3ftSuFVooCfo1lQryvLgiPYBYs1Lwu3UNbccPB9IsALnQFuE/HJVjRTfDsMFm2dSpIrBBl6kxQGucxtI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=louisalexis.eyraud@collabora.com;
	dmarc=pass header.from=<louisalexis.eyraud@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784564506;
	s=zohomail; d=collabora.com; i=louisalexis.eyraud@collabora.com;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=lwQUQLjTNbpBIphWUbMxPz0kEUt9B2K2jVWc6+WyxN8=;
	b=VJrRY3yz8lpIcDRl3iNEsvOV4IRYjslWdQRks4JPFDKwSZQdxU8bfxTHK9u7L/OF
	UtaA7Yw/Ta/nB9sudI+TFolVm+q1jEPy9q2YFCGhSQDhkNSiPj1By+DtOeve5/yb+Oj
	sq/t5/LcTbN3LadhhydWdscV+ClVT5p4oFDNa0L8=
Received: by mx.zohomail.com with SMTPS id 1784564496439685.8308189373028;
	Mon, 20 Jul 2026 09:21:36 -0700 (PDT)
Message-ID: <8b013876c591f80ec4af86d69bf2f38f9ac481ad.camel@collabora.com>
Subject: Re: [PATCH v9 03/23] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
To: Rob Herring <robh@kernel.org>, Nicolas Frattaroli
	 <nicolas.frattaroli@collabora.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,  Bart Van Assche <bvanassche@acm.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,  Chunfeng Yun
 <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, Kishon Vijay
 Abraham I	 <kishon@kernel.org>, Peter Wang <peter.wang@mediatek.com>,
 Stanley Jhu	 <chu.stanley@gmail.com>, "James E.J. Bottomley"	
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"	
 <martin.petersen@oracle.com>, Philipp Zabel <p.zabel@pengutronix.de>, Liam
 Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Chaotian
 Jing	 <Chaotian.Jing@mediatek.com>, Neil Armstrong
 <neil.armstrong@linaro.org>, 	kernel@collabora.com,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, Conor
 Dooley	 <conor.dooley@microchip.com>
Date: Mon, 20 Jul 2026 18:21:28 +0200
In-Reply-To: <CAL_Jsq+mF_Q7Ld8__ZTc5yDvWAT6uK5wxfBJM-YdFjOvdiDc-w@mail.gmail.com>
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
	 <20260306-mt8196-ufs-v9-3-55b073f7a830@collabora.com>
	 <20260306163305.GA2680515-robh@kernel.org> <4089450.ElGaqSPkdT@workhorse>
	 <CAL_Jsq+mF_Q7Ld8__ZTc5yDvWAT6uK5wxfBJM-YdFjOvdiDc-w@mail.gmail.com>
Organization: Collabora Ltd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZohoMailClient: External

Hi Rob,

On Tue, 2026-03-10 at 13:10 -0500, Rob Herring wrote:
> On Fri, Mar 6, 2026 at 12:37=E2=80=AFPM Nicolas Frattaroli
> <nicolas.frattaroli@collabora.com> wrote:
> >=20
> > On Friday, 6 March 2026 17:33:05 Central European Standard Time Rob
> > Herring wrote:
> > > On Fri, Mar 06, 2026 at 02:24:44PM +0100, Nicolas Frattaroli
> > > wrote:
> > > > The MediaTek MT8196 SoC's UFS controller uses three additional
> > > > clocks
> > > > compared to the MT8195, and a different set of supplies. It is
> > > > therefore
> > > > not compatible with the MT8195.
> > > >=20
> > > > While it does have a AVDD09_UFS_1 pin in addition to the
> > > > AVDD09_UFS pin,
> > > > it appears that these two pins are commoned together, as the
> > > > board
> > > > schematic I have access to uses the same supply for both, and
> > > > the
> > > > downstream driver does not distinguish between the two supplies
> > > > either.
> > > >=20
> > > > Add a compatible for it, and modify the binding
> > > > correspondingly.
> > > >=20
> > > > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > > > Acked-by: Vinod Koul <vkoul@kernel.org>
> > > > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > > > Reviewed-by: AngeloGioacchino Del Regno
> > > > <angelogioacchino.delregno@collabora.com>
> > > > Signed-off-by: Nicolas Frattaroli
> > > > <nicolas.frattaroli@collabora.com>
> > > > ---
> > > > =C2=A0.../devicetree/bindings/ufs/mediatek,ufs.yaml=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 58
> > > > +++++++++++++++++++++-
> > > > =C2=A01 file changed, 57 insertions(+), 1 deletion(-)
> > > >=20
> > > > diff --git
> > > > a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > > > b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > > > index e0aef3e5f56b..a82119ecbfe8 100644
> > > > --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > > > +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > > > @@ -16,10 +16,11 @@ properties:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - mediatek,mt8183-ufshci
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - mediatek,mt8192-ufshci
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - mediatek,mt8195-ufshci
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - mediatek,mt8196-ufshci
> > > >=20
> > > > =C2=A0=C2=A0 clocks:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 minItems: 1
> > > > -=C2=A0=C2=A0=C2=A0 maxItems: 13
> > > > +=C2=A0=C2=A0=C2=A0 maxItems: 16
> > > >=20
> > > > =C2=A0=C2=A0 clock-names:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 minItems: 1
> > > > @@ -37,6 +38,9 @@ properties:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - const: crypt_perf
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - const: ufs_rx_symbol0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - const: ufs_rx_symbol1
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - const: ufs_sel
> > >=20
> > > "ufs" is redundant as all the clocks are for UFS. Same comment on
> > > prior
> > > patch.
> >=20
> > Is this naming a big enough concern to block this series with two
> > explicit acks on this patch that fixes a wholly broken and useless
> > binding?
>=20
> Shrug... Is changing it really that hard?
>=20
Since I'm currently working on rebasing this series and fixing its
remaining open issues (compilation, dt-bindings warnings,...) to send a
new revision, I've looked at the questions you raised.

First, renaming those clocks and all the other starting with "ufs_"
prefix (including the one that is simply named ufs) is indeed easy and
needs just a little rework.=C2=A0
Mostly, a driver patch, as it is currently explicitly using the name of
the 3 ufs_sel clocks and devicetree patches to adapt to this change.

The next series revision will include the devicetree patches for MT8195
SoC and the two boards that integrate this SoC and an UFS storage
(Genio 1200 EVK UFS and Radxa NIO-12L), to fix the warnings that the
dt-binding changes, done by patch 1 (additional clocks, freq-table-hz
deprecation, additional power supplies) in the v9 revision, generate.

> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - const: ufs_sel_min_src
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - const: ufs_sel_max_src
> > >=20
> > > "src" sounds like a parent clock? If so, probably shouldn't be in
> > > the
> > > clocks list. 'assigned-clocks' is for dealing with parent clocks.
> > >=20
> >=20
> > I don't know what it is, and I have no way to consult any
> > documentation
> > that would tell me what it is. I am trying to put out this dumpster
> > fire
> > of a downstream turd that made its way into mainline as the review
> > process
> > has been completely subverted, and is only getting worse with each
> > passing
> > month that MediaTek is allowed to block this series from
> > progressing while
> > sneaking further changes through.
>=20
> It's good Mediatek is active, then they can tell us what the clocks
> are for. I would think the driver would give some clue.
>=20
Second, when searching in the driver code and the git history, it shows
that ufs_sel is indeed a parent clock.
The ufs_sel/ufs_sel_min_src/ufs_sel_max_src clock use in the driver
code was introduced by the commit b7dbc686f60b ("scsi: ufs: ufs-
mediatek: Support clk-scaling to optimize power consumption") to
implement a dynamic clock scaling feature.

ufs_sel is supposed to be the parent clock of the main clock ("ufs" in
dt-bindings) and both ufs_sel_min_src/ufs_sel_max_src the parent of
ufs_sel.
The code switches conditionally the ufs_sel parent to modify the ufs
clock rate (ufs_sel_max_src for maximum performance, ufs_sel_min_src
otherwise).
I've also looked at different downstream kernel trees, the assigned
clocks values for those 3 clocks in the ufshci node in devicetree are
consistent with the clock hierarchy in the MT8196 clock controllers
drivers.

This feature also seems to be linked to another one that added the
clock scaling for the FDE clock (ufs_aes in dt-bindings).=C2=A0
The commit that introduced it is 5e5976f5242d ("scsi: ufs: host:
mediatek: Support FDE (AES) clock scaling") and it also added the 3
undocumented clocks: ufs_fde, ufs_fde_min_src, ufs_fde_max_src.
It is similar to the previous described one.

The current driver code seems to require having the "ufs_fde" clock
(supposed to be the ufs_aes parent clock) in the devicetree, so that
the clock scaling feature for the "ufs_sel" clock is performed and I
did not find why.=C2=A0
So, with this current series dt-bindings patches, ufs clock scaling
feature seems not completely described yet.

There is also the crypto boost feature that make use of the
crypt_mux/crypt_lp/crypt_perf clocks in a similar way.
They were missing from dt-bindings, before this series patches made by
Nicolas to documented them. Angelo also sent a patch two years ago in
that regard ([1]) but did not get picked.
The feature has been introduced by commit 590b0d2372fe ("scsi: ufs-
mediatek: Support performance mode for inline encryption engine")
The crypt_mux clock is also supposed to be the ufs_aes parent clock and
its own parent is switched on need between crypt_lp (low power) and
crypt_perf (performance).
This feature is also depending two undocumented property:
- dvfsrc-vcore-supply: Angelo sent [2] to add it and this current
series forgot to add it too (to be done for v10 ?)
- mediatek,ufs-boost-crypt: vendor specific property to enable this
feature. Angelo sent [3] to remove its need but got reject back then

Note that crypto boost and FDE clock scaling features seem not to be
supposed to be enabled at the same time.

Again, this crypto boost feature seems not completely described yet.

Sorry for the wall of text but I felt it was better to add extra
details regarding all those features and how they relate to each other
to have a more complete answer regarding ufs_sel.

[1]
https://lore.kernel.org/linux-mediatek/20240612074309.50278-8-angelogioacch=
ino.delregno@collabora.com/
[2]
https://lore.kernel.org/linux-mediatek/20240612074309.50278-9-angelogioacch=
ino.delregno@collabora.com/
[3]
https://lore.kernel.org/linux-mediatek/20240612074309.50278-4-angelogioacch=
ino.delregno@collabora.com/

> I don't see how accepting sub-par bindings or not fixes the issues
> here.

So, since all these features rely heavily on optional parent clocks,
that were not documented before being used in driver code, what should
be done to make progress and fix these dt-bindings?

What would you recommend to do in order to resolve those topics?
I'm open for ideas, please.

Best regards,
Louis-Alexis

>=20
> Rob
