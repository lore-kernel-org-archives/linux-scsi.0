From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [patch] aic79xx hostraid support
Date: Mon, 23 Aug 2004 16:05:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040823140548.GA1464@devserv.devel.redhat.com>
References: <20040821133214.GA28890@devserv.devel.redhat.com> <20040821142245.GA9151@devserv.devel.redhat.com> <4129F4E2.10103@adaptec.com> <20040823135143.GE17268@devserv.devel.redhat.com> <4129F8F6.8070902@adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45515 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264443AbUHWOFw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 10:05:52 -0400
Content-Disposition: inline
In-Reply-To: <4129F8F6.8070902@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 23, 2004 at 10:02:30AM -0400, Luben Tuikov wrote:
> Arjan van de Ven wrote:
> >On Mon, Aug 23, 2004 at 09:45:06AM -0400, Luben Tuikov wrote:
> >
> >>Those patches are from the more recent versions of the AIC drivers,
> >>from Justin's website, verbatim but somehow reworked to compile for older
> >>versions of the drivers.
> >>
> >>Please don't claim that you wrote it or as your own work.
> >
> >
> >I do not and never have claimed it as my own work.
> >
> >Do you agree that this patch is a useful addition for now, until you start
> >sending similar small improvements to linux-scsi for the drivers?
> 
> Yes, sure, if it works for people _and_ they realize that it is:
> a) temporary,
> b) taken from the later version of the driver on Justin's website, and
> c) it will be scrapped completely since the later versions which I'll
>   be sending *contain and absolve* this or any other similar patches.

sure since I assume your later drop will also just support the hardware I
dont see a user regression in this... I mean, when you replace the code the
hardware keeps working, end user remains happy. Nobody is married to this
patch; I just care about getting this new hardware working without having to
go to a whopping gigantic patch immediately.

So it seems we are basically in agreement ;)

Thanks.

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBKfm8xULwo51rQBIRAsbaAKCF081A6e5/MVBFDlxBwcASF8hU1gCfXM+s
ckkzuxr598krVoOD/6OV5V0=
=o1sm
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
