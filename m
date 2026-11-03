Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.241.56.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715944;
	b=lhTgvGz6H2Dixk4V7lv/PGNPMIY8gmi+Tc2NHDHwXM9QURhmWTtqCsU0ah7PA5t7ie00
	 cyvKmN2vC3PfXhQjLkMNSuYzXsuohTnM+QwONY7UXzGo+aXdArIgq/vy4a5JXcG4sr7Ro
	 BDcaVdG1rvoRMwGXNT1oT12KhtVZitxxtVSHdltnTJhAssfIQChvoQ/4ljTjXEOP02mRE
	 pCBBiGoOBqfdeqrta8vbXEom/ztYg4w4Y5L64HLKMeIkAp8xQC8Rc/+tb51ibx2sw2UOH
	 S2UDpwKU5mBvlhaw1UTOD+rLgtQYAmmx2dish/PxFmcfouinxQHTWMeI49Xon1rF4gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715944;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-MBO-RS-ID:X-MBO-RS-META;
	bh=49zbKkD+qQSXnnoiQB3Y6/fM4CNsO4eo9Y7QcQh8muM=;
	b=Gi6xe3jsUZa+vUODNEYagV9CvEKX2oyIqWNSDgsTQB5Rq0Sg0gBnTHE6WmHQgOPBc4Dr
	 J6aYt70m8qYt8yT6p6D9uM0JiHFFwJypKY1dW3IfB3uc9p8ACt3EIXKH9JytEAWl7WYn5
	 O0nZS1XDVQMxR999VIiytXD851w31AMHgZAu8yoOT8HUI9RIyjegbfsX6yGyt5GlhOwy/
	 dxwmRZ1mDxzLycnVnmyKaZ3YS6sV4EDUZ/t2fFqFZ8W0sjCQZlgEZBzp1wLIwyMewBN55
	 87fLnf7UUVnx6deqo1S9KOSBz8+UL2B9ZWk5aJcwIV7ZaEWiRiYGNZsss92OQ9S0QdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mailbox.org;
	spf=pass smtp.mailfrom=mailbox.org;
	dkim=pass header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=hwr2Tx3C;
	arc=none smtp.remote-ip=80.241.56.171
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFE8606A327;
	Tue,  3 Nov 2026 14:25:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EFE8606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=hwr2Tx3C
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4jJrTH3vWXzMlHW;
	Tue, 03 Nov 2026 15:25:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793715939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=49zbKkD+qQSXnnoiQB3Y6/fM4CNsO4eo9Y7QcQh8muM=;
	b=hwr2Tx3CP0tgm+YkZfDPHHl8QVmDobiGZGr9P2s+mOMWxOMdAw7DIAs6E0kno8Wq3H0By6
	VEORArh+EJxTI79POf2bLgdItv5GKoj/btycCTOu9yuATQ1CepzILqfR3nBOiuwm72EGBR
	tgzoR0iCpfYSkEYIALqeaYQctWjJu47jGJErhvObLDDONJ2fJjxQ40U+b2kWwEASywR6pW
	yxIkMHlsYxCjhi2SbqpSvEW/TemrkH5ffuL03/TIKgrgfIS7ehOgXVM3HlkJ5NxiRaYkFQ
	tIER+CjaUDiupGo1MoVRHXB2cRDLDLPSgrf/bgJSd++3GD5HFZL++l89SPIH3w==
Message-ID: <2deda25727af9db748f86f2a3d1f61047c903f3a.camel@mailbox.org>
Subject: Re: [PATCH] scsi: libsas: Fix interval notation
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: John Garry <john.garry@linux.dev>, John Garry <john.g.garry@oracle.com>,
  Jason Yan <yanaijie@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan	 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Tue, 03 Nov 2026 15:25:37 +0100
In-Reply-To: <9fd990b5-b4fd-423a-bd80-2bb630fc5de5@linux.dev>
References: <20260916124403.315227-2-manuelebnerli@mailbox.org>
	 <9fd990b5-b4fd-423a-bd80-2bb630fc5de5@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MBO-RS-ID: b5cfb7b84978453e990
X-MBO-RS-META: g3htgsum3szq44kzqx1kc444gzhqjtb9

On Wed, 2026-09-16 at 14:40 +0100, John Garry wrote:
> On 9/16/26 13:44, Manuel Ebner wrote:
> > Remove needless ']' from interval boundary.
> >=20
>=20
> This documentation is wrong for this structure description (not shown) -=
=20
> it should be for asd_sas_phy, not sas_phy
>=20
> Same for sas_port -> asd_sas_port

Does replacing all sas_phy -> asd_sas_phy and sas_port -> asd_sas_port
fix this? Then I'll send a patch.

Thanks
 Manuel


>=20
> > Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> > ---
> > =C2=A0 Documentation/scsi/libsas.rst | 2 +-
> > =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.=
rst
> > index 305a253d5..9ebf2bf28 100644
> > --- a/Documentation/scsi/libsas.rst
> > +++ b/Documentation/scsi/libsas.rst
> > @@ -75,7 +75,7 @@ enabled
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - must be set (0/1)
> > =C2=A0=20
> > =C2=A0 id
> > -=C2=A0=C2=A0=C2=A0 - must be set [0,MAX_PHYS)]
> > +=C2=A0=C2=A0=C2=A0 - must be set [0,MAX_PHYS)
>=20
> this looks ok, even though it is so trivial
>=20
> > =C2=A0=20
> > =C2=A0 class, proto, type, role, oob_mode, linkrate
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - must be set
