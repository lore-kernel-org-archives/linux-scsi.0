Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C613546FF;
	Wed,  5 Aug 2026 16:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785946905; cv=pass; b=FynDjpIZuZw3D57bed5aU+xkBfIX+usqL22MMJxdGis/LArvdz0eX6uSdqvE+ZLV2Ekz1TlyChBZ9STuDAy9TGodsaus3CFsmYU3FL/XSRzJEajF9UE0aB1Bg4IsdZ5WgfaEB6aVftYddjw5qegmjEU8wQhz13SLCcJKt1zTP/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785946905; c=relaxed/simple;
	bh=z8gtXuDqICFASbUQFFO2rpaDpGA+z03HLFSyTevU1jE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HpSiCZYXi9IU/euoKnRi9hr4FtukciDuFsUCvE95MDwb0chJSO2bttmEoCi14fCkR8scT0PyxMu9qDnvKdJsBp7hmmJeUyLXtcfFHeocNMmai5zYSf8O5jGoBtQQyg78Gyd/1mEMFO8bFUaN08Umi6HAH4SBmSJPuj9XrSNFrBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=QgP2ymEr; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=HD3TteQX; arc=pass smtp.client-ip=85.215.255.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="QgP2ymEr";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="HD3TteQX"
ARC-Seal: i=1; a=rsa-sha256; t=1785946713; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=F3UUksFyCcEXeYvUTZIR5fOJDAp9EVMD9zUVdvqqxoKU3LM8d1NTJqLNfWytl6mRCr
    UBaRvyw7rnJZ/lya9IZHM2LMWSd+OuX8RPHqRZL2qvQJCKSSoJZY4xrx1vxBWw9g3jNB
    I8cQczNcYVZGpCBOcghFVKuEmXagE94OSuQAfNZ0596//eOh+1dFheEfM9QUp/HqcZSb
    2SOPer4yBhEHFhBD8t9jnzychOU42VXcqX8m9m914mU9cuTPlkFqmj1eYHLAS+PoYEEe
    HoONC0jg4b+h2UnNzPgqWoqrSgCdkCOGGSKHBTjHyQVrucRBJcr7dtZkVkoYgNZr2FEi
    Sc9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1785946713;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=z8gtXuDqICFASbUQFFO2rpaDpGA+z03HLFSyTevU1jE=;
    b=ILmNzxH86Z8zzfaZjQTCQ55G64Q7L4Kax/KvBP39JlpM5KqqMgNWW9KvOI5ewbtINZ
    DJEASZnyBWpZ5p5xG5UN/5LXu+45AIX6qSd08An/pb6FH39tTAFkIYBBkrJEru+xYsBK
    0skJ3rHVrHYbjEunoUVVAxUdHFKkkb1ro21G1JjpEybZcCnOk77D4cSaI8nLRs/+0wZF
    x73SP9Mn/Ui9uM1zGYEjQGHS8mXIPdvxQ9XIc7T9O89fQv/JkGKaT8K32pQPfUFRU9C4
    s8qnS6+619j1IT+tZKYsLQ1Buy+dAZEnlA+kLTwV101kcboyKaktaNAGGX2qWUV0vLn3
    cwPQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1785946713;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=z8gtXuDqICFASbUQFFO2rpaDpGA+z03HLFSyTevU1jE=;
    b=QgP2ymErKDmHAYJIBADnMJYWd8675kTj52fjazW8mX21OKBBsRrfBHiW94AkbsIIL8
    Gzuc1npKy1ArbExTry4D579oFvvZjUL8C8VVgmSvV5DZCuOaZrxqJd1OsK9Xn5NjAI3k
    uOIBEp+lMm4L+SNLBE3Hy6nySn3/e+lcyz23055GKV2USFPmkzVyHgGVcsAHo0uSjs4L
    svztTwxuW55lZ1eLW5/ISvfCcSNJGwtXuRb2EFuieAXYAJdCZR8qs5ZjslA0l38gph2X
    jjlyvb2jJOCnTq4S20hRuGIwQghQN28t+/kGABloohwuc/t5ovcUNrpg3izMhmvJcHrW
    fdjQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1785946713;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=z8gtXuDqICFASbUQFFO2rpaDpGA+z03HLFSyTevU1jE=;
    b=HD3TteQX/xy9EcCcPPH6953nI54e3lRKT9fdkp93qbn4N2GtiRe46Ce8nUxj4FSyC/
    6E4s6SrgBL0+BgKPCGDQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id zeddc9275GIV50o
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 5 Aug 2026 18:18:31 +0200 (CEST)
Message-ID: <ccbbd36373238b41ab00b44e22c515b76aaf2ccb.camel@iokpp.de>
Subject: Re: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key
 derivation
From: Bean Huo <beanhuo@iokpp.de>
To: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
 alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
 can.guo@oss.qualcomm.com, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, jenswi@kernel.org, sumit.garg@oss.qualcomm.com
Date: Wed, 05 Aug 2026 18:18:31 +0200
In-Reply-To: <anNN4gZc9nvadHNs@trex>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
	 <2e8b4b54f8bdd933d97afdcd52d44682440647b0.camel@iokpp.de>
	 <al3-w3j2-E2twGZj@trex> <anNN4gZc9nvadHNs@trex>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-08-05 at 16:51 +0200, Jorge Ramirez wrote:
> On 20/07/26 12:56:03, Jorge Ramirez wrote:
> > On 20/07/26 12:23:39, Bean Huo wrote:
> > >=20
> > > This is very strange, coverletter is v1, but the patches are v2?
> >=20
> > I messed up (manual edition of the letter) but the thread is proper
>=20
> Any other comment on this set? Can we agree on the ABI change?
>=20
> you can check the overall integration description here for more info:
> https://github.com/OP-TEE/optee_os/pull/7881


I would be ok on the ABI change, for this series kernel patch, patch [1/2] =
ok to
me, just [2/2], I will add comment in the patch.

Kind regards,
Bean
