From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 18:33:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615163324.GB27597@devserv.devel.redhat.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com> <20040615154313.GA25397@devserv.devel.redhat.com> <40CF1A5D.30908@adaptec.com> <20040615155716.GA14017@infradead.org> <40CF2381.30707@adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:16324 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265764AbUFOQdo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 12:33:44 -0400
Content-Disposition: inline
In-Reply-To: <40CF2381.30707@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


On Tue, Jun 15, 2004 at 12:27:45PM -0400, Luben Tuikov wrote:
> Christoph Hellwig wrote:
> >Well, the question is always what is so special about your driver that
> >it doesn't benefit from beeing in a common library.  I've pulled more crap
> >out of individual drivers than I'd ever want to imagine, and because of
> >that I'm pretty much allergic against giving driver writers more control
> >then nessecary.
> 
> We are *not* talking about programming here, recognizing patterns
> and modularizing them.
> 
> We are talking about _recovery_.  And this method is OPTIONAL.

so do explain why the recovery method requires the midlayer to hand over
timer handling to the driver ? Why does it matter for *recovery* who started
the timer ???

Yes I can see the use for the driver to tell the timer handler code "eh please
give me some more time, I'm configuring stuff for a bit". But that doesn't
explain why it shouldn't be the midlayer that keeps in charge of timer
handling and solicits the advice from the driver like this..

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAzyTUxULwo51rQBIRAoXRAJ95AJBr/he4mJNDE24Jug8JTD5ijACfaZr2
PRaMRUmAccVQk0yk7FgXduc=
=/MOO
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
