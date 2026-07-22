Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB7135F170
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 13:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727769; cv=none; b=EcEmm7mgf/d91FYVVoxqwbxnMmCW8+8722CBW94dMSWhT8dBHp/MgfWq/lUiuSt5y8EPLyMWK+9k0iuZzYSsghTFBZNXPXPhHe0bp9oUkJtdSc4PGMZ3KGARGWINyHw8MJdmv7ernliQDywka1MQwBiWJUdDmIHF1c4hUvluF+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727769; c=relaxed/simple;
	bh=Lw0RyAcCRYE/5louh2Yi19/J0psnBLQjmOpK/tEtvYk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bS2g5bpuGcqEAwCA2BjfpCA38fBgM2X/Zdk72XmRtq1h4Celt7ioAg0zBp5c18jxmtw4VtBS9+6t0sbd6GRAolFqNHNJwD6E28bge6MgIxMwioc4Xz4+wYgttH/mILHwvex9gYgbYtt3WjF5Qu2PxobZu8SsRXUX3IY5erdqckc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=WfcMOgEU; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="WfcMOgEU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1784727766;
	bh=Lw0RyAcCRYE/5louh2Yi19/J0psnBLQjmOpK/tEtvYk=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=WfcMOgEUgfZqCnSTEAEpxRprqVgMSpD+f6mvTfuJuJO7Jrld/Uh5+heJexCsjei3G
	 w3WGR2AWiUl2CXm+izQuiQCcGSAo4+WptMHJfUdWJppnZr3SS8fitefiByeThdYJ1L
	 gnBSiv/niQCiTDj0wl1EBg0YR6ZmnhJ3nPmQ2NGo=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8c71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id A20D51C00A6;
	Wed, 22 Jul 2026 09:42:46 -0400 (EDT)
Message-ID: <e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
Subject: Re: How to fix problems with the sashiko review model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, linux-scsi@vger.kernel.org,
 ksummit@lists.linux.dev
Date: Wed, 22 Jul 2026 09:42:46 -0400
In-Reply-To: <2026072224-moisture-gonad-409f@gregkh>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
	 <20260722042744.5C1B01F000E9@smtp.kernel.org>
	 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
	 <2026072224-moisture-gonad-409f@gregkh>
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

On Wed, 2026-07-22 at 15:08 +0200, Greg KH wrote:
> On Wed, Jul 22, 2026 at 07:58:48AM -0400, James Bottomley wrote:
> > There doesn't seem to be a Sashiko list, so I added ksummit as the
> > most likely one to catch attention.=C2=A0 We got this review in SCSI on
> > this thread:
> >=20
> > https://lore.kernel.org/linux-scsi/20260722041257.1557-1-pengpeng@iscas=
.ac.cn/
> >=20
> > But this part of the review
> >=20
> > On Wed, 2026-07-22 at 04:27 +0000, sashiko-bot@kernel.org=C2=A0wrote:
> > [...]
> > > > +
> > > > +	reply_len =3D mpi_reply->MsgLength * 4;
> > > > +	if (reply_len < event_offset || reply_len > ioc-
> > > > >reply_sz)
> > > > +		return false;
> > > > +
> > > > +	event_data_len =3D le16_to_cpu(mpi_reply-
> > > > >EventDataLength) *
> > > > 4;
> > >=20
> > > [Severity: High]
> > > Is there a Time-of-Check to Time-of-Use window here since
> > > mpi_reply is read directly from shared DMA memory?
> > >=20
> > > The validation function reads bounds from mpi_reply, but after
> > > validation passes, mpt3sas_scsih_event_callback() re-reads fields
> > > like EventDataLength and NumEntries directly from the same DMA-
> > > backed memory.
> > >=20
> > > Could a malicious device mutate these fields in the window
> > > between validation and use to bypass the checks introduced by
> > > this patch?
> >=20
> > Is wrong.=C2=A0 Hardware may never be presumed to be malicious (well,
> > except if it's virtual hardware provided by an untrusted host to a
> > confidential guest, but that's a very small list of drivers or it's
> > a USB or thunderbolt device designed to attack or exfiltrate data
> > from an unattended system).=C2=A0 It may be buggy, but we never presume
> > bugs until someone finds a device exhibiting the bug in the field
> > (so we don't proactively fix them).
> >=20
> > The bigger part of this is that I was looking into how to fix this
> > (which might interest a broader swathe of developers than just
> > SCSI). I think the fault is in the review prompts:
> >=20
> > https://github.com/masoncl/review-prompts
> >=20
> > And what I need to do is to add an additional drivers.md file to
> > kernel/subsystems explaining this?=C2=A0 If that's right I can send a
> > pull request, but I thought I'd check here because the audience is
> > much bigger than if it were to get discussed in the github PR.
>=20
> Please make this per-subsystem, as your description above doesn't
> hold for all types of devices or busses.=C2=A0 See this thread where I
> describe what we do for USB and asking for much the same type of
> description for the virtio drivers:
> =09
> https://lore.kernel.org/all/2026072036-outburst-rebel-c71b@gregkh/

Well, I noted that in my reply above.  The way I was thinking of
implementing it was to add a general instruction file for drivers which
would make hardware trusted for pretty much everything and then
instruct the AI to consult driver specific files for overrides to this
so we could add the additional threat checks to usb.md and virt.md

Regards,

James
