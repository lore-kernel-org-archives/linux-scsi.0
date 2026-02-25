Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06DB3ACA70;
	Wed, 25 Feb 2026 12:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772023950; cv=pass; b=NWsiz97BPqgiHxNHcGiKUuTJr7s+s4LJMSVtKiTvAvSdGlzE5PNR3lkFG6vDLnY9gTXmoKG3zm/BY0bultJCkhu22ERJlZGt8iQGj0rnm/6MuOa7rThsQm79bPaSEKk/aI3XDLXaKX0nSOjD1KysNipLgePKZqokIeIgi2LZz80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772023950; c=relaxed/simple;
	bh=B2rBAV3x2imjtMXvRpm/a6EYY+5lEBFKR6gItPqv/X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AM34947SP2h+4aKTt6svETpZd3YnpVbPnGxbSQuJ+L21BDM+1lmKW9dqVPPje2/dPONXEm/h6b6YyX2OVKtl4IRWxqVM8WYdRp1wxVbPc9ffP/mWORmcQ/aNg6Kiusli2DuKgOvcnZGb6MBpauPAiXOFmEe21aVGyZRmCg9Vajs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=Z7mEQDq9; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="Z7mEQDq9"
ARC-Seal: i=1; a=rsa-sha256; t=1772023918; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ICTEfHhyDwLJkhsdDnqW0m6pUOTdJbtZU+i7vtiytvbTDJZv5wHNiLsHIP9QegFSAI1ghfZVLZOplV1gbia6JuQe8RmfFiG69QBoa14HfclhBdamUFMc2BucV25iR8ZRHDMz3mkC+iCPTsXEFmEJjsVMZrkLLok0AZe9Yf0lkLA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772023918; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=T70ySPmQ1GqRu+gzswXj2+yT3BqSZsUEEsLuHeI35co=; 
	b=QHK/4er+tLCtdBvg1RAIKIHElknd71Syfrn0VLgKCF4JurPSJa3MK3aNPOkwa+oUNOgfcllqhHG0L889/m0zoxNbJGYht22ffNrLLbEZRRd26KCII8SiZ3DzFdZD9bLcs51Yf/bWtFUWsvuHGKjfnTLq20XJhJkaUPgfWqBxNJw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772023917;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=T70ySPmQ1GqRu+gzswXj2+yT3BqSZsUEEsLuHeI35co=;
	b=Z7mEQDq9HC4wHL2/KtkISM6JrMa8Ymly1nhRZFgYFA6bLp+TR1/JhcV/4yorEipU
	9UpkbXY7tYpq0mRVXesynsKp0CU5ycg6NSuRBuJcMgNO106uILhZVZ3Vt/W3SipYe25
	L0fI3wr0n+YkIDSfSdbwDI154gEHdXaU+MsSWI1I=
Received: by mx.zohomail.com with SMTPS id 1772023915403681.8519199142135;
	Wed, 25 Feb 2026 04:51:55 -0800 (PST)
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
 Re: [PATCH v7 14/23] scsi: ufs: mediatek: Remove mediatek,ufs-broken-rtc
 property
Date: Wed, 25 Feb 2026 13:51:47 +0100
Message-ID: <3140774.mvXUDI8C0e@workhorse>
In-Reply-To: <ee2e18e1a6177c40c5a4b3ed0ff228b9302429b7.camel@mediatek.com>
References:
 <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
 <20260216-mt8196-ufs-v7-14-b5f2907c6da7@collabora.com>
 <ee2e18e1a6177c40c5a4b3ed0ff228b9302429b7.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, 24 February 2026 13:43:10 Central European Standard Time Peter =
Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2026-02-16 at 14:37 +0100, Nicolas Frattaroli wrote:
> > diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-
> > mediatek.c
> > index 230e11533eac..424533538b90 100644
> > --- a/drivers/ufs/host/ufs-mediatek.c
> > +++ b/drivers/ufs/host/ufs-mediatek.c
> > @@ -655,9 +655,6 @@ static void ufs_mtk_init_host_caps(struct ufs_hba
> > *hba)
> >  	if (of_property_read_bool(np, "mediatek,ufs-rtff-mtcmos"))
> >  		host->caps |=3D UFS_MTK_CAP_RTFF_MTCMOS;
> > =20
> > -	if (of_property_read_bool(np, "mediatek,ufs-broken-rtc"))
> > -		host->caps |=3D UFS_MTK_CAP_MCQ_BROKEN_RTC;
> > -
> >  	dev_info(hba->dev, "caps: 0x%x", host->caps);
> >  }
> > =20
> > @@ -1185,8 +1182,6 @@ static int ufs_mtk_init(struct ufs_hba *hba)
> >  	hba->quirks |=3D UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
> > =20
> >  	hba->quirks |=3D UFSHCD_QUIRK_MCQ_BROKEN_INTR;
> > -	if (host->caps & UFS_MTK_CAP_MCQ_BROKEN_RTC)
> > -		hba->quirks |=3D UFSHCD_QUIRK_MCQ_BROKEN_RTC;
> > =20
>=20
> Maybe check the hardware version (host->ip_ver)=20
> and set UFSHCD_QUIRK_MCQ_BROKEN_RTC instead of removing it?

I do not have access to a complete list of hardware IP versions
that need this quirk applied. No upstream DTs seem to use it.

If MediaTek wants the quirk back, you can submit a patch to apply
it based on the ip_ver once this series has landed, as you have all
the necessary information.

>=20
> Thanks
> Peter
>=20




