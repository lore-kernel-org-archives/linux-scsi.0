Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33EA3C1985;
	Fri, 29 May 2026 10:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780049972; cv=pass; b=CAzbiQmcODKEtVlJ4+mBka36AMY4AEHa4fZweimkkUb49hgGNNr3AWhUaNGCahzPIvV9VILJFDutpgiv8pD7T5q2JQOuqmKxwCE/HJPkcUsklD0Jp7SLcDzXGag9uocElZNyuw0WlpiYEmzg01gOwqYe8IyfRZHFflFEOcjn2kI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780049972; c=relaxed/simple;
	bh=dChpPPjMQ67fJAFdNw/95fvpLJHk2ZD6lG+2caXpsGs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nyGI0qDa6Ik5dZbIHwLRqYyUsZCntbU5QM0oxe7WUsJhJ6u6fvdnK+X73HdnNhN/NPirvcreDM1c0fy1eAu6P75MpQNRYnkYXbyL3OZTsJiZRabDVkX2ycdZ+AmG75DkA+XU9dYsBkyduoBFbMfu5SNUW2cJCw738lED0I8zj7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=idXml4gQ; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=w7UeMlAL; arc=pass smtp.client-ip=85.215.255.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="idXml4gQ";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="w7UeMlAL"
ARC-Seal: i=1; a=rsa-sha256; t=1780049951; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=hqlDQrNbrWVPxNqhsrpnGVs2bWXIS9qTMdZqBic4ezqQORuok/2TTfB7cHXBF8LGfY
    /WO2pATR8MJbGyGs0OdlcAGTPQy8EAyC6UdTsxrev+toJtCwJArDgB2EEdJp9hAAPjDo
    tmoZ/veO7dNZRddzNQpYyFZyKyfJA0eKtV0fqpFs002nPlqv4P2JnncX5vD1jW4QmChP
    J6vGZUj/9RFNru0Q68pGgbIsfEn+MRVaaPQtptniDXTBXB+hj/SdZaZ14zKY0HyEtlaM
    M09mNHBumUQYQ2zzTpF9O6tIqz8lhc4xlE/4Vl6e0hd3bwjxgv6qY7ydlGNzMfU7q379
    Ol5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1780049951;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dChpPPjMQ67fJAFdNw/95fvpLJHk2ZD6lG+2caXpsGs=;
    b=G7Ud+Lec12yqQ8Phy1DyChxwxfafDRaIlNMM/t7CRlEGvkRsAaVTERR4IrYOecNHG/
    K61+cJvQAoYqPe0CDg8abcyJh0vzMX8zGfbMow+LUUOhmX64hNuhcJMDuAhQaE99RSSU
    hDTAu7J9qWSRP90DCw4rk4rZ6dTsW8hXxxzyvEen1VeMLPM0ti6U0APE1YOr/xir+csb
    g+LqY0pb/WApfqxwhVWif1Wxw9S/AlDeshDDiHBCZI9bxbc1Jy+5sPOtJxPAjRP8sXF7
    VYxiXqp9WCuUM7Axjt2I4g3A+IJqPlqugffv9HeZpfIQ4BnPfs0glMfirR0SjYgn1Eou
    dbbA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1780049951;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dChpPPjMQ67fJAFdNw/95fvpLJHk2ZD6lG+2caXpsGs=;
    b=idXml4gQro6Cnk38WRIYdIi3v55sGcRolgwQB962meP6musUy4l7bUcmbaqs6rgxAJ
    35CMztA/5FbpEkVr72gicyhxeYE6HKs9QROKmdzrMawUe1Tjl6ktdnNbS3Ffdhc6LIHH
    jEm/sLTC1PVa8oC3EH/3U6q1l2Vcb/1jAlI0GeXalA2iTi9oa6mB6mwRo6IJmNytQ2BZ
    1GZLsd9AHy+gj0ONw30+635RRpueQS25as9Dgl/bzy6SywMtZfExkfo9TLgU0BdQvPbR
    jd8zM0uO7rYUrAszRCAHdk7v3A+SfiTGQvLChA47m2Iqbdim/gN5n3qFcEdzqp39wELz
    RRbg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1780049951;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=dChpPPjMQ67fJAFdNw/95fvpLJHk2ZD6lG+2caXpsGs=;
    b=w7UeMlAL8Mzlr51jXtcHl0uyTkjcoZcVDtXzXeZQTBm2sBw9Webduaq+5RDaU6V/OO
    znRHKEa/Op0ElDZSv0Bw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.182]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934524TAJAZD2
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 29 May 2026 12:19:10 +0200 (CEST)
Message-ID: <e79510e02e1025f9a5c3dff0208cf63b22054bdb.camel@iokpp.de>
Subject: Re: [PATCH v5 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, Peter Wang
	=?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?=
	 <peter.wang@mediatek.com>, "beanhuo@micron.com" <beanhuo@micron.com>, 
	"mani@kernel.org"
	 <mani@kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, 
	"martin.petersen@oracle.com"
	 <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"quic_nitirawa@quicinc.com"
	 <quic_nitirawa@quicinc.com>, "James.Bottomley@HansenPartnership.com"
	 <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	 <alim.akhtar@samsung.com>, "quic_rdwivedi@quicinc.com"
	 <quic_rdwivedi@quicinc.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>
Date: Fri, 29 May 2026 12:19:08 +0200
In-Reply-To: <0e3c4e21-0c54-42b5-8863-8604f1b698a8@oss.qualcomm.com>
References: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
	 <20260529011421.462046-3-can.guo@oss.qualcomm.com>
	 <1e432db04abc12c4109754788ab36a09111cf3e9.camel@mediatek.com>
	 <7f2f9a0a-03e9-4a0e-ae57-2b0c557e029f@oss.qualcomm.com>
	 <f2e1a0335a7c05ca7dbf48c17e9662e9695ded51.camel@mediatek.com>
	 <0e3c4e21-0c54-42b5-8863-8604f1b698a8@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-05-29 at 16:42 +0800, Can Guo wrote:
> > if (!lpd)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> >=20
> > if (lpd > UFS_MAX_LANES) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> > }
> OK, got it.
>=20
> Thanks,
> Can Guo.

With this and Peter's num_elems rename addressed in v6, please add:

Reviewed-by: Bean Huo <beanhuo@micron.com>

Thanks,
Bean

