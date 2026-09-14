Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F1345D5FF;
	Mon, 14 Sep 2026 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391610; cv=pass; b=TUF7VgF2nAVs3CpLOHyuwAwezlPGZ3ZkQ49ZsbvAYKZYniuFAYMCjM/cYLN37GhWb2Pk/0lca2//UYOMrmge2OXJrTbbYGL1FqSJrzlmVlRp1BGsldXqYPSkIQ6MJUpXg8V1CxT6fVyhScf3BXmXzygkILoQXAYfgqcNrl8Vul0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391610; c=relaxed/simple;
	bh=od3Rz2anfBK/DA4lGHcgQTN2Nu4yCe+GYpDnZioFKl0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lk98BBMbuFiToxXpTJfxSR9uCLfHLe5fqAXTkpAXF1lM1t+n6RybStOe5ChJySW5MoQCTpHcxFwUOFj3T1azfhrFWPqCJaOc9pQr0G/zLDYrjHuUgllxMtOoCJGFyD5rSnybWhHff3wk7w1TiFxnlzGY01W0zxzbyWD3Np4RGGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=P1lRGzaH; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Knqjdevs; arc=pass smtp.client-ip=85.215.255.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="P1lRGzaH";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Knqjdevs"
ARC-Seal: i=1; a=rsa-sha256; t=1789391573; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=TFRN07lO06EqnWJkDYmVXp10E5oqviKyBxO4bTLIhqKeqCYBOSMbbOl3nY3y8gda1G
    f0C/TlgWVYTTL0ApK6HJzhPwX1OoudkJsQJVeodkehtXtK/W0Ms3hSgVrZKilkRb7gWF
    8EsazZOzXP+H8kI96LMdc6T1IjCvPCyyjz9blnJinYfVFlr4d//ndSTbd4xSZlk4iJ/c
    StcovhVG8WhrrQG08YhSioEUqarB86rkT5Qnhk3FfrH5JQKXfpGgY/iwi+7iT9sicLKq
    wvqxdUNRU6hE5ozsg6jxnbcsuvDgad6j4GZ+zn/mQ6lz3nRAV5JkWq+lR8iURUlhGdxF
    27NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1789391573;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=od3Rz2anfBK/DA4lGHcgQTN2Nu4yCe+GYpDnZioFKl0=;
    b=a+UTVSDdMu51+KBRQ63d6PfnYXHeZ9sZ5nYWvVxiTz0CLcc9zCE+5Aa/ENu87updbT
    GOOK4WIVQRnrRnVyJIEX1KIHutgkfH2MGtV4RD/RR4YMsaRh0a6gDlVMR9OO/H13Qzay
    cGFlNbphDv0UQ1970CnIBF9kS9NKTv+N1PJLx3rosE8CycIwN9cOrjzBNwUNX6p8hnPM
    RdTtwfiu5VMA//7pGZdzM0MsfLIhE+xU6/h4wpAn6DqoSBsPWNSjHuMjr5+7lkOJMvAs
    9f+glsY7aUPeBsbdUJ7urMfoKp6I3OR8xnENRSXQlFjCQxoXKMhSDFJTJrOcpW8fbr36
    jYRA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1789391573;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=od3Rz2anfBK/DA4lGHcgQTN2Nu4yCe+GYpDnZioFKl0=;
    b=P1lRGzaHYqmKgCWTdzqKX39Ph7oqR/MLmJ6ynN4ajS8fhCA5TgQBMZZHDarwAQ2lht
    LeD4WsIEnwvzM+V4y5BQYKRCOdhtReZv9zzLu3tSAvinnBZru6fVQ/jPh59KawJLhqYi
    Y8XhkKEtlT4JbiSePHRJ/JWhvzblfeTAdfkooLZDPqUMa62f8DDAo3+PWn/Xrr60M2i1
    NldBVCMCm+/GVW31XS8s6aKexNtUPprj1qpa3MEzquCdxCSZVqqVPGwOhphp8gxeUmhE
    7sV566kjt/ZN3f2wj2AiSXHbJEoD59CSUYzaeoz2nheq09awX4blYIrI+xjHtLw2ODfe
    0pAg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1789391573;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=od3Rz2anfBK/DA4lGHcgQTN2Nu4yCe+GYpDnZioFKl0=;
    b=KnqjdevsbCCuXM3DJj2SBHf/yvpXRA4LVQIHOyTrls06q7XhrWurRRm1ddbjPBsjzs
    /7OEo3fAH6pXpGuqf1CQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZqk"
Received: from [10.176.237.249]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e128EDCqcat
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 14 Sep 2026 15:12:52 +0200 (CEST)
Message-ID: <48814f547eeb8a5c575cd143a2569291de890c2a.camel@iokpp.de>
Subject: Re: [PATCH v2 0/4] devfreq: check the get_cur_freq() return value
 and use it in ufshcd
