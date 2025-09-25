Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6601D63CD;
	Thu, 25 Sep 2025 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758812258; cv=pass; b=PhAcH+OvZfKMk+g3RAIpKoTDigWxHm97tbxOogd4ckNFQ6Pc5jQkleJ0EhywCx79ofvn60unXAduip/NzOQ5eWdgntJmPcODjFTUQUzmrCMhRcybdDWTWTVkiT0GvgGcsvjqeHr1LPhi8fd6sBsWKocWhrLgMRpJvzRckSM2F4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758812258; c=relaxed/simple;
	bh=3ldgBpz1sge+KvxB+jBoeRxMENW6zW1QtNR63O3m9eE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XcH7+PKTtGa0R1aKb1UPnbtwQk2EPqrZ+JjHySyDezoUHCHjgUfJs6aTXV+ojQCc+FBkVnEK7qkv2pchx9cJwU77uIVPQZTi8npS/b+kxBUVGJgUrXMn1Z2bV6SGXFSXgxfDe5Y6NGCH4I0MlcgUn7s2ZOj1RsoZ/qJdf1CkZqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Mm34qHhN; arc=pass smtp.client-ip=81.169.146.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Mm34qHhN"
ARC-Seal: i=1; a=rsa-sha256; t=1758811893; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Wks9rFjMhMdlauncy0O2xHQ8iLMFrFV/ZaN9v+Z5DUUE0lXiF7YwKtEy6IptAaOxF8
    o4k6q1bZ+9lT+elaZg53SVOzsuCOxZ4J1/lbD5Nckr4fVonNhpz3q0byHPLnSpl+Dkam
    F4J0Z/A3ax0nXLcT5AF6FCZp/QIGgEGRF1aCH2ybYwQ4p91Frhi2je/g7VZYNMn4RPxI
    vOgxZQT/7+r8r9YFx3lyTZZkYv4IoUGZb3cvt3lLAHpng4Z7+JuT2xI2L0vyXkaCKWZp
    pQRfFTi4ZFOAECaTyMiEMR+De+P5ngcsfiZP7cOxCxKkjhPGPuB5Zzi7jMAvT4/TsmD0
    8jSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1758811893;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=3ldgBpz1sge+KvxB+jBoeRxMENW6zW1QtNR63O3m9eE=;
    b=LIFtXBwTszLh9HoiFQc1yS4sgyk0LoiS5113ewqEEIG+DVA0gG6R9RiBqjRYD8iH4C
    J41Kk3dIEYZEy36OagCWfzsF3vyzzA7mMFGBduLbxr1CMnKE8zsF9UYOCp482ai/JEUr
    68hO7DzHlT5XFhEkDTCSR7FzHpTbcGhVlT8egTHRy8S6QgdEa8L3cpedQlY146h9ZzR+
    ocht5bABnC3QQEF7s0BpQ/ptkAyq4MTV/txuHNcCjsmxgajSGj/ypzUMorrChQmLvTSo
    VlWbBrJqP3LhdrvY2y46L0yrSuGfsyXq6GYV0g1H1UZ+LCcWSKu78aLrBnzW5ZP7XcwL
    s7CQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758811893;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=3ldgBpz1sge+KvxB+jBoeRxMENW6zW1QtNR63O3m9eE=;
    b=Mm34qHhNTsea0MirIPe5semBUhMVOTn1fO7cupkZP0mqxMSExyWh7D/jetMOQwuLmD
    R0SZUtu3Iry1eP29hilXDHO53dlNXGFE3psDKXx6fodOZRa6kJV2CaNWpfpObV3bQkJT
    fXPLF0QyV4nQpQ4lcVKAzhd7AoI+DgfXu2tYMb3h/2gdI89eIY1ZE/dWJbjNWmELSoe3
    yxvclB5iw6m7jwBF6YA2Nvge84Uh2+y+qcjGWzD17J9tBxPEt84nY5V8NJoHMNCRs901
    ExX/4gIyKtDIzk2bJDk2jDmYaq7YSJDqKJ3S5WX044qUc/HwjQIY7tVqrds7vBTCWALj
    c0Gg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.235.211]
    by smtp.strato.de (RZmta 53.3.2 AUTH)
    with ESMTPSA id z9ebc618PEpWESA
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 25 Sep 2025 16:51:32 +0200 (CEST)
Message-ID: <af99ce08cf20977d92f3b993f3b989b91d172c79.camel@iokpp.de>
Subject: Re: [PATCH v1 1/3] rpmb: move rpmb_frame struct and constants to
 common header
From: Bean Huo <beanhuo@iokpp.de>
To: Avri Altman <Avri.Altman@sandisk.com>, "avri.altman@wdc.com"
 <avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>, 
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "jejb@linux.ibm.com"
 <jejb@linux.ibm.com>,  "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>, "can.guo@oss.qualcomm.com"
 <can.guo@oss.qualcomm.com>, "ulf.hansson@linaro.org"
 <ulf.hansson@linaro.org>,  "beanhuo@micron.com" <beanhuo@micron.com>,
 "jens.wiklander@linaro.org" <jens.wiklander@linaro.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>
Date: Thu, 25 Sep 2025 16:51:32 +0200
In-Reply-To: <PH7PR16MB6196C3B7F5186F3E63C05A3FE51CA@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250923153906.1751813-1-beanhuo@iokpp.de>
	 <20250923153906.1751813-2-beanhuo@iokpp.de>
	 <PH7PR16MB6196C3B7F5186F3E63C05A3FE51CA@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-09-24 at 06:12 +0000, Avri Altman wrote:
> > From: Bean Huo <beanhuo@micron.com>
> >=20
> > Move struct rpmb_frame and RPMB operation constants from MMC block
> > driver to include/linux/rpmb.h for reuse across different RPMB
> > implementations (UFS, NVMe, etc.).
> UFS RPMB differs from mmc RPMB in several levels:
> =C2=A0- 9 vs. 5 operations
> =C2=A0- frame structure: extended 4k
> =C2=A0- rpmb unit descriptor
> etc.
> And as time goes on, this gap is likely to become larger,
> As mmc is not very likely to introduce major changes.
>=20
> Thus, you might want to consider having an internal ufs header - will sim=
plify
> things in the future.
>=20
> Thanks,
> Avri


Avri,

thanks, I got your points.

In normal mode, UFS RPMB uses the same 512-byte frame format as eMMC RPMB,
with the same fields (MAC, nonce, counter, address, etc.). That=E2=80=99s w=
hy it makes
sense to keep a single definition of the frame struct in include/linux/rpmb=
.h,
so both eMMC and UFS RPMB drivers can reuse it without duplication.

The major differences only exist in UFS RPMB advanced mode, correct?

For advanced mode, our plan is to introduce a UFS-specific header for the
additional features (extended 4K frame, new opcodes, descriptors), so that
UFS can evolve independently without breaking the shared interface.

let's firstly enable UFS RPMB in normal mode, since its OP-TEE application =
is
avaiable in OP-TEE OS, the custoemr can use it simply. As discussed with Je=
ns,
we can move next step for advanced RPMB for UFS, is this ok for you?


Kind regards,
Bean


