Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A830E3B14DB;
	Sun,  2 Aug 2026 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785689937; cv=none; b=Xu+YNmwt4oZzkCOFM4KtirdQ5XHx/1mTufd1sHcAaYEl2A1NczlIy/zGCf+o7i9WMi46NTwWvbj0Aht8gf2wiNkYgJ1qW09UpRbRTIAfHtast381qTS+2I8NNZulCr0yCUKsoyLyoBHcGAAGxKW7VqmKzSl1Qh3nirzTb6kskMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785689937; c=relaxed/simple;
	bh=p+bKXZQXp4wzdrUc4eMxceYokqimc/aVZrn4wDlWl6A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tN8NqsCAeQvvTx9I1yMTBR8zR5noKsnsq/NIStIRjgCQgOzXvjAcpD55fIubHY2GAe9WRYNfxwkFkAjKTGrHM8r9VJu6IlCGCSBvgqfjEQslvPSiHCaDk+dlBr8IeWLSRGX84SMwnWfz2UMOw9BDgjuF4SH+Q3PjL8DH1LmZNWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=qnK0z5s9; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="qnK0z5s9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1785689934;
	bh=p+bKXZQXp4wzdrUc4eMxceYokqimc/aVZrn4wDlWl6A=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=qnK0z5s9nRvXFok4XCShFSBdatW+hX9EaT09mvCMaCwpfu49h5mr0yCtE3nzoEis7
	 TFpa1Dnr5n5uU/uwiuwFRRMixbsQN/nhoWrQUmkO8Iv6cEAljMw2QQICJZXwaK0CI0
	 8v86XVmOpD62DSVEwCLWW8MknBBnJr4x3i8s/sOs=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 824F51C019A;
	Sun, 02 Aug 2026 12:58:54 -0400 (EDT)
Message-ID: <10e4d0edcdb0d9b54dbe4ed99485681a3ab7f832.camel@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 7.2-rc5+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi
	 <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 02 Aug 2026 12:58:53 -0400
In-Reply-To: <CAHk-=wj-HxDeuQ0LLf8qmzZ9zJTq2o6Q3LOtcNhqR_pS=LUFAg@mail.gmail.com>
References: 
	<62fc8f5dd0e1e9ac6d512e84173d33e4676adc35.camel@HansenPartnership.com>
	 <CAHk-=wj-HxDeuQ0LLf8qmzZ9zJTq2o6Q3LOtcNhqR_pS=LUFAg@mail.gmail.com>
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

On Sun, 2026-08-02 at 09:33 -0700, Linus Torvalds wrote:
> On Sun, 2 Aug 2026 at 05:51, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >=20
> > Sorry for the last minute pull request.=C2=A0 This time I managed to
> > spill soup in my laptop on a business trip and fried the
> > motherboard, so I've only just got back home to a desktop.
>=20
> That's the oddest version of "my dog ate my homework" I've ever
> heard.

You want the sob story about me having to do a business trip for a week
with no laptop ... ?  The good news is I rescued the NVME device and
now have it installed in a refurbished XPS-13 so I'm back to normal.

Regards,

James
