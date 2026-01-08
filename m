Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD373A0B2B;
	Thu,  8 Jan 2026 09:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767863741; cv=pass; b=Ax+vHJ1+ffLF8LySD9aCQIshtJco5wW9CIPK+uL2Q9Y0yDCEUDGknvByBv42CFxUAvl0RW46vCkZqjYo3SmyCGmy1g6jaQnvOFzNgzJBeJ4ctMSeOMPW+dY4nyPUZGYZRiVltUhLtyYJnr5bzuI8FsGiinJfSfXiZRel73zMArY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767863741; c=relaxed/simple;
	bh=5nTYfSaDPv2GdlELTogMY93wplFSokquqpOtJ7cePW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZdiVXGffxTlYtxdsxdNi7teGk4ph2Js+CykloyjZVI9qSMA4rqSi7KLRuNee6jhPrtbwuFY08TLyGpJWABGsxSMCBpst9wTfPmqmsliqHt/fPK8xyuZN1teqNtVbkaIxRvzmmYo3nT9rB1MzUMbMpnFpkZVNYx/zQVstnkP298=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=kTicqGgq; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="kTicqGgq"
ARC-Seal: i=1; a=rsa-sha256; t=1767863695; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=MmE5DKfbNllkayfuVfwm9GThSMFT+PX+Q2qcU+TqNiyd2ZutQKHKl2xQoLqUG3zsymi4xcpv2W0Cu9tMDT5XksV3frCCiyx15Nl4+t2Hkxfs5hbWrkeNSx7VctY6ioYBvzrNSkdw0NzytZvIYUK3mrk4XkTPnZ2epVMByddAHis=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1767863695; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=5nTYfSaDPv2GdlELTogMY93wplFSokquqpOtJ7cePW8=; 
	b=F3KXU6Fwpvtrnw4tK2M8uHd68QIlsZU0jzBBulY/5zbSLW8Qrf28FYA0wd2yxBcYgoOaMEeK18uCW7KdWet9I74deKSEifIWq+EUU30svBPjFGIkJVBbfw2DNZE/6NGA16Sp0jSGt9YeaJCJeBmx8TtXclw63wW0XBnRRcP+srY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1767863695;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=5nTYfSaDPv2GdlELTogMY93wplFSokquqpOtJ7cePW8=;
	b=kTicqGgqsOzHMkeRBWfRNWGcx2mI153gK3zN0TKiLHNcsKpEIms6Z+TsAIQUolqD
	ebLrshz40+ShAYSAlksHuN9vSpcazstbafyIfkzQAxFs9HaETySG1jl0PzLvVIvWvRP
	btNeqbhgsP0TcoF6ytmZY/IIEnltagUCO5ehZxLs=
Received: by mx.zohomail.com with SMTPS id 1767863693938487.4499614851069;
	Thu, 8 Jan 2026 01:14:53 -0800 (PST)
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
Subject: Re: [PATCH v4 11/25] scsi: ufs: mediatek: Rework probe function
Date: Thu, 08 Jan 2026 10:14:44 +0100
Message-ID: <5992593.DvuYhMxLoT@workhorse>
In-Reply-To: <213d3077835fc86d15579c0a0a91f64fd84b1059.camel@mediatek.com>
References:
 <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
 <20251218-mt8196-ufs-v4-11-ddec7a369dd2@collabora.com>
 <213d3077835fc86d15579c0a0a91f64fd84b1059.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, 6 January 2026 14:23:58 Central European Standard Time Peter Wa=
ng (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Thu, 2025-12-18 at 13:55 +0100, Nicolas Frattaroli wrote:
> >=20
> > Remove the ti,syscon-reset cruft.
> >=20
>=20
> Hi Nicolas,
>=20
> Why do we need to remove the reset node? If an error occurs and the
> host=20
> does not perform a reset, it could lead to error recovery failure.

Because it's not described by the binding, and appears to be a
downstream hack to work around not having the reset controller
properly described and referred to with a `resets` property.

Even if you were to use `ti,syscon-reset` to describe a reset
controller, the UFS controller driver should not be searching
for this compatible. It should access the reset through the
reset API. The common reset code can then take care of probe
ordering without every driver reinventing it.

>=20
> Thanks.
> Peter
>=20




