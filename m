Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3421279DCC;
	Mon, 18 May 2026 16:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.165
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779121426; cv=pass; b=u+AIsE7AoN74MsywvOT+tCq1Z00zxwQRUdcRbgs6bFrZBPXbWSGnwbTgs1iGzNUDr0FLhvVM6LeJn12AalY8TGGURvr/YNPMLb+fM2g0kcN7Mk4C1QuAUdGU9QO3ZGpQfK9bzCbzfSzRl6z125lDYw2cO21KOrOv+FJ6zIeG9N8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779121426; c=relaxed/simple;
	bh=OxkY6IfIMk8HttNa6vjXotrepNIIHHBNyHmU182I8Dw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uLu+QfR0IF/rAixpyXs1HI/vVUSGdb1yF2c0grN8ELgNYtXFAAdeTRU2OKSoJbg4oYLAIFSii92ahemZ2ezS/K1mQgAXqADUH/w2VBL/nDiK3IOqYqLnTTwRNqjydVt1qneVwFJn1+dAMxXOVHY/a7CkCo1feSE5DdkM1rBaUWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=TsGPzwlK; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=uJoVODoG; arc=pass smtp.client-ip=81.169.146.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="TsGPzwlK";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="uJoVODoG"
ARC-Seal: i=1; a=rsa-sha256; t=1779121407; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=jzniR8mgvFsdxUXRMrq6wWeRa/BtZpjXOTa1jiJUXwGh6iLj5DVept/Q9TyAg+ueKh
    JWFAJirWrPxWXbdndXW+u2Wl7JFJX6kbz6hopbWrPQLVCm8O90WiTmM8ZgMC/rLL8xXF
    Zky7vDEDXyflHo8uPO1xTJFkxePSqQ72ZFEmMJRCuFAT1mQtDA9ZmTjwc6/0xceOBeE5
    Cs2L5nqC2dH7rYenALBEr/zxG21KK8dp73ZEIrRm8VuHqNOkkkM3ZH7GjSm3Ta08uZJa
    xq6eBGZQffwlkRJb1ieb2TyxzKK1kWf6u6Rl7/qdlVUEHHuuSd8XomQABeDldQjeDOdd
    zkYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1779121407;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=OxkY6IfIMk8HttNa6vjXotrepNIIHHBNyHmU182I8Dw=;
    b=rUW7TgkzjIPleeDlpL2B6Yc29RGAao4MJU5gEIjWp8A7VyJxSA/o8x85/QOYOzdcbV
    ScwoqkXxDjXvf0Z90BmMI2jIKWKeSwuoZySXDEhnWy6yPXBEShSa/oxGwTqUJ9Mw1849
    e5NbFsyrzr2+mHWyuAcqgu9JiNMvFBtlSEUKkMvpGx+zCk/1G193eZ+0RQYO59jP9xvg
    JiRjPYQniLM8cVdQlrjs5DH/DOxffCRfX+pR9p+hlWNsNKndH/InRFgfCB8DuZ7XAwVf
    Odm4gN9mgf+flJfCdJhKU+6aZaAwI8Pi1pZYVJQUDvYbuMnWUCnN6AogKjcVODceefeO
    ZQaw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1779121407;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=OxkY6IfIMk8HttNa6vjXotrepNIIHHBNyHmU182I8Dw=;
    b=TsGPzwlKKWMjg6YpJWz7/rDUzD+9vJmDkxxkhYQTIcJ7STXV4KNWl8kXQO7h69LcAP
    ON5+bRmw4R1FhXPqXciVdJ1kEKrQi68bzsZwAjtoH43q21x3azQid2Lr44FA4QeTQOvc
    a5nL5rhNRyfctFLCJDifRcBbpbVc0Wlhn8E7BbgoygfiEm/oW/+8K+9PB+t7b8mH+cwO
    VqBe+lNLDajtP6Trufr6t240r3MgBvDEfuzu7WRi9bnE9l4Ysb0Vd7dzAaHjArjKWI2X
    9E9QKmbK/bSyAPEVQTtHEvaiRWw4/0la3Y5JFL8vL2Q23f8mr4c4UALIf+GwmPA513om
    C37A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1779121407;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=OxkY6IfIMk8HttNa6vjXotrepNIIHHBNyHmU182I8Dw=;
    b=uJoVODoGiGJXRV03RhU3drEbFWGDcPYRek9iymxysPsr1WsNCWcv80xYg5LMmasHRg
    Ga0cjctF7cVeJAsnRlCQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.182]
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z7934524IGNQwv2
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 18 May 2026 18:23:26 +0200 (CEST)
Message-ID: <e3d6552b05632519bee9dbfcd7b28e1bbfaa00e6.camel@iokpp.de>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Add a quirk for extended TX EQTR
 Adapt L0L1L2L3 length
From: Bean Huo <beanhuo@iokpp.de>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, open list
 <linux-kernel@vger.kernel.org>
Date: Mon, 18 May 2026 18:23:25 +0200
In-Reply-To: <20260501131641.826258-2-can.guo@oss.qualcomm.com>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
	 <20260501131641.826258-2-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-05-01 at 06:16 -0700, Can Guo wrote:
> Add a quirk to support TX Equalization Training (EQTR) using Adapt L0L1L2=
L3
> length which is larger than what is allowed by M-PHY spec ver 6.0.
>=20
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>


looks good to me.

Reviewed-by: Bean Huo <beanhuo@micron.com>
