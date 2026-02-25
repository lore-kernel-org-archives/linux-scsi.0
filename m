Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F55F318EDC;
	Wed, 25 Feb 2026 12:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772024251; cv=pass; b=okYjzM2L2F6zSBVX7kjItf80iv+h+gZye9pMtD4uUhEFg9NEomEdLZ0NlEL9DnIAolhz3CN+7/+S0SVVCr1b1Bpz3UgrMTM1e7o6kGowICh2FiPBXQGUwftlb/9yNN6XPuakTbGehfy7kpznytTdJlUanl5TastGaALxfnMMmFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772024251; c=relaxed/simple;
	bh=0ajGVOhZgJOdHcOgWpjrAR3tDuhSfoXYdy0PzsAjZP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rlw27HNIsck4SNzhJ/2tsFkeFkENSSCRgKasxYVzJp45mBRQbNlZCwcPxbDMenveWEY5J0HADqIZEyxbp3A24/uMUtrnq6KYF7uiHbIwcZIsHKNkSrzLrI8zEn+9iUlWjwbn/0AcrNH5XEjsdRQeoy+SyQbylNo77gT/GyV9Xmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=ipYumGPf; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="ipYumGPf"
ARC-Seal: i=1; a=rsa-sha256; t=1772024214; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ZNKGY3r6ToOIex/fDgwa1coiqUw5WWa6sJezR4UUbMvkusuwIcXwNH8M0nf3ZT+kHxOFkIYKp1ERgvUJIMa7d2F/P+MNMcid8C43vYW+CQYnvP5QNaOJf3OoWvxsBQdq9+yJGG34WE9hYSIBba8r4y6eCHvEZa424zzuagcEqlk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772024214; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0ajGVOhZgJOdHcOgWpjrAR3tDuhSfoXYdy0PzsAjZP0=; 
	b=fIqc4e1FDvi63gN4ZwdRJDdp3jasdNBD7AG4GNLIH6wDMS9/OxTfGeWdrsT5wcfacvbY0dDrqFQ5aUf2A+fFYsgVpa2ALaqIzW8TZIICz9MPLiETcwZ2X6+/iOBtG0rgEmBiBGmeb6XTcKOCZARmzCuaK1b8SSPH8a7VstAYUlE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772024214;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=0ajGVOhZgJOdHcOgWpjrAR3tDuhSfoXYdy0PzsAjZP0=;
	b=ipYumGPfVekix1b30H5OrkHdJ75Du0EPbskX0BqwHuNtUsOPeSPeVt9b4ypgICk6
	XnnowUv+Y8bxWYzdOLaOlMu6ZbBiiFU3ktHsOPDjubZNr+HDf1QTLC3/NveceeRuEok
	2L+C606lheDu7Ip93rblXJDGT9j+c8gYCJsycLEg=
Received: by mx.zohomail.com with SMTPS id 1772024213678970.8709094887984;
	Wed, 25 Feb 2026 04:56:53 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "robh@kernel.org" <robh@kernel.org>,
 Chunfeng Yun =?UTF-8?B?KOS6keaYpeWzsCk=?= <Chunfeng.Yun@mediatek.com>,
 "kishon@kernel.org" <kishon@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 Chaotian Jing =?UTF-8?B?KOS6leacneWkqSk=?= <Chaotian.Jing@mediatek.com>,
 "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
 "vkoul@kernel.org" <vkoul@kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 Peter Wang =?UTF-8?B?KOeOi+S/oeWPiyk=?= <peter.wang@mediatek.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 "kernel@collabora.com" <kernel@collabora.com>
Subject:
 Re: [PATCH v7 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Date: Wed, 25 Feb 2026 13:56:46 +0100
Message-ID: <6563087.lOV4Wx5bFT@workhorse>
In-Reply-To: <e452951498ae82433337ca428bd49c7358194dd8.camel@mediatek.com>
References:
 <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
 <20260216-mt8196-ufs-v7-22-b5f2907c6da7@collabora.com>
 <e452951498ae82433337ca428bd49c7358194dd8.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Wednesday, 25 February 2026 11:37:27 Central European Standard Time Pete=
r Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2026-02-16 at 14:37 +0100, Nicolas Frattaroli wrote:
> > The MediaTek UFS driver contains support for an undocumented,
> > non-vendor-prefixed u32 property named "clk-scale-up-vcore-min".
> >=20
> > Since it is not part of any binding, and would not pass a bindings
> > review in its current form, remove it.
> >=20
> > To return this functionality, it needs to be resubmitted in a series
> > that also introduces it to the binding, and justifies what it is used
> > for. Compatibility with downstream device trees is not a valid
> > justification for its existence.
> >=20
> > Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
>=20
> Can MT8196 work on Gear 5 without raising Vcore?

I do not have access to the documentation to answer this question.
However, you likely do.

> I'm afraid it might cause problems.
> Maybe we can add the correct binding for MT8196?

The correct binding is to do this with OPPs instead, which is a
future task that can be tackled (by someone else) once the broad
cleanups in this series have landed.

Adding a "clk-scale-up-vcore-min" property to the MediaTek UFS
binding would not pass DT bindings review.

>=20
> Thanks
> Peter
>=20




