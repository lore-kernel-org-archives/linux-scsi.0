From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 01/16] hpsa: do readl after writel in main i/o path to ensure commands don't get lost.
Date: Wed, 04 May 2011 13:54:22 -0400
Message-ID: <11821.1304531662@localhost>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com> <20110503195849.5478.13229.stgit@beardog.cce.hp.com> <4DC13566.5070203@redhat.com> <20110504125212.GC5997@beardog.cce.hp.com> <10639.1304530101@localhost>
            <20110504173735.GB22953@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304531662_7352P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: Your message of "Wed, 04 May 2011 11:37:35 MDT."
             <20110504173735.GB22953@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: scameron@beardog.cce.hp.com, Tomas Henzl <thenzl@redhat.com>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

--==_Exmh_1304531662_7352P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 May 2011 11:37:35 MDT, Matthew Wilcox said:
> > This probably needs a comment like
> > 	/* don't care - dummy read just to force write posting to chipset */
> > or similar.  I'm assuming it's just functioning as a barrier-type flush of some sort?
> 
> It's a PCI write flush.  It's not clear to me why it's needed here,
> though.  The write will eventually get to the device; why we need to
> make the CPU wait around for it to actually get there doesn't make sense.

Exactly why I think it needs a one-liner comment. :)



--==_Exmh_1304531662_7352P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwZLOcC3lWbTT17ARAoxZAKCC6uTzzQpErmifrHpBnMEda5m7+gCgsmSa
hihEfg9c6H21ti8tVTcsssQ=
=akVN
-----END PGP SIGNATURE-----

--==_Exmh_1304531662_7352P--
