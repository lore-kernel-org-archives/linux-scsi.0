From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xxdrivers
Date: Mon, 21 Jun 2004 18:12:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621161227.GD30236@devserv.devel.redhat.com>
References: <20040621161441.20dfcee6.ak@suse.de> <40D6FEFC.9050005@adaptec.com> <1087832273.2702.14.camel@laptop.fenrus.com> <40D70837.8070303@adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52703 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264404AbUFUQMw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 12:12:52 -0400
Content-Disposition: inline
In-Reply-To: <40D70837.8070303@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org


--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 21, 2004 at 12:09:27PM -0400, Luben Tuikov wrote:
> Arjan van de Ven wrote:
> >On Mon, 2004-06-21 at 17:30, Luben Tuikov wrote:
> >
> >>Thank you Andi for the patches. aic7xxx drivers are due for update
> >>to use the new timeout infrastructure. I'll incorporate them in,
> >>and do some testing.
> >
> >
> >cool.
> >Would you please consider the update to be done in small incremental
> >changes/steps ? Eg each separate change/bugfix a separate patch ?
> >Would make life a lot easier for me (distro kernel guy) and for James to
> >be able to diagnose regressions a lot better by binary searching
> >changesets etc etc.
> 
> Yep, no problem.
> 
> Current kernel version of, say, aic79xxx is 1.3.11, and I have
> 2.0.12, they are 226 patches away. Each patch is a submission

I was actually hoping you would have started from the kernel.org driver not
the adaptec weird fork justin has been maintaining ;(


> into perforce.  I can extract each and every one of those 226
> and can post them somewhere on a website (hosting anyone? ;-) ),
> so that anyone can review them.

it's not just about review, it's also about merging it in parts so that you
don't need to binary chop through 226 patches if something fails, but only
through like 30 or so.
And then a week later the next 30 go in etc etc


--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFA1wjqxULwo51rQBIRAmEpAJ474g6P+XyJVt5dth7gwpUu5UEr/QCdHle2
jPca0CnhonHgZJ1DQZ+VTkA=
=FZJ4
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--
