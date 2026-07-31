Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4222FD1DA;
	Fri, 31 Jul 2026 12:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785502566; cv=pass; b=huwHM8dw6hSCfEB1u1D375elV+woBqFgYeOpLnDMe3SUCkP/u+3hL3ChfJxe1wjfiW3RMX5GgkL3riUs7KwIb029yQIeCdXPAuRW7Rp/RoByqMfaTMMU55Hq5+8dqpfXOKv7ndbSyrqhdWyh3I2gRnwXdK7VJ+2hYvaCWs0mUVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785502566; c=relaxed/simple;
	bh=zAhwrWMY6PvLC/P8M84L7525EvKre07drBqR9LRCx8A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l4qcQWF7K2MxDCVl1p0fRwgDr9+9/BbVNVFdhbJQzRzInMyH9pnG1eIroXj5LMnZ2X9TVkvl6XgmR2RA+n91H8UtssmytXbm20aZxbJepT2Usmhb8BEpHBIQaCZgMKUVamdDEECCVv9Ep0xQNzeTfPHABd4txV/n8Dd4hNHV8Eg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=louisalexis.eyraud@collabora.com header.b=E5hGGX8n; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=louisalexis.eyraud@collabora.com header.b="E5hGGX8n"
ARC-Seal: i=1; a=rsa-sha256; t=1785502536; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NAceC1nZ03Z8OJtT3c/AkcqWZgr6iyrkBVJVptqz1VI1XwcNZa5DUKJu2CuJO8K/6aH+uUpXT8xMYH0MA0kYdHATwK7tlzsgyozc/uiGdQYHzU71iVpB32hC91kPKVKU08a6HR2iZZnug91O2geOadZ7E65Uc7zB2Iy1jRwaCNc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1785502536; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=zAhwrWMY6PvLC/P8M84L7525EvKre07drBqR9LRCx8A=; 
	b=ex6DKoFlliJOmgcPdpT8RNRN+jpjfYz+mbeqTHrF3BFMyXYN2691fJROBKkKZaW5LOS0Xq34KSoe1b5HJkWtoW7LQ21D+v8L+xJg8pR5G0L2WFPZ0xAm6b5E38EDijVKIzNBZPe1F2uQnbiPI3agEnbkcLR8y1KrwkNkOpF8NX0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=louisalexis.eyraud@collabora.com;
	dmarc=pass header.from=<louisalexis.eyraud@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1785502536;
	s=zohomail; d=collabora.com; i=louisalexis.eyraud@collabora.com;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=zAhwrWMY6PvLC/P8M84L7525EvKre07drBqR9LRCx8A=;
	b=E5hGGX8nJlFV4riMFbzQfwVYLjS+jFZyeZtpkU8eqm8AHTNUVc3Nk5lYPYk/G20m
	uRZPT2CBMnSHVw4riWDfmAw3RHLX3ib58YjKzTibCNPgZlbdWvLIL4bMUMnwZ1B+9zs
	w8BEK0diuqrVdbbMbZVulLYAM9BLKWAdGxBaaG0U=
Received: by mx.zohomail.com with SMTPS id 1785502535132267.4450717048104;
	Fri, 31 Jul 2026 05:55:35 -0700 (PDT)
Message-ID: <d418ce620a6128d7dac0c8e56f2a07653e5d035e.camel@collabora.com>
Subject: Re: [PATCH v10 24/26] arm64: dts: mediatek: mt8195: Align ufshci
 node to dt-bindings changes
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>,
  Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski	 <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Matthias Brugger	 <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno	 <angelogioacchino.delregno@collabora.com>,
 Peter Wang <peter.wang@mediatek.com>,  Chaotian Jing
 <chaotian.jing@mediatek.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman	 <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Stanley Jhu	 <chu.stanley@gmail.com>, "James E.J. Bottomley"	
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"	
 <martin.petersen@oracle.com>, Philipp Zabel <p.zabel@pengutronix.de>, Liam
 Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
 kernel@collabora.com, 	linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, 	linux-phy@lists.infradead.org,
 devicetree@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, Nicolas Frattaroli	
 <nicolas.frattaroli@collabora.com>
Date: Fri, 31 Jul 2026 14:55:28 +0200
In-Reply-To: <20260731-curious-unnatural-octopus-cef3e9@quoll>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
	 <20260730-mt8196-ufs-v10-24-bc5ecef202dc@collabora.com>
	 <20260731-curious-unnatural-octopus-cef3e9@quoll>
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

Hi Krzysztof,

On Fri, 2026-07-31 at 10:28 +0200, Krzysztof Kozlowski wrote:
> On Thu, Jul 30, 2026 at 11:49:20AM +0200, Louis-Alexis Eyraud wrote:
> > The MT8195 UFS host controller dt bindings now describe several
> > extra
> > required clocks that were previously missing from clock description
> > and deprecates the freq-table-hz property use in favour of
> > operating-points-v2 instead.
> >=20
> > Currently, the ufshci node declares the freq-table-hz property but
> > all
> > values contained in the array are zero, thus converting it to an
> > OPP
> > table is not needed.
> >=20
> > So, add in ufshci node the rx_symbol clocks in clock list and
> > remove
> > freq-table-hz property.
> > Also reorder properties in node.
> >=20
> > Signed-off-by: Louis-Alexis Eyraud
> > <louisalexis.eyraud@collabora.com>
> > ---
> > =C2=A0arch/arm64/boot/dts/mediatek/mt8195.dtsi | 21 ++++++++++---------=
-
> > -
> > =C2=A01 file changed, 10 insertions(+), 11 deletions(-)
>=20
> DTS must not be combined with patchset targetting SCSI/UFS, because
> UFS
> folks were grabbing entire thread. Please follow the same rules as
> when
> submitting to USB, serial etc.
>=20
Ack.
I'll drop the 3 devicetree patches in the next revision and send them
in a new series.

Best regards,
Louis-Alexis

> Best regards,
> Krzysztof
>=20
