Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E50E2E718B;
	Thu, 28 May 2026 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779983886; cv=pass; b=QtqgTE647hZdwIhMHvU6k9KqB8SKPqn29Vov2B1oJE3/pxX6HhM3jDg4RjM0M5n6pvtvL0Oi8/Nv0s9z17SMiies+5qgdEnKpthbtlxVeGZU/clfYjTSeGR197uO7H7RfiRq8odzsDCkR3OZ/5mwR7MkGGxrQf0/4MrAxVbWW3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779983886; c=relaxed/simple;
	bh=IviommVns9hiPVnMSUnZvKPxi/VVgjC8bpy5movx/4E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jRptDUyu/HC5a/Rh2udE/oYLMHeuHBJ3AFYpiNiJLpedQ2pVSgOR4C/uN60q67zZf6ISo7Ojx4QH/njAWHz7RILFqdxKfpKRPhrEBbEfhcTMOcHxdmaIJ5c6Cunh0TDGSvC6ng7C4+g4P1p5uHX/Vc+luaqXWSqk40or5Hp47zw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=dLVsIlFa; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=aotMFwwc; arc=pass smtp.client-ip=85.215.255.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="dLVsIlFa";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="aotMFwwc"
ARC-Seal: i=1; a=rsa-sha256; t=1779983865; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=dS46eStnoVsXJbE/RKEdiHIYRy5uVpKfM4QYRLz4+Pyq2BOUW+DbvDtO0SHy5Qw9FY
    j2d3PwlXyt4aNjkSmlWmVe7uSwrpvAzUOgB0d9qAGsjzbQ8XX7S1sr0jVqBNNNF+cEL6
    pkYfVcbhKz2ZwT+lfvCpZxjdXWSF5GVDpbSoEfFoQ4r/OmsxFPQNUIhsOS/7Z/mlDBaa
    tojRJIcFHqXlgf8obgKQ/8qk3TzvTMtURPX5Y8mt0oT+u8L7HKrzIibiz+sFidphAevF
    pTw8nuAmp0hYAQ2uSCxzfHBvV0BMYONMZP9kqebqpeM9UgHl0/9eT4TWFX44EMAWEWgc
    Ae9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1779983865;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=IviommVns9hiPVnMSUnZvKPxi/VVgjC8bpy5movx/4E=;
    b=MNlKJQImRah8pTvhvFL8cmkpigFmdbt6IBG+Z6MIQttEILt9uqKokvgyZo80tsIfyU
    wOhiJXb/eylso/zinCKSKSJNBD8EXGV06U7++0EKGMfjaMcM0ckSKBnesHQCUT+45L5l
    vl/0+EpBJ79T62EOKmqa2Hk6QstsCawkgP/+En5qxpqd8p1HNMBb1WR0n9g7PW4SqIui
    gSOTdysU3JReA/mMIYQxHCR2ibg6jMVq90/SNl35PiUolSS4bvY1hYYCRgWgF4698ToZ
    DOfb8UJgWd59RdgMU0kmcKi0400WP7ScamzhWzRyD5o5KVIR2dEfwFBjoGtt0TMiPsCC
    430A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1779983865;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=IviommVns9hiPVnMSUnZvKPxi/VVgjC8bpy5movx/4E=;
    b=dLVsIlFafK6ltLx2xuhXyODGyz8ClyTf+9wLsXGjltCCb7Fjzo0DEt28fyVN+8tQxu
    NR7zH/aqWC0ZFlf4T1O4GqoQh7VpaGQc8u02AUunmUKp6fFIdpoaye2lse4pALxOhm5T
    qgKWgM1PHP6TXuVpOGSo97MLn03ObbOFhb4cI74lOf3TLnCxkxo0GtpuVZfRE3kB5l47
    g+eFEY1znYCpbyaUX/uNsRl8fRzzmy1VWnPoAzTvCtmXT5ka66xmZuHzba5luRwXyat8
    5PzdJ3yifibW5afxglkghxkWlEDjV3W+uvLbhoWyUJU3rSjb/qBRT761oD/K52mepyno
    kkHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1779983865;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=IviommVns9hiPVnMSUnZvKPxi/VVgjC8bpy5movx/4E=;
    b=aotMFwwcQ9ewPx5q0H5GHbGjB9uzpdCvlD2sdFwoimnSl8v90qfy+NDeDmqvLyqk1r
    Ry4cNfPJRFfjEgiSqfAg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.182]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934524SFviWed
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 28 May 2026 17:57:44 +0200 (CEST)
Message-ID: <2eebab271afadb659a786e6e66e04560dda0a38d.camel@iokpp.de>
Subject: Re: [PATCH v4 1/2] dt-bindings: ufs: Document static TX
 Equalization settings properties
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, bvanassche@acm.org,
 beanhuo@micron.com,  peter.wang@mediatek.com, martin.petersen@oracle.com,
 mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Ram
 Kumar Dwivedi <quic_rdwivedi@quicinc.com>, Zhaoming Luo <zhml@posteo.com>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Date: Thu, 28 May 2026 17:57:43 +0200
In-Reply-To: <20260528100614.3386423-2-can.guo@oss.qualcomm.com>
References: <20260528100614.3386423-1-can.guo@oss.qualcomm.com>
	 <20260528100614.3386423-2-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-05-28 at 03:06 -0700, Can Guo wrote:
> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
> Speed Gears (not only HS-G6) to compensate channel loss and improve signa=
l
> integrity at high speed operation.
>=20
> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
> required depending on channel characteristics.
>=20
> Add vendor-neutral DT properties:
>=20
> - patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
> - fixed property tx-precode-enable-g6
>=20
> Each property is a uint32 array of per-lane tuples:
> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
>=20
> Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis values
> are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.
>=20
> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Looks good to me!


Reviewed-by: Bean Huo <beanhuo@micron.com>

