Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE95B175A7B;
	Thu,  3 Sep 2026 21:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788471240; cv=pass; b=LylFYxNaNpvdMUt4PFjq0VU9mrK+GX3z54l8eJQWH+fGBWsu4CVav/asvcltND5iN6xt+anlffZ9XNfW/09Jo8tAgPeHHklHnaiDpz5vTrDWqG5upACk0PWKd+s8QVmevn7Crxmpkmerg07gSTndzbY1QmnzsyqV6Xb6SBSjqaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788471240; c=relaxed/simple;
	bh=Ba1g9Enw/pSe3C3idkub28I3EbLdqVQfhCWFTdvDvZs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y2JANl6H/JtbtcA3ldxbwoKq/82Jr5vha3oMpg5ZCMyram4jBUt91ozk4WYQydoJRqGWOEZFNyxxFNfrUgwo3MDHOT8GMca167b/l4KdnNkuvsiSv/W3LpHRdXP+sU3f1se6utrj3aLy7xaJxDhBX47IVl3jiyaDUFKciLtBh4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=kNqVLXvt; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Vla6+HXv; arc=pass smtp.client-ip=85.215.255.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="kNqVLXvt";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Vla6+HXv"
ARC-Seal: i=1; a=rsa-sha256; t=1788471224; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=BJtVQFabtLdT7rxKEurlJ9UuTDWEo3rNQHGZM1KK76kARWszuXNMyubRtDI2gRlgWl
    8uKxDdf5Zzg6Ebwm+wXzLM2yXi+3Fa8hP8j8uolWbAM719iFAluzuunIbvPwx/c20yMh
    px6oPwRYjkDsvn8E6gw+Jk4rRspBrcm5mYpSqhfeNJ6zhCw8X0WJ3GUSPuhuW0CHIG2r
    6zxr+DuI+pL4dWXA03tVMANU/n5xWvVRZkUd52oJMAgIMSg3IWGpTIw5icAJpcXjt/le
    S7HSwhdJWAUj0C3nOZ+A1RmU7selNd4y+O1yCJWYrdlKV1JdgndpuDVAQOufYPWVfCCn
    ivgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788471224;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Ba1g9Enw/pSe3C3idkub28I3EbLdqVQfhCWFTdvDvZs=;
    b=K+gTdEBgnrVPltb61O/EKE9MyEzmHIPuFqB5O2HsUhYrybnpQ6e/KEYiz0cQ9JZrFu
    deQxYARe1RMiq3H6ar16o8Kp3xyRMPSKVOfA9RCcBCwBWF9uOg8k6+pvD9+kIjaWNvN6
    iS0AOoZELDieRagbeev+vIxSzN9T4Tm3LSTjGUylWWC03mP56Ru9ubVoj4FxMjNEyyft
    2aaxp6+5EVFU1mHIlN4UcFx21oyR17zNxF3GvXw1bCDJovOq88nDhcMa4yCm1SjjQTUU
    1sTskU1JMFj6DBwcFh9Df3CKP6hoawEacUWz7sLK2iZvBaxlnHaE4SM5tMYpbsUwNmuh
    Px1A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788471224;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Ba1g9Enw/pSe3C3idkub28I3EbLdqVQfhCWFTdvDvZs=;
    b=kNqVLXvt2pXbRysADHBXkXPeRwdMUk4mYXGHF7lzqOK+KKhskIfABd7kB+8dBVogwa
    HSjGbKHBc4zlGebjuB14JMMk4eoKFJXHOpAQqIjqxehDKV61pU4LPaF9FSCg/4YCBWsn
    KkAwvyP6hWCyfWeDcXEMj7Bvrso3qbBydwRbRRr5APEbxP43lehzS4C2cQ2ZkhI8AmHa
    xXDNdLcl5NAmkhrK86akK5wYOchjKf1RneV9rHW7BCApbtf8+CsAD9nFk6AjB7ldnAnF
    I8y+gUdYWOCbBxVGV4u8WDOdxeWL7IAkyOzKQa1vV7YbIytfkrqY+p5TDMb5HftXAbyq
    lyFg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788471224;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Ba1g9Enw/pSe3C3idkub28I3EbLdqVQfhCWFTdvDvZs=;
    b=Vla6+HXv3bgmPIbVJCnswgALzZeJH3m4GGsuipsGlPmO2GfWPVOIkh+mxP3S9XYL9X
    hBiivxLJPOq9XRIj4ACQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaZpI+/vCOxdmmyL+9XI5wV29xH6dGGQb9FUYY="
