Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90B4426693;
	Mon, 17 Aug 2026 14:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978208; cv=pass; b=ncixZJnvfTSJxqjtz3ZxG7pX3+l048epPTFcr5h9kLBdKvnAi7Ms7xuhspJFU4UGSH72avD/z5tYkQB3/449kwCP1mtSYv2E6B/wf0BCc860T4vJ7mbc95u48xKcSCxMK8H0XJcYPyz49wSuwmEKlOJ+ZtD4pmvOUxCgqvCNEeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978208; c=relaxed/simple;
	bh=2Tq/9QSYbQwm7tDYRmosxYkEou6Sw/ZIkIEQBGz/Q48=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YuM9YipQ86DBcYr8RfwYybB620wVAOMAZOTFOGC5tyJspsZYrUJ38dUs2+VTss7U7wXJ8xuOY501xG2mbVOSgKRsflQekP+G8e5PfKPPYIOlSNYOTwV+nwqfQNR8almOpGVOTp8VtTf1ucmUtgWlbWikyLRlIuc0At9mvtG09R0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=gqrcrrlE; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=OzHVOXqi; arc=pass smtp.client-ip=85.215.255.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="gqrcrrlE";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="OzHVOXqi"
ARC-Seal: i=1; a=rsa-sha256; t=1786978015; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=CEZo2J8NhSURSyh7wLIymKPbD9Mv9dvEXNKTBtIygRzPOXxQR1l/IXrbgtDXyMKttM
    pz7j3z6P7Pxwyj7RCpXZmxQKi/zyYmjAzWc9MhuBZ9GG0uZrgIoDe9ubhM1/uIOUVUqA
    0eTqN6ZK2AtpjRp6NsLHb+14mZ90vDY8SaAAj5Cu5L9/lr8Hht4dwYy6dUrcy2ex906w
    rrCgwEU8aX4ZcxJBcUVBxILDPb6eOEvXdcHY40mRPPdDe85SKh3lJVZKK6T5RVGWXDvX
    wuJdB8xivsH9WOHz5orll3sc9flTeRpLBvrfL1cEQviCNHuNbsD3Xa94bO9zNTHrIpRO
    BiXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1786978015;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=2Tq/9QSYbQwm7tDYRmosxYkEou6Sw/ZIkIEQBGz/Q48=;
    b=UShwBQtOIfT3HMzXD8c/RkcjsyJBDG+FbFP8SpWEFpwaWBdYRyxlh+rnnGGYJ5iAS8
    ChoB4z8itdg046qF9RvHMnVle5OCnK0NtU7avMdXCetWMy2mWnr+rqfOlrc0sAFN7a/F
    Rouxz8fPJZGVu0B8r52A3NOPU2dqGHrGWjlPws34FMD9a71JzB0h7iTg3uocdUnkkO3H
    F5C7R3gbV5xS0sMHeBu54UGB9dbu1ydhIZIZtRyS2mVsnuVIuMdZJDhQ09SSq79yGHCM
    hx3L3PGFsIJ72+5nl6udC7GS+kABTCvwlQO5JvDPJ82m4RKEfy+etpA8YL8lTEXR8Elj
    IlGA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1786978015;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=2Tq/9QSYbQwm7tDYRmosxYkEou6Sw/ZIkIEQBGz/Q48=;
    b=gqrcrrlE6kSqQC3QTI7hdezfa0+1kkssANfN6sEKS//9484RpQrJUg4dUwk/Mfcd3+
    wFOILtaTBLtTG3rGHqNqb4OPySoTkQWGwfLC7F1296mnkLfS2QarCg62qY87W/6B2Yu2
    PexnvfVNXWV3wJuyxMeovFsJWuVt+0b+/I5lzCX/fKwshJy6SrhTjJg6Uisy0MXI+q3i
    nObgcarbznP1Ik4nX8fNLqTWANmejTW9prcT6FgJ/2gRp9xrEiTrK3QjhqZgEE/erGKM
    ltRXtCgjOtx3YmuGd9PCWuyG19cWvM3TRl2z7VhScQCN8YvNQvNwpBnecISfCh8cQ8Mz
    cvVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1786978015;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=2Tq/9QSYbQwm7tDYRmosxYkEou6Sw/ZIkIEQBGz/Q48=;
    b=OzHVOXqiTv4gNpmOvQyuuQu08qolFMFpL827cuID7Q4bO/AT+3PisqoPSh1BbvW9yb
    tEONLcBbATJrxllZCECQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id zeddc927HEksjEP
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 17 Aug 2026 16:46:54 +0200 (CEST)
Message-ID: <ef5b527c25b9965296287498f7849f8b62533298.camel@iokpp.de>
Subject: Re: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key
 derivation
From: Bean Huo <beanhuo@iokpp.de>
To: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
 alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
 can.guo@oss.qualcomm.com, beanhuo@micron.com, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, jenswi@kernel.org, sumit.garg@oss.qualcomm.com
Date: Mon, 17 Aug 2026 16:46:52 +0200
In-Reply-To: <aoMdoE35kN_GjMHp@trex>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
	 <2e8b4b54f8bdd933d97afdcd52d44682440647b0.camel@iokpp.de>
	 <al3-w3j2-E2twGZj@trex> <anNN4gZc9nvadHNs@trex>
	 <ccbbd36373238b41ab00b44e22c515b76aaf2ccb.camel@iokpp.de>
	 <anRVtmk7ejWewDX_@trex> <anwYtSvM4HjI2VLv@trex> <aoMdoE35kN_GjMHp@trex>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-08-17 at 16:41 +0200, Jorge Ramirez wrote:
> On 12/08/26 08:54:45, Jorge Ramirez wrote:
> > On 06/08/26 11:36:54, Jorge Ramirez wrote:
> > > On 05/08/26 18:18:31, Bean Huo wrote:
> > > > On Wed, 2026-08-05 at 16:51 +0200, Jorge Ramirez wrote:
> > > > > On 20/07/26 12:56:03, Jorge Ramirez wrote:
> > > > > > On 20/07/26 12:23:39, Bean Huo wrote:
> > > > > > >=20
> > > > > > > This is very strange, coverletter is v1, but the patches are =
v2?
> > > > > >=20
> > > > > > I messed up (manual edition of the letter) but the thread is pr=
oper
> > > > >=20
> > > > > Any other comment on this set? Can we agree on the ABI change?
> > > > >=20
> > > > > you can check the overall integration description here for more i=
nfo:
> > > > > https://github.com/OP-TEE/optee_os/pull/7881
> > > >=20
> > > >=20
> > > > I would be ok on the ABI change, for this series kernel patch, patc=
h
> > > > [1/2] ok to
> > > > me, just [2/2], I will add comment in the patch.
> > >=20
> > > ok. thanks Bean.
> >=20
> > could we follow up on this please?=20
>=20
>=20
> just a reminder - there are op-tee/u-boot patches on the fly for the feat=
ure
> that come together.
> These changes are important to unblock
>=20
> tia

I don't know what exactly you need, I have added comment in your patch of t=
his
version, you need to update it.

Kind regards,=20
Bean
