Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545FD4D90C0
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784721533; cv=none; b=alM2lBUVWLToMTT6k+W0FfeiG5EgeS+qcxjDudV3829AqLOdupaG0zW3GfsLrw0KaAony+1Tqfro7+B4tGnhhCrPwO8rNLR7PeUINPyuB52Wh9y1AUdVAYbaGk/P5ahwJCzynvRixFonISZAWZsx/3StEmfHwYdcILjrIH/5Z28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784721533; c=relaxed/simple;
	bh=BWYUY9Key7HPP5r4svsN8btVziZiGlu4ExBNuBFrNEI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=juYUHsnuRJXz+uwLMx1zw5blAlliptKgi11NFpKpoKvtwRtfk2d6yZoLo06tpK61JkHwWjv4i4JZrnDlGuMyQe0CE2OBEjIJQ13G3TILbFSFW+ESItcqjOqK9gYyu1l/x/W/aDf7T03F8trGTDLkTnWSbW9/IKo//Xf0mL1r1uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=Q79qWP9Z; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Q79qWP9Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1784721529;
	bh=BWYUY9Key7HPP5r4svsN8btVziZiGlu4ExBNuBFrNEI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=Q79qWP9ZaNhXa9aXOOpeu3HFkNd4iLms/AND7r7NF2dwNtMA+FCX2rjx+fw/DEPWR
	 woczLvV60aGNgPe0H51erKslbJXjAmUY4ifP5gf4do3bp/ZrYRPku3T8D9JBaqC4v7
	 nxBYdA17RVfW1blucw5CdTD/fKDIsHCHuB8OY+mA=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8c71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 314651C02BE;
	Wed, 22 Jul 2026 07:58:49 -0400 (EDT)
Message-ID: <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
Subject: How to fix problems with the sashiko review model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>, Roman
 Gushchin	 <roman.gushchin@linux.dev>
Cc: linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Date: Wed, 22 Jul 2026 07:58:48 -0400
In-Reply-To: <20260722042744.5C1B01F000E9@smtp.kernel.org>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
	 <20260722042744.5C1B01F000E9@smtp.kernel.org>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

There doesn't seem to be a Sashiko list, so I added ksummit as the most
likely one to catch attention.  We got this review in SCSI on this
thread:

https://lore.kernel.org/linux-scsi/20260722041257.1557-1-pengpeng@iscas.ac.=
cn/

But this part of the review

On Wed, 2026-07-22 at 04:27 +0000, sashiko-bot@kernel.org wrote:
[...]
> > +
> > +	reply_len =3D mpi_reply->MsgLength * 4;
> > +	if (reply_len < event_offset || reply_len > ioc->reply_sz)
> > +		return false;
> > +
> > +	event_data_len =3D le16_to_cpu(mpi_reply->EventDataLength) *
> > 4;
>=20
> [Severity: High]
> Is there a Time-of-Check to Time-of-Use window here since mpi_reply
> is read directly from shared DMA memory?
>=20
> The validation function reads bounds from mpi_reply, but after
> validation passes, mpt3sas_scsih_event_callback() re-reads fields
> like EventDataLength and NumEntries directly from the same DMA-backed
> memory.
>=20
> Could a malicious device mutate these fields in the window between
> validation and use to bypass the checks introduced by this patch?

Is wrong.  Hardware may never be presumed to be malicious (well, except
if it's virtual hardware provided by an untrusted host to a
confidential guest, but that's a very small list of drivers or it's a
USB or thunderbolt device designed to attack or exfiltrate data from an
unattended system).  It may be buggy, but we never presume bugs until
someone finds a device exhibiting the bug in the field (so we don't
proactively fix them).

The bigger part of this is that I was looking into how to fix this
(which might interest a broader swathe of developers than just SCSI).=20
I think the fault is in the review prompts:

https://github.com/masoncl/review-prompts

And what I need to do is to add an additional drivers.md file to
kernel/subsystems explaining this?  If that's right I can send a pull
request, but I thought I'd check here because the audience is much
bigger than if it were to get discussed in the github PR.

Regards,

James
