Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC4C375AC4;
	Tue,  6 Oct 2026 11:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791285055; cv=pass; b=ozbX+KwdkLMhtXTtckv3z939ePbxY+gqRhdfuaAvNto1I1FjiBK9vbBYjDIjFIsvPVOmAleXn7hCQEF7PcoXCI9kRQ+uxTidr70kCllZHKZxSar7wxiqu3H28t+D+SUxyNMOByR04XrPLQll+df3roya5HXmujygZNZvNLYBkxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791285055; c=relaxed/simple;
	bh=ANftsOVmqaZrOreCeDPKC1Hc/N9LZSRlGAcKVOmBucM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QSiTEFlzbRIG8y4uV/ni03OWWxCngVffFRRTkU7FF1OsuHrFsgUc2oWdgpzTORSMw6vrWwQVTM2b2VG9EOHNVqp/L8eNDiRwrzCDwYxyTI2D3Squp/1Sb11wBM5KreVZoKBm3Q4Ms1sqTVtmAIpF9NbJVfnem1nWjScI3ijZhqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=UIzD7sas; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=PFiEa/7E; arc=pass smtp.client-ip=85.215.255.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="UIzD7sas";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="PFiEa/7E"
ARC-Seal: i=1; a=rsa-sha256; t=1791284863; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=BLTfIalHgTLMPF3y7NapsXjLLchi2NK1ZHSnYgqEknMf0atlC8xNotYxFDdqQYM2ip
    tE7BMx1641H8l5I59IBsfFovgeEwFrkC7ZYZANuRyDvE1uimjdL1zOIYP4QUk4M4c8+0
    715QF9wpjQJZp4hMnQ62FPea2QbTRgI0kG9Yqe++TZO0ZvglDRNRRf3rbPrrb2/ezqbY
    lxgSKxl9xVEn7tawgGHmVvAJA3K/bAbpnQQ3Py4l0kg6b9I2VbErJdeBtGwAYhJhVR83
    CrmVKxg7KWV8lndXaDhdmIPgSFbDEfUWpNYp3pqDZboCm7GBw6Z2WuLNW5c4uyQ+Ju6j
    5aGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1791284863;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ANftsOVmqaZrOreCeDPKC1Hc/N9LZSRlGAcKVOmBucM=;
    b=SZzAaLXblUbnoouLqD5cefdg/p2fZu2cxAF0pqTL4DDLMO3F+kDyJ+VW18ZLFmK7+T
    ssmwxiqjDaUbw1j0HwmCEUcfxGth34r42/UXOWFdWYhPUQYGgvLjb4erzbbbFqndX3PP
    jXoJxyLuL4kpfrf3lCYURDc8bPbiTTOTa2Y+zBTt2biYUDPI/7b8+q2FmN6Iv/MjQith
    bWIa3mWXgJ3wM+JudtMnFrTmXVYiUX0uKdf2yn2gOpUq5PqgH2OWOgSeOj2ilOJvKMUH
    xP8Wvlgs+6dkuFaNBVjuhBaSsI/r+X5R84D0/n3b6cwiO/SCx9tbm1iw0mgExTfv/wdW
    AALg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1791284863;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ANftsOVmqaZrOreCeDPKC1Hc/N9LZSRlGAcKVOmBucM=;
    b=UIzD7saszgRqqgRNPDcajJoGLozrxzSKwblgta3WkRPTsi+WA/tK1YMY+UMDBc8ZqN
    pDpQMp/NAwS/LfEVjvL/yDFPjOBckWvU/3gBuJ8IX0qYliX6jjjVeABWyNdmU/xR9Lyi
    VuguACqw1NXQk2RZYLzHvC1FMrL//xvlnl5oqHpigRygg6jY5PynTzWA4OyO0i3Lp9Y1
    VfA11OEo9EUCvvVko1+tYXFZUTIBqNUIIreY9xkRw1Jq1PpfMu4rh02F4oOaOG0fk8Yx
    u5bUpJE5fnL6vb3J0xrElgbSU1IPW5U1/GR14Dy5BzAmuWSAJBWQ0qguXf22i0YmoIQF
    fVYA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1791284863;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ANftsOVmqaZrOreCeDPKC1Hc/N9LZSRlGAcKVOmBucM=;
    b=PFiEa/7EDviAWlPiXyaeReXT8FpMIge+M7LXP12wu/oxdAk27SciiG8NI3atxeIfUl
    0f4bM49fNhT4A1OfBpDQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.163]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id z04e1c296B7gVMl
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 6 Oct 2026 13:07:42 +0200 (CEST)
Message-ID: <5377501a53a50bc8162cea277a2ce597ffdaf180.camel@iokpp.de>
Subject: Re: [PATCH v2 0/4] devfreq: check the get_cur_freq() return value
 and use it in ufshcd
From: Bean Huo <beanhuo@iokpp.de>
To: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
 cw00.choi@samsung.com,  zhanjie9@hisilicon.com
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>, 
 Kyungmin Park <kyungmin.park@samsung.com>, "Martin K . Petersen"
 <mkp@kernel.org>, "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>, Avri Altman
 <avri.altman@sandisk.com>,  Bart Van Assche <bvanassche@acm.org>, Alim
 Akhtar <alim.akhtar@samsung.com>, Stanley Jhu <stanleyjhu@google.com>, 
 linux-kernel@vger.kernel.org
