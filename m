Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D95360EF0;
	Sun,  4 Oct 2026 10:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791108662; cv=pass; b=axLSUwtQ0PM7+fIhGaCW/TI8oFGpfCdzSO9biLopROUneSb1tp7QNZfFZ+g9yK47/Bj+VtxMDWOP6A0xW1EjxJFkhuYXWrbPJR5+4/EP9G4+6dKxtzky8Z6klB7UmPQHgzZuyeIjEb56NHJZjddIJTb8TApbi83kG0bH2UHVRqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791108662; c=relaxed/simple;
	bh=37n/ScR6J0FLKpn6j0oLLFJDr7TVcgDbhPeXvOMF2g8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BzDbV+LzsDsSAbz3OAxK0mbXgXZ7xs2SV0g4mOAfOQeUKyuUaiHqMuWkLwhHaMhmOBYZVx4a8O1JMqP7h6B3lYwro2hjrH8/u7qZVFgkIWAPKk4xuqsm3H0nm74aW+0+00BtMGOwUDhYrmuoWcF/RaLCHZcEkB3BjO9MEiNbTYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=fYW52qoH; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=AIy79FH3; arc=pass smtp.client-ip=81.169.146.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="fYW52qoH";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="AIy79FH3"
ARC-Seal: i=1; a=rsa-sha256; t=1791108650; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=lQflxtnLx0EfQW9sVXJR2hWWyAxzhRMDstsjgGSwb3l6/8ambNWy/iGvBqkXmfYJbQ
    nZCYWFuW4UTpeKkx9uq6IkCRUOMjo0al+eIBNILf72lHXkpe9RYg2OKwR7FkyqeuLL4m
    d01X6kgFw3zgHvGdTRtpMfyc6A6g9kVpu+Nw+EX53eWjQAUouytt3uD7zw3fgG4OqXpb
    xkPM4wNwzF8mwnHcUKpwj0clPlL0ANoGpsBp00BUEeGkrDHN7ouunWWnDx8uU1skuFb4
    OTLX38dNrajafdWf0QV5obuaA9/0WK5P0QQeT/R7i59ueNpiyMWlY6letIJHDuh9Mbis
    ITfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1791108650;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=37n/ScR6J0FLKpn6j0oLLFJDr7TVcgDbhPeXvOMF2g8=;
    b=MusQefUN2bZ8+GXFFh+78pOW/qVyg33EYovjcBE3CoMK9axe9iBZYaIot+VpTJkhsB
    QRIMgMHJrzwaasulBdE797ZRQqXe4H5ji3yC3OVKyE1vHGh658bLkuGFdHZvXbIMxASX
    dhEaex2ihUNfybeh04fpiTWOJ/vzcnvvaQyYGLl8F1cHCALtjDa0jl1hW9POIUAGrZa5
    ntypdzRtEv+00GlsJ4NdonWj5BUB2Lx7ctmKHPi0/oRyMyda+n0dX0IZJhJGoNEJ1Y+R
    zWGlrSgeK0fXa8c8zUoI2sA5v2/NR0/9q+1K+1z1CxeyBeS6ju4+oFGYqVrNtBsklZpG
    DSwg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791108650;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=37n/ScR6J0FLKpn6j0oLLFJDr7TVcgDbhPeXvOMF2g8=;
    b=fYW52qoH4h+lveTfwxbXKV4ddEHCYuhSh4JFJYoOwAXM79BZ3z0VYm8bEVBWFRjl3j
    55TIH6jzFcyoubda+hxK7+nXlvdBWhIDu5sutn5fOxskGaYLwlgn3go8Ku3he9/fmhFO
    9oOmq9DtPenJELgj5+aAF1vZWUSzMmkY3MIyVxRcH5PSQJ1demLOJ8P0s2HfQmIoaiRP
    ++4jJfI+vo0eQAihEQzfhdyBP2+lTnT3mAyybA6amDhvFZxHbsKQ+rjMlCSj340OOLqN
    f8TcyWNgEnIiv8AaVx00yxh8WtFRqFRYXdqMp01KF7t/yWivkjlLF+YU3R7wZDg5qODZ
    pnYA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791108650;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=37n/ScR6J0FLKpn6j0oLLFJDr7TVcgDbhPeXvOMF2g8=;
    b=AIy79FH3O7P1j5hVy0FVrT3MCRe7VR+A1TGBPY1S8jDpk3gZegHGjQde1mHWur3XRT
    WVGJAyAUuP2RkGT3u7CA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeWpIGzMAy/YE6epPbif4XeXVBNcpBUndJue98="
Received: from p200300c587368422312fd651734ded34.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id z04e1c294AAoM9C
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 4 Oct 2026 12:10:50 +0200 (CEST)
Message-ID: <481d737323a2925e68f08e1129e1ca904effbea5.camel@iokpp.de>
Subject: Re: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
From: Bean Huo <beanhuo@iokpp.de>
To: Avri Altman <Avri.Altman@sandisk.com>, Stanley Jhu
 <stanleyjhu@google.com>,  Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	 <alim.akhtar@samsung.com>, "James E . J . Bottomley"
	 <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org"
	 <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>
Date: Sun, 04 Oct 2026 12:10:49 +0200
In-Reply-To: <BL3PR16MB4473EF5053283779F18B4161E5972@BL3PR16MB4473.namprd16.prod.outlook.com>
References: <20260930135947.2339918-1-stanleyjhu@google.com>
	 <2fbff86c-f276-4e46-b7d3-549461706d37@acm.org>
	 <20261002134158.2844652-1-stanleyjhu@google.com>
	 <BL3PR16MB4473EF5053283779F18B4161E5972@BL3PR16MB4473.namprd16.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2026-10-04 at 08:21 +0000, Avri Altman wrote:
>=20
> > It was off-list. I asked Avri on Sep 29 about updating the bouncing wdc=
.com
> > address, and he asked to be removed as a reviewer instead.
> >=20
> > Avri, could you reply with your Acked-by?
> Acked-by: Avri Altman <avri.altman@sandisk.com>
>=20
> Stanley thanks - sorry for my late response.
> I do feel that the reviewer role is no longer needed for the ufs driver.
>=20

A sad day for the UFS driver, we=E2=80=99ve just lost a brilliant reviewer!

> Thanks,
> Avri

