From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] Try #3: Use SCSI read/write(16) with > 32-bit LBA drives
Date: Thu, 15 Nov 2012 07:50:05 +0200
Message-ID: <20121115055005.GC3585@arwen.pp.htv.fi>
References: <1352930602-3505-1-git-send-email-hernejj@gmail.com>
 <50A419B6.4070605@mvista.com>
 <CAJiM5SacceJLCrUMAR2Yqw4P7qX_q-BSbzRqthrc84TpHbWhZw@mail.gmail.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52794 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab2KOF5e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Nov 2012 00:57:34 -0500
Content-Disposition: inline
In-Reply-To: <CAJiM5SacceJLCrUMAR2Yqw4P7qX_q-BSbzRqthrc84TpHbWhZw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jason J. Herne" <hernejj@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, Sebastian Andrzej Siewior <sebastian@breakpoint.cc>, linux-usb@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, JBottomley@parallels.com, Alan Stern <stern@rowland.harvard.edu>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>

--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 14, 2012 at 08:06:20PM -0500, Jason J. Herne wrote:
> On Wed, Nov 14, 2012 at 5:22 PM, Sergei Shtylyov <sshtylyov@mvista.com> w=
rote:
> > Hello.
> >
> >
> > On 15-11-2012 2:03, Jason J. Herne wrote:
> >
> >> From: "Jason J. Herne" <hernejj@gmail.com>
> >
> >
> >   You have already posted Try #3. And preferrably, information about pa=
tch
> > version should be included with [PATCH] prefix like this [PATCH v4].
> >
> >
>=20
> Noted for future submissions.  Any idea how I get git send-email to
> generate the patch tag
> like that?
>=20
> Also, do I need to resubmit this patch because of this semi-faulty
> subject line? I would
> assume that to be unnecessary.

$ git send-email --subject-prefix=3D"PATCH v4" HEAD ^origin/master

if you want to generate the patch file before sending, pass
--subject-prefix to git format-patch instead.

--=20
balbi

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpIKMAAoJEIaOsuA1yqREFPgP/1YQaPku1e4iFur5V+2nlvIP
5B/A9r6zib5YZ+2EcNN6dkdZFcxBnC1mcG1l2Vw4ShGJhknhW4pf+Aa4LiTHSv2j
noEyUWL2yNWLtGtKbSSEhGwTXQNjvFSA0jbhpG+7kRDcjn5RtV8W3UYXccU/Mahu
UTfiPaeBUgajVcSXmdLO52GFFusr7KY4XR+A+d9Wt3mlOR4VXStOYcH8QZMcEIpR
8x9k0HfNsplvv2gdaCwjnzYzaxA2sI3la30nnZ23Beqkj4tKuZuRmwlZ168g/gbk
TY8zc2JgG+9Y6d8j/lkNsopHaa9G2FyDvcexsHIx/kMDdlxea8B7hkZc7hAnBAWT
OVV8XiPx5d1foDJrmY6QYO6Vm4MyXucmQiyniSyTPR2w5jQN9wO0jikJlNb9aIy2
lxIaKhTsViHdDDO3xkT7l+wU6o7xJBtwvqcoLH8vKzGaJxxvBQH7u0zWnUKHBvlN
h2xtJRtaW+EtryaLFd22XSLD4ckupcm7lGCsu+fFx1J0HOARxGSMIgvgHqPgo8XX
ecgFmLSlHEjd5q55Hf2mvaQ5Tlg2ULXuHgUl5s6QkaxP1cuKpeqwFA6LAGlHFSQw
d0p0DCLCn6Rsp/5tRAljS+sWD7KLIRPhrdxydKLp/mILUWuZ1HQLxncGLrawYGzV
VjnCRL/2K9yjQO9sqSdv
=xduj
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
