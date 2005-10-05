From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: Removing BROKEN scsi drivers
Date: Wed, 5 Oct 2005 16:35:55 +0200
Message-ID: <200510051636.03779@bilbo.math.uni-mannheim.de>
References: <200510051314.33411.ak@suse.de> <1128519034.5063.10.camel@laptop-lcs.localdomain> <1128520989.4854.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1860117.0JuY2eObkU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:42924 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S932632AbVJEOcC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2005 10:32:02 -0400
In-Reply-To: <1128520989.4854.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, linux-m68k@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>

--nextPart1860117.0JuY2eObkU
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

James Bottomley wrote:
>On Wed, 2005-10-05 at 15:30 +0200, Kars de Jong wrote:
>> I have at least the 53c7xx driver and the MVME16X driver working, the
>> Amiga and BVME stuff is untested (but does compile).
>>
>> I patched the 53c7xx core to get it to work again, but the patch is ugly
>> and uses some mid level SCSI driver internals, which it shouldn't. It's
>> currently only present in the m68k CVS repository.
>>
>> Are you sure it's that easy to use the new 53c700 core? These boards all
>> have 53c710 chips, and are quite some changes in the 53c7xx driver
>> compared to the 53c8xx driver it originated from.
>
>The 53c700 driver is a bit misnamed, it also has a 710 mode which is set
>by a flag.  It's actually in common use driving three different
>chipsets:
>
>53c700: parisc 715 machines
>53c700-66: Voyager systems
>53c710: Voyager and parisc 712 systems

And PC. I've two of them running in EISA slots of an old Compaq 486 using=20
sim710 driver.

Richard, remember this machine?

Eike

--nextPart1860117.0JuY2eObkU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDQ+TTXKSJPmm5/E4RAt5uAJ0XldjNJFb3XVNgEEW22PaLamsXbgCbBv0i
PfUoMkkoXWuirG5WxavhWlw=
=1Uqy
-----END PGP SIGNATURE-----

--nextPart1860117.0JuY2eObkU--
