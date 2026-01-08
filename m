Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2169B445EEC;
	Thu,  8 Jan 2026 09:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767864549; cv=pass; b=OckLdplCvvbzoPGXNVbK+Jsk0GHNhNSb1daTmnFjxdUj6QVZCqzyLvSo8AZVSE2+Fqo/sBfE2KTUNvRefULZ0Lo1KK13TXcXFBIe15sxy12NEuq77rA6vV+Htbh75Z6ld9dx9X61/xBFsRwRLa86544eWY6vTO7hdFMVKVZuI70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767864549; c=relaxed/simple;
	bh=Bl8Y617sotQ73GVR2T1Q+Wa4KgXyXDvatmz5tMSVID0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a96bvtZ7dRZD9GQDZ7HKH5vItnjR1sMv9dL7hmQRnOsGm6OAzUtrB52uP/H3SgAb8AeyJYLqLBCe4LI1o4DgbeXcMcmGZqzKqJwnBu08xULNWzQ1I3wRFGkCn7BqwasI2ftHsVESGQdvtTUuHWMzCctSW1kkcVfFowHSezUjCa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=EMi4Ylvr; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="EMi4Ylvr"
ARC-Seal: i=1; a=rsa-sha256; t=1767864492; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=cRYqTaLZu9/Cz2hhALQrG+OnVMloqPR07D0g1j0Oj9gkB4WLvXduBwrjy3/Wrhd7HTdNahdARXVh3jZkJXhrahAbGx2emEh0OkPisxok95vWOGzXFxQwP3XSRadmpuwr7ZYfUofpWWFfDgjjvvoAYNt7v0R8LFHb53fxacceiPA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1767864492; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Bl8Y617sotQ73GVR2T1Q+Wa4KgXyXDvatmz5tMSVID0=; 
	b=V2NJcv8cA0trLQndvEx48Dgk0YZc9ADKFw6EoIY0bseVk0qkxp4ze4zlhtsFMh1lQsxO7Rq6n5Jf31OvLVvRsYvmUpD8b9BOVpB63CuDVgkCWQRUuQnb+kztY7fbwZTxN8FiOE4MVob+48K6Z/EBH/Od85N0aIfALnHE8DAr2Oc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1767864491;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=Bl8Y617sotQ73GVR2T1Q+Wa4KgXyXDvatmz5tMSVID0=;
	b=EMi4YlvrwckuoEXWDPE+n0476n6VI0HuybuzhMEgHluL/U0bj8xY8nYDWEvDWeqU
	DocuVYtiK0A/HWw/vhT9xhQ6ClQ+SJPEblKV28C7BZ2NuAmZT1L+tk9xXQqt7R/a7+k
	7F1/FjbybBegbC6pPGEQ6eT0VbpqCIHSzPEgsrS8=
Received: by mx.zohomail.com with SMTPS id 1767864489427365.0551721336526;
	Thu, 8 Jan 2026 01:28:09 -0800 (PST)
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
 Re: [PATCH v4 12/25] scsi: ufs: mediatek: Remove vendor kernel quirks cruft
Date: Thu, 08 Jan 2026 10:28:00 +0100
Message-ID: <13960383.uLZWGnKmhe@workhorse>
In-Reply-To: <1bbc263bafe14343b2d60a230ae6ce5dadffbf7c.camel@mediatek.com>
References:
 <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
 <20251218-mt8196-ufs-v4-12-ddec7a369dd2@collabora.com>
 <1bbc263bafe14343b2d60a230ae6ce5dadffbf7c.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, 6 January 2026 14:25:22 Central European Standard Time Peter Wa=
ng (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Thu, 2025-12-18 at 13:55 +0100, Nicolas Frattaroli wrote:
> >=20
> > Both ufs_mtk_vreg_fix_vcc and ufs_mtk_vreg_fix_vccqx look like they
> > are
> > vendor kernel hacks to work around existing downstream device trees.
> > Mainline does not need or want them, so remove them.
> >=20
>=20
> Hi Nicolas,
>=20
> This is a flexible approach to implement one software supporting
> multiple
> hardware configurations. Because you cannot guarantee that your SOC
> will=20
> always use UFS 2.0 or UFS 3.0, or that the PMIC you use will only have
> one set.

By "one software supporting multiple hardware configurations", do you
mean one device tree? Because if so, I don't think that's a good idea.
Device tree is meant to describe non-enumerable hardware.

Even if you want to make it easier for your customers to ship one image
for several SKUs, there's better ways to do this than having drivers
fix up individual DT nodes. The platform firmware like u-boot can choose
a DT based on differences it can probe. E.g. on Radxa ROCK 5B/5B+ boards,
we have u-boot choose between the 5B and 5B+ DT based on whether LPDDR5
is present, as 5B does not have LPDDR5, so as long as u-boot is told it's
either a ROCK 5B or ROCK 5B+, it can figure out which one specifically based
on that. Similarly, for whichever boards this is for, there may be
differences that can be probed to disambiguate between several SKUs of the
board as long as it's known it must be at least one of those SKUs.

>=20
> Thanks
> Peter
>=20
>=20
>=20