Date: Tue, 06 Oct 2026 13:07:40 +0200
In-Reply-To: <48814f547eeb8a5c575cd143a2569291de890c2a.camel@iokpp.de>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
	 <48814f547eeb8a5c575cd143a2569291de890c2a.camel@iokpp.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


Chanwoo, MyungJoo Ham, Kyungmin Park, who else maintains this,=20

Patches 3/4 and 4/4 of this series have been picked up by the SCSI tree.

Patches 1/4 and 2/4 are the devfreq ones and do not depend on them.

Would you like to take them, or should I resend the two on their own agains=
t
your devfreq-next branch?

Kind regards,
Bean


On Mon, 2026-09-14 at 15:12 +0200, Bean Huo wrote:
> Hi Chanwoo,
>=20
> A quick check. the patch 1/4, and patch 2/4 in this series would be queue=
ing
> up
> for your pull requst?
>=20
> Regards,
> Bean
>=20
>=20
> On Mon, 2026-09-07 at 21:21 +0200, Bean Huo wrote:
> > The devfreq core has three users of the optional ->get_cur_freq()
> > callback. Two of them check the return value, the third one does not an=
d
> > passes an uninitialized frequency to the transition notifiers when the
> > callback fails. Patch 1 fixes that.
> >=20
> > Patch 2 writes down what a driver is expected to return from the
> > callback. Today this has to be found by reading the devfreq core.
> >=20
> > Patch 3 records the frequency the controller starts at.
> > ufshcd_init_clocks() puts the controller at its highest frequency, but
> > nothing writes that down, so clk_scaling.target_freq stays 0 and devfre=
q
> > starts with previous_freq at 0 as well. With use_pm_opp this makes
> > ufshcd_devfreq_get_dev_status() report 0 Hz, the ondemand governor then
> > asks for the maximum frequency, and ufshcd_devfreq_target() runs a full
> > ufshcd_devfreq_scale() that holds up the queue for up to a second only =
to
> > set the same OPP and the same gear again.
> >=20
> > Patch 4 adds the ->get_cur_freq() callback to ufshcd. Without it the
> > cur_freq attribute shows the last frequency the governor selected, whic=
h
> > is wrong whenever the controller is scaled outside the governor, for
> > example after writing 0 to clkscale_enable.
> >=20
> > The patches touch two subsystems. Patches 1 and 2 are for the devfreq
> > tree, patches 3 and 4 are for the SCSI tree. The two halves are
> > independent, at build time and at run time, and can be applied in eithe=
r
> > order.
> >=20
> > Patch was tested on a Radxa Dragon Q6A (1d84000.ufshc):
> >=20
> > =C2=A0 before "echo 0 > clkscale_enable":=C2=A0 cur_freq 75000000, targ=
et_freq
> > 75000000
> > =C2=A0 after=C2=A0 "echo 0 > clkscale_enable":=C2=A0 cur_freq 300000000=
, target_freq
> > 75000000
> >=20
> > Without it both files report 75000000 and keep doing so for as long as
> > clock scaling stays disabled. A 4 GiB direct read after enabling clock
> > scaling again counted the transitions in trans_stat and attributed time
> > to the 300000000 state, so the frequency the callback returns is one th=
at
> > devfreq recognises.
> >=20
> > One thing to be aware of: devfreq_monitor_resume() copies previous_freq
> > from the callback, but it does not call devfreq_update_status(). A
> > frequency change made while the governor was suspended therefore does n=
ot
> > show up as a transition. That is how devfreq behaves today and this
> > series does not change it.
> >=20
> > Changes since v1:
> > - New patch 3, so that target_freq and devfreq's previous_freq are not =
0
> > =C2=A0 at boot (suggested by Stanley Jhu).
> > - Patch 4: drop the !cur_freq check, it cannot happen any more.
> > - Drop the now stale comment in ufshcd_devfreq_get_dev_status().
> > - Patches 1 and 2 are unchanged.
> > - The devfreq and the ufshcd patches no longer depend on each other.
> > - Avri's Reviewed-by is on patches 1, 2 and 4. Patch 3 is new, so it do=
es
> > =C2=A0 not carry it. Avri, please note that patch 4 changed since you r=
eviewed
> > =C2=A0 it, the !cur_freq check is gone. Tell me if you want the tag dro=
pped.
> >=20
> >=20
> > Bean Huo (4):
> > =C2=A0 PM / devfreq: Fall back to previous_freq when get_cur_freq() fai=
ls
> > =C2=A0 PM / devfreq: Add more details to the get_cur_freq() comment
> > =C2=A0 scsi: ufs: core: Record the frequency the controller starts at
> > =C2=A0 scsi: ufs: core: Report the current clock frequency to devfreq
> >=20
> > =C2=A0drivers/devfreq/devfreq.c |=C2=A0 5 ++---
> > =C2=A0drivers/ufs/core/ufshcd.c | 37 +++++++++++++++++++++++++++++++---=
---
> > =C2=A0include/linux/devfreq.h=C2=A0=C2=A0 |=C2=A0 7 +++++--
> > =C2=A03 files changed, 38 insertions(+), 11 deletions(-)
> >=20
> >=20
> > base-commit: e30626823a406725ce29bc75cb8ec467d3e1e326
>=20

