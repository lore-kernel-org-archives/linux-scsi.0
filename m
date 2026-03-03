Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92392390208;
	Tue,  3 Mar 2026 10:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772532994; cv=pass; b=KKpaDEDbTZqD4/wdTGj2BbjQ4/i/B2uOKgKSucbxv0XmFXvFXfNmYerRpv4x+SfOajVI3Us+a72+wwfd9F5/U0jIHAVieKDxkNQ19E/OD9vysi52G/dxNwSqmIxGQm7AgJAepKQjLidalJSb4VfJPIhsfnUQfgmYRQp4r/bq9Xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772532994; c=relaxed/simple;
	bh=hV7pmbruCuv2YT3GXeR/WB6MvDM5iYmpBJg+CzfkEy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VLq608vbOCopJOTje6M57sKuVUA5W3q1f4VpN5su0kKEIeXfQKC+8Ry6cW1akNtNzBFG4RrYHkAeeHEa3HBqP0xuOUjmTejIKVE+z2n1p4PNwrsLLsf5A2bj3UZ24mtEOPEgukHcpbVssZUPL4iUrH0Ghii5jXVAUVatJk4mlNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=F5qPoP+y; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="F5qPoP+y"
ARC-Seal: i=1; a=rsa-sha256; t=1772532960; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Ld3WEFmDwMm4C8fsVqUW9jEYfexkJC1pErlxbI/bd/u9wIjtVtvEVj8KmR0gRsm98qMtTP6QY8zJumJp5cYAbNZWQ35InHNDLhk/8GhbAljJwLPwqVX4HhwIgZCxfoTb6rKos4yI3CDdMlV0qY8RELcbxWOIMcCzdIgBitH8UZQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772532960; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=hV7pmbruCuv2YT3GXeR/WB6MvDM5iYmpBJg+CzfkEy0=; 
	b=JtfUa7LseAVWU3UlSAtrwverfSpUtmpCjPEyafLJjiAK3vZ00o/14AaNVB0IC70ImJhgp7ji1aDL4FQEazN6WfPdPiJdPZoBhN524W9lLhn7hANpCraR/BdYv3XF6P96rXwCvpIsHE6aZPmY1cRXTN3ltHcCNeu19Hcogp4glyY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772532960;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=hV7pmbruCuv2YT3GXeR/WB6MvDM5iYmpBJg+CzfkEy0=;
	b=F5qPoP+y66wlCndzg6MYVKVtavNrhdcVXA/icpMvQ4iG7XzaZ+AdmtKjIhnioEfD
	CCg27jDedafjWLNPBfBCXN9pwPOraOvLcdYQVMKXZobzVBaGUxoDNoAY8wYQgSKj33g
	tDgvFKaUVkCZ8FpdhOGOEpFy3i1HslBStZudJQac=
Received: by mx.zohomail.com with SMTPS id 1772532958810282.7970747621265;
	Tue, 3 Mar 2026 02:15:58 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "robh@kernel.org" <robh@kernel.org>,
 Chunfeng Yun =?UTF-8?B?KOS6keaYpeWzsCk=?= <Chunfeng.Yun@mediatek.com>,
 "kishon@kernel.org" <kishon@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Chaotian Jing =?UTF-8?B?KOS6leacneWkqSk=?= <Chaotian.Jing@mediatek.com>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
 "vkoul@kernel.org" <vkoul@kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
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
 Re: [PATCH v7 20/23] scsi: ufs: mediatek: Back up idle timer in per-instance
 struct
Date: Tue, 03 Mar 2026 11:15:51 +0100
Message-ID: <3072176.mvXUDI8C0e@workhorse>
In-Reply-To: <0bef3e1592e64f74e6a6fd8ef59129ac71b307e4.camel@mediatek.com>
References:
 <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
 <48e8f40b-f5f3-42b5-a97b-7a25d1dc0fb8@collabora.com>
 <0bef3e1592e64f74e6a6fd8ef59129ac71b307e4.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, 3 March 2026 09:01:14 Central European Standard Time Peter Wang=
 (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Thu, 2026-02-26 at 11:36 +0100, AngeloGioacchino Del Regno wrote:
> >=20
> > Okay, does "saved_auto_hibern8_idle_tmr" sound good for you instead?
> >=20
> > Regards,
> > Angelo
> >=20
> >=20
>=20
> Hi AngeloGioacchino,
>=20
> I=E2=80=99m fine with saved_auto_hibern8_idle_tmr, but it is more=20
> verbose compared to saved_ahit.
>=20
> Thanks
> Peter
>=20

Yeah no I won't change this, this is pointless bikeshedding.


