From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 0/7] BKL mass-conversion to mutex
Date: Wed, 15 Sep 2010 19:38:30 +1000
Message-ID: <20100915193830.27722c3a.sfr@canb.auug.org.au>
References: <1284494022-7346-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Sep_2010_19_38_30_+1000_x_8PDlRlfK6atX+0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:42213 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab0IOJii (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 05:38:38 -0400
In-Reply-To: <1284494022-7346-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, David Woodhouse <David.Woodhouse@intel.com>, linux-mtd@lists.infradead.org, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org, Corey Minyard <minyard@acm.org>, openipmi-developer@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, Jens Axboe <axboe@kernel.dk>

--Signature=_Wed__15_Sep_2010_19_38_30_+1000_x_8PDlRlfK6atX+0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Tue, 14 Sep 2010 21:53:35 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> Stephen, please add
> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git trivial

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Wed__15_Sep_2010_19_38_30_+1000_x_8PDlRlfK6atX+0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkJQWAAoJEDMEi1NhKgbs/qcH/j6Q5d5mYGECz3JtxE/Em3WG
qO7Bk3/4JfuxCzIjBlDyoz4EpG0a2ghiIiPrCM3kGwg3awScEMf9lFKYJE0KSBsH
yxGilZjzBDG/XxMa58hGxb/ZmaIr/W5dwA7/XCUuF8lgGiqsvpoP94ncTf7mVQ1/
KPV+S767DPzqOQK1w8RVMBx+0slO2MEr0qEtyEsbjYFfrfSPCqpUruASJh53GiVi
SdPkjxstl8yG0YG6VGvGs2FHv1yeWbL5R4kFBARVIf+78ZDAzNYUhn2bgLZolL4Z
0PboNcLQDByMqUfOQ+Wh7rdjouKzQLeDNqq/2GAfzhWaZCJ16X7kYnBQuvTXwFI=
=52gd
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Sep_2010_19_38_30_+1000_x_8PDlRlfK6atX+0--
