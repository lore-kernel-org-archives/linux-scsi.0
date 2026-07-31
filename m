Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2353AFCF1;
	Fri, 31 Jul 2026 12:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785502041; cv=pass; b=k3EFE3lcLsVmI1EGC4nYofp1SyHR2qCoyECZXan+r6AhcnSRYNrr2o+CdjQUNeZuODocwSlg7r/SiJg7KeBPR+995wk0GFi1t6AR30r8SdQobuHdNjHWXJDuK26lMw0qWhbGqM625e24dc0qBfDDXuyHhsC2Ql11J19CxM9iVRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785502041; c=relaxed/simple;
	bh=qeYDLVJO6z9LXain17/mTHxd8Oy2iz9/kyAW2nqshBE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RRk5KRmgswpFucCuSpKidpM1MagB9oJPYbXOFhbCpwCtoSIXB8vH64GqcpWIsJ5Ni5PEemIYlk7Dzuwp1+ANt5eH6ftDmb+DxRGhuMZYJTWHr2U2lqS7MUef0VsKusYPK0U1h8Uqiq4qbnR0x7hRY7FTd7axtLwahLdC15vsvPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=louisalexis.eyraud@collabora.com header.b=cFa/Iwnb; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=louisalexis.eyraud@collabora.com header.b="cFa/Iwnb"
ARC-Seal: i=1; a=rsa-sha256; t=1785502007; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OeH5Dy/FYVuYCKeZD7ETFLym30115pEeQHUK8EFerm9DGeQ17QG6HLRwLQqPxqj32SPgKoZjuEemD17T+fT8YwMt4uLYGB/RFRjCt5DZdV9ZfiXxsKXoyhw6XqMkH/TBjml+F3pqDCWKbcTxYU/99tFhYOpOMwsXa/suuQPa3iQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1785502007; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=qeYDLVJO6z9LXain17/mTHxd8Oy2iz9/kyAW2nqshBE=; 
	b=Ewia+hWSrcN8nuTb2/KWmsMrseOsS8uwlr/2pd4T1kd8bKpYrGL5QVZVPWTz3pNEvtRYNlBu/fzbDDuc18v8Z6+COCd+SvtydRNkOSHUPwzOsx1gGdnzqsSAJ3yNVyIDGLK7zTJn2LbWX6Up3sHTsb0dpmx9yIoRwz1CdRG450U=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=louisalexis.eyraud@collabora.com;
	dmarc=pass header.from=<louisalexis.eyraud@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1785502007;
	s=zohomail; d=collabora.com; i=louisalexis.eyraud@collabora.com;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=qeYDLVJO6z9LXain17/mTHxd8Oy2iz9/kyAW2nqshBE=;
	b=cFa/IwnbXsJs2SNpbXMcCYy/c9CCBJ5GGG7KgygXugBTT+QfT+3K3tPs/6FtIeNh
	rJ+d15WgPKIbO11Gw7GCMP9ONxaJ6bDwYiaMN+Ulp4rwcqH/yvAGLT9Y0Vdb6t+Gy5q
	1ZWqSl/sP13YAKfJkrrMuJLZ/3dfszRocuxjggbY=
Received: by mx.zohomail.com with SMTPS id 178550200445654.5554775503316;
	Fri, 31 Jul 2026 05:46:44 -0700 (PDT)
Message-ID: <86c8b2ba77f109b77f93b74b13dc1fa995b7d4f7.camel@collabora.com>
Subject: Re: [PATCH v10 03/26] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
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
Date: Fri, 31 Jul 2026 14:46:36 +0200
In-Reply-To: <20260731-fanatic-zealous-inchworm-ddfe0b@quoll>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
	 <20260730-mt8196-ufs-v10-3-bc5ecef202dc@collabora.com>
	 <20260731-fanatic-zealous-inchworm-ddfe0b@quoll>
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

On Fri, 2026-07-31 at 10:27 +0200, Krzysztof Kozlowski wrote:
> On Thu, Jul 30, 2026 at 11:48:59AM +0200, Louis-Alexis Eyraud wrote:
> > =C2=A0
> > =C2=A0examples:
> > =C2=A0=C2=A0 - |
> > @@ -177,3 +192,33 @@ examples:
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mediatek,ufs-disable-m=
cq;
> > =C2=A0=C2=A0=C2=A0=C2=A0 };
> > +=C2=A0 - |
> > +=C2=A0=C2=A0=C2=A0 #include <dt-bindings/reset/mediatek,mt8196-resets.=
h>
> > +=C2=A0=C2=A0=C2=A0 #include <dt-bindings/interrupt-controller/arm-gic.=
h>
> > +
> > +=C2=A0=C2=A0=C2=A0 ufshci@16810000 {
>=20
> You already added second example. That's enough.
>=20
I'll drop it.

> Sashiko reports are valid.
>=20
the reports are indeed right about the missing supply description for
AVDD09_UFS_1 pin.

The MT8196 and MT88894 SoC datasheets do confirm they are different
supplies, so I'll add its description and also its handling in the
driver (in an additional patch) in the next revision.

I'll fix the typo (present since v3) as well.

Best regards,
Louis-Alexis


> Best regards,
> Krzysztof
>=20