Received: from p200300c5872968f7abfc5aba940d79be.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e1283LXhzqa
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 3 Sep 2026 23:33:43 +0200 (CEST)
Message-ID: <f1e59607ab2f5554993dacf21947024e41278058.camel@iokpp.de>
Subject: Re: [PATCH 3/3] scsi: ufs: core: Report the current clock frequency
 to devfreq
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, MyungJoo Ham
 <myungjoo.ham@samsung.com>,  Kyungmin Park <kyungmin.park@samsung.com>,
 Chanwoo Choi <cw00.choi@samsung.com>, "Martin K . Petersen"
 <mkp@kernel.org>, "James E . J . Bottomley"
 <James.Bottomley@hansenpartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>,  Bart Van Assche <bvanassche@acm.org>, Jie Zhan
 <zhanjie9@hisilicon.com>, Krzysztof Kozlowski <krzk@kernel.org>, 
 linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Bean Huo <beanhuo@micron.com>
Date: Thu, 03 Sep 2026 23:33:43 +0200
In-Reply-To: <CAE14pddCf1VhLVC_H-Nv30C4BzK_UO4Eknd27g72d1nAjdBdpA@mail.gmail.com>
References: <20260831130129.3979454-1-beanhuo@iokpp.de>
	 <20260831130129.3979454-4-beanhuo@iokpp.de>
	 <CAE14pddCf1VhLVC_H-Nv30C4BzK_UO4Eknd27g72d1nAjdBdpA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-01 at 09:33 +0800, Stanley Jhu wrote:
> On Mon, 31 Aug 2026 15:01:29 +0200, Bean Huo wrote:
> > +=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * target_freq stays 0 until something s=
cales the controller for the
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * first time. Report nothing rather tha=
n 0 so devfreq falls back to
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * the frequency it last set.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0 if (!cur_freq)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 return -EINVAL;
>=20
> If ufshcd_devfreq_get_cur_freq() returns -EINVAL here, devfreq falls back
> to devfreq->previous_freq. However, because UFS does not set
> devfreq_profile.initial_freq, previous_freq is also 0 at boot. On platfor=
ms
> with use_pm_opp=3Dtrue, the initial sysfs read or the first transition be=
fore
> scaling still ends up seeing 0 Hz.
>=20
> Would it be cleaner to initialize hba->clk_scaling.target_freq and
> devfreq_profile.initial_freq to the max frequency in ufshcd_devfreq_init(=
)?
> That way, cur_freq is valid from the start and we wouldn't need to handle
> the !cur_freq case here.
>=20
> Thanks,
> Stanley Jhu

yes, thanks, that is better. I will do it in v2.
digging deeper, the problem is a bit wider than the sysfs read. with use_pm=
_opp,
ufshcd_init_clocks() already puts the controller at the highest OPP, but no=
thing
records that, so target_freq stays 0. Then ufshcd_devfreq_get_dev_status()
reports 0 Hz, the ondemand governor asks for the maximum frequency, and
ufshcd_devfreq_target() sees 0 !=3D max and runs a full ufshcd_devfreq_scal=
e().
That holds up the queue for up to a second only to set the same OPP and the=
 same
gear again. This happens today, without my patch.

Patches 1 and 2 are not affected.

Kind regards,
Bean
