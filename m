From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: aic7xxx strange code
Date: Thu, 1 Jan 2004 11:08:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040101100809.GA1053@devserv.devel.redhat.com>
References: <1072885576.10877.6.camel@laptop.fenrus.com> <960352704.1072895786@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39122 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265364AbUAAKIT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jan 2004 05:08:19 -0500
Content-Disposition: inline
In-Reply-To: <960352704.1072895786@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 31, 2003 at 11:36:26AM -0700, Justin T. Gibbs wrote:
> > consistent memory ALWAYS comes from lower 4Gb regardless of the
> > pci_set_dma_mask() setting;
>=20
> This isn't true on some architectures in the 2.4 kernel.  Look at, for
> example, arch/ia64/hp/common/sba_iommu.c in the RedHat 2.4.18-e.31 kernel.
> This is why this particular hack was added.

Thank you for reporting this very serious bug in our kernel; we will fix it
as soon as possible.

> I'm more than happy to change the #ifdefs on the hack to exclude 2.6
> so long as all platforms the driver operates under behave as expected.
> If 2.4 is any guide, however, there may still be some bogus code lurking
> around that uses the "normal" dma mask incorrectly.

Those platforms break the API and should be fixed as opposed to hacks added
to every single driver in drivers/*

Greetings,
    Arjan van de Ven

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/8/GIxULwo51rQBIRAq0BAJ41KZaXoAcoXRrrqgICL2WdwAafAACeOeCs
WW0TPHUCCz3NlYJKe9s614A=
=cLwH
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