From: Bean Huo <beanhuo@iokpp.de>
To: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
 cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>, 
 Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi
 <cw00.choi@samsung.com>, "Martin K . Petersen" <mkp@kernel.org>, "James E .
 J . Bottomley" <James.Bottomley@HansenPartnership.com>, Avri Altman
 <avri.altman@sandisk.com>,  Bart Van Assche <bvanassche@acm.org>, Alim
 Akhtar <alim.akhtar@samsung.com>, Stanley Jhu <stanleyjhu@google.com>
Date: Mon, 14 Sep 2026 15:12:51 +0200
In-Reply-To: <20260907192140.2701755-1-beanhuo@iokpp.de>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Chanwoo,

A quick check. the patch 1/4, and patch 2/4 in this series would be queuein=
g up
for your pull requst?

Regards,
Bean


On Mon, 2026-09-07 at 21:21 +0200, Bean Huo wrote:
> The devfreq core has three users of the optional ->get_cur_freq()
> callback. Two of them check the return value, the third one does not and
> passes an uninitialized frequency to the transition notifiers when the
> callback fails. Patch 1 fixes that.
>=20
> Patch 2 writes down what a driver is expected to return from the
> callback. Today this has to be found by reading the devfreq core.
>=20
> Patch 3 records the frequency the controller starts at.
> ufshcd_init_clocks() puts the controller at its highest frequency, but
> nothing writes that down, so clk_scaling.target_freq stays 0 and devfreq
> starts with previous_freq at 0 as well. With use_pm_opp this makes
> ufshcd_devfreq_get_dev_status() report 0 Hz, the ondemand governor then
> asks for the maximum frequency, and ufshcd_devfreq_target() runs a full
> ufshcd_devfreq_scale() that holds up the queue for up to a second only to
> set the same OPP and the same gear again.
>=20
> Patch 4 adds the ->get_cur_freq() callback to ufshcd. Without it the
> cur_freq attribute shows the last frequency the governor selected, which
> is wrong whenever the controller is scaled outside the governor, for
> example after writing 0 to clkscale_enable.
>=20
> The patches touch two subsystems. Patches 1 and 2 are for the devfreq
> tree, patches 3 and 4 are for the SCSI tree. The two halves are
> independent, at build time and at run time, and can be applied in either
> order.
>=20
> Patch was tested on a Radxa Dragon Q6A (1d84000.ufshc):
>=20
> =C2=A0 before "echo 0 > clkscale_enable":=C2=A0 cur_freq 75000000, target=
_freq 75000000
> =C2=A0 after=C2=A0 "echo 0 > clkscale_enable":=C2=A0 cur_freq 300000000, =
target_freq 75000000
>=20
> Without it both files report 75000000 and keep doing so for as long as
> clock scaling stays disabled. A 4 GiB direct read after enabling clock
> scaling again counted the transitions in trans_stat and attributed time
> to the 300000000 state, so the frequency the callback returns is one that
> devfreq recognises.
>=20
> One thing to be aware of: devfreq_monitor_resume() copies previous_freq
> from the callback, but it does not call devfreq_update_status(). A
> frequency change made while the governor was suspended therefore does not
> show up as a transition. That is how devfreq behaves today and this
> series does not change it.
>=20
> Changes since v1:
> - New patch 3, so that target_freq and devfreq's previous_freq are not 0
> =C2=A0 at boot (suggested by Stanley Jhu).
> - Patch 4: drop the !cur_freq check, it cannot happen any more.
> - Drop the now stale comment in ufshcd_devfreq_get_dev_status().
> - Patches 1 and 2 are unchanged.
> - The devfreq and the ufshcd patches no longer depend on each other.
> - Avri's Reviewed-by is on patches 1, 2 and 4. Patch 3 is new, so it does
> =C2=A0 not carry it. Avri, please note that patch 4 changed since you rev=
iewed
> =C2=A0 it, the !cur_freq check is gone. Tell me if you want the tag dropp=
ed.
>=20
>=20
> Bean Huo (4):
> =C2=A0 PM / devfreq: Fall back to previous_freq when get_cur_freq() fails
> =C2=A0 PM / devfreq: Add more details to the get_cur_freq() comment
> =C2=A0 scsi: ufs: core: Record the frequency the controller starts at
> =C2=A0 scsi: ufs: core: Report the current clock frequency to devfreq
>=20
> =C2=A0drivers/devfreq/devfreq.c |=C2=A0 5 ++---
> =C2=A0drivers/ufs/core/ufshcd.c | 37 +++++++++++++++++++++++++++++++-----=
-
> =C2=A0include/linux/devfreq.h=C2=A0=C2=A0 |=C2=A0 7 +++++--
> =C2=A03 files changed, 38 insertions(+), 11 deletions(-)
>=20
>=20
> base-commit: e30626823a406725ce29bc75cb8ec467d3e1e326

