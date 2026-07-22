Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5203E282F01;
	Wed, 22 Jul 2026 12:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724178; cv=none; b=jm8YR+TDo/+W5/E+CA3klqE9+0ZmWCZDATp+RtgkMa1XN0CRgfLRtwkWp/kUFoT+ki4UIlL9+Z1aov/QZxOxz2Gp/hOz6d2YLJPFDyRcN7mokNyx/8h2zir3dqhqIvOPy7hVEdQMzBrz4r9zGXZ3tP6j9oWtEoCpySuhpobCLlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724178; c=relaxed/simple;
	bh=el10Bh8SZ/30LoF9AzTvO3XQJvujiOL+8AwnWkMK2fs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nP0F6fPWbieWWEF3Y7ND9J6B304Q6k84GElWUwDDnB8F1Ywmu+lGiwgvP4/zcOV5PpcUEj6ObxKsOVGQftdohYPInlE/SVyUguTFSVhrQr/tJERkikCNxde2cg07xjhkNZy5Fra23eP/OojBUeSiW61IDLwwxi0xDVSXwPdXVHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=oLBF29XK; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="oLBF29XK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1784724176;
	bh=el10Bh8SZ/30LoF9AzTvO3XQJvujiOL+8AwnWkMK2fs=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=oLBF29XK5dRRhjdxmKQeXMtHDhi1fR3FbVvhJkyik7HiuCna0TJWL31WkBlhn3jlC
	 idi8nClP4KAkHDJbHt9BNC/YhCk+w0cHiwV0kZCwcFEJJ+2qS8B5mXzhmLGxpSSRI6
	 7V6ZyrL7dxqsvDH2rjPNNFKsepbAMe1Np+HTI7/Y=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8c71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 2DB001C00F9;
	Wed, 22 Jul 2026 08:42:56 -0400 (EDT)
Message-ID: <560cc442f7ff3dc1958da472f6a6ff2b357e2da2.camel@HansenPartnership.com>
Subject: Re: How to fix problems with the sashiko review model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, linux-scsi@vger.kernel.org,
 ksummit@lists.linux.dev, 	workflows@vger.kernel.org
Date: Wed, 22 Jul 2026 08:42:55 -0400
In-Reply-To: <20260722121135.GB629472@killaraus.ideasonboard.com>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
	 <20260722042744.5C1B01F000E9@smtp.kernel.org>
	 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
	 <20260722121135.GB629472@killaraus.ideasonboard.com>
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

On Wed, 2026-07-22 at 15:11 +0300, Laurent Pinchart wrote:
> On Wed, Jul 22, 2026 at 07:58:48AM -0400, James Bottomley wrote:
> > There doesn't seem to be a Sashiko list, so I added ksummit as the
> > most likely one to catch attention.=C2=A0 We got this review in SCSI on
> > this thread:
>=20
> workflows@vger.kernel.org=C2=A0seems a good candidate for discussions
> about tooling. The mailing list was created to share workflows and
> tools between maintainers as far as I understand.

Happy to keep this list cc'd, but I note I'm not on it so I'm not sure
how many other maintainers would be and the object is to engage driver
maintainer feedback on the proposal.

Regards,

James
