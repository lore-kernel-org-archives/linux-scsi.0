From: Kurt Garloff <garloff@suse.de>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Sun, 25 Jan 2004 01:31:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040125003129.GG28435@tpkurt.garloff.de>
References: <OF317B32D5.C8C681CB-ONC1256E19.005066CF-C1256E19.00538DEF@de.ibm.com> <20040112151230.GB5844@devserv.devel.redhat.com> <20040112194829.A7078@infradead.org> <1073937102.3114.300.camel@compaq.xsintricity.com> <Pine.LNX.4.58L.0401131843390.6737@logos.cnet> <1074345000.13198.25.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kra4tWuoVJHqwr45"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1074345000.13198.25.camel@compaq.xsintricity.com>
To: Doug Ledford <dledford@redhat.com>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Christoph Hellwig <hch@infradead.org>, Arjan Van de Ven <arjanv@redhat.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Jens Axboe <axboe@suse.de>, Peter Yao <peter@exavio.com.cn>, linux-kernel@vger.kernel.org, linux-scsi mailing list <linux-scsi@vger.kernel.org>, ihno@suse.de
List-Id: linux-scsi@vger.kernel.org


--Kra4tWuoVJHqwr45
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Doug,

On Sat, Jan 17, 2004 at 08:10:00AM -0500, Doug Ledford wrote:
> On Tue, 2004-01-13 at 15:55, Marcelo Tosatti wrote:
> > Merging "straight" _bugfixes_=20
>=20
> OK, I've got some new bk trees established on linux-scsi.bkbits.net.=20
> There is a 2.4-for-marcelo, which is where I will stick stuff I think is
> ready to go to you.  There is a 2.4-drivers.  Then there is a
> 2.4-everything.  The everything tree will be a place to put any and all
> patches that aren't just experimental patches.  So, just about any Red
> Hat SCSI patch is fair game.  Same for the mods SuSE has made.

Not everything we have is straight bugfixes :-\

> Pushing
> changes from here to 2.4-for-marcelo on a case by case basis is more or
> less my plan.  Right now, these trees are all just perfect clones of
> Marcelo's tree.  As I make changes and commit things, I'll update the
> lists with the new stuff.

Find the collection of changes we've done to SCSI scanning at
http://www.suse.de/~garloff/linux/scsi-scan/scsi-scanning.html
(currently syncing, might take an hour before the patches are visible)

It contains=20
* various blacklist updates
* various new parameters that influence the way SCSI scanning is done
  (one of the areas that generated amazingly many support calls and
   HW vendor requests)
* a refactoring of the code to make it resemble 2.6
* support for REPORT_LUNS (backport from 2.6 as well)

The amount of parameters is larger than in 2.6, you can also instruct
the code not to use REPORT_LUNS at all, you can blacklist devices
for REPORT_LUNS (BLIST_NOREPLUN) and you can tell the code to try
REPORT_LUNS on SCSI-2 devices (if the host adapter reports to support
more than 8 LUNs, so you avoid the usual USB screwups).

I'd certainly appreciate if this is merged into more 2.4 trees and I'll
try to find the time to push some improvements into 2.6. If anybody is
faster, I would not mind either ;-)

Destructive criticism appreciated ;-)

Doug, would you mind to post the BUSY and QUEUE_FULL fixes for review?

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--Kra4tWuoVJHqwr45
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD4DBQFAEw5hxmLh6hyYd04RAnPZAJjLR6kIbiUmGIa0rz3VN9tJnblmAJ9dbdea
RRPFNZP+SvIuP2dL6DZCbA==
=QrHb
-----END PGP SIGNATURE-----

--Kra4tWuoVJHqwr45--
