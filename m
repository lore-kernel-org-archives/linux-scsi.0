From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 17:43:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615154313.GA25397@devserv.devel.redhat.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33703 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265698AbUFOPnd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:43:33 -0400
Content-Disposition: inline
In-Reply-To: <40CF1852.6030306@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 15, 2004 at 11:40:02AM -0400, Luben Tuikov wrote:
> >to me it somewhat sounds like the wrong approach.
> >I'm all for the LLDD to be able to influence the timeout value, but I
> >consider it a bad mistake to make every driver reinvent timeout
> >*handling*.
> 
> This has very little to do with the timeout _value_, and it has
> all to do with *recovery* which is a beast on its own as far as transport
> protocols are concerned, especially over non-native interconnects (iSCSI, 
> USB,
> RDMA). I believe I did mention this at the end of the text.
> (mea culpa it was kind of a long text) 

so I can see the point of a new level of error handling function pointer,
which gets called on timeout expiry and which can return if the mid layer
needs to go into eh thread or not, or if the timeout deserves an extension.



--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAzxkRxULwo51rQBIRAhs3AKCZewjjrNMTBiS7S2+f1H2DCZVvzACfYmDW
5kcTKKiS0eD/X5zH4MG21Nw=
=wEA2
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
