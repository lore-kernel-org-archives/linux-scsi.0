From: AJ Lewis <alewis@redhat.com>
Subject: Re: [ANNOUNCE] iSCSI Initiator Core Stack v1.6.1.20
Date: Mon, 28 Feb 2005 09:16:27 -0600 (CST)
Message-ID: <20050228.091627.41826533.alewis@redhat.com>
References: <1109187935.15154.164.camel@haakon>
	<x05mzttr8aw.fsf@null.msp.redhat.com>
	<42221568.6080508@netapp.com>
Mime-Version: 1.0
Content-Type: Multipart/Signed; protocol="application/pgp-signature";
 micalg=pgp-sha1;
 boundary="--Security_Multipart(Mon_Feb_28_09_16_27_2005_841)--"
Content-Transfer-Encoding: 7bit
Received: from mx1.redhat.com ([66.187.233.31]:40682 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261639AbVB1PQd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 10:16:33 -0500
In-Reply-To: <42221568.6080508@netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davidw@netapp.com
Cc: linux-scsi@vger.kernel.org

----Security_Multipart(Mon_Feb_28_09_16_27_2005_841)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Sun, 27 Feb 2005 13:46:00 -0500, Dave Wysochanski <davidw@netapp.com> wrote:
> AJ Lewis wrote:
> 
> > "Nicholas A. Bellinger" <nick@pyxtechnologies.com> writes:
> >
> > > The following is the first public release of the PyX Technologies iSCSI
> > > Initiator Core Stack v1.6.1.20 for Linux 2.6.11-rc4.  This is a full
> > > featured iSCSI Initiator stack that is capable of mulitplexing coast to
> > > coast across multiple independant backbone providers using various
> > > network transports _TODAY_.  This is the first release of the core 
> > stack
> > > and assoicated userspace tools, the accompanying authentication daemon
> > > will be released shortly.
> >
> > Very cool - glad you're releasing this. I've gotten this setup and
> > running, but I can't seem to talk to my iscsi target.  The initiator
> > detects it, but it can't recognize the type:
> >
> > iCHANNEL[0] - No defined iSCSI Authentication Methods, skipping 
> > SecurityNegotiation phase.
> > iCHANNEL[0] - iSCSI login successful on CID: 0 to 192.168.44.19:3260,2
> > iCHANNEL[0] - Incremented iSCSI connection count to 1 to node: 
> > iqn.1992-08.com.netapp:sn.33615311
> > iCHANNEL[0] - Established iSCSI session to node: 
> > iqn.1992-08.com.netapp:sn.33615311
> > iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 1.
> > scsi: unknown device type 31
> >   Vendor: NETAPP    Model: LUN               Rev: 0.2
> >   Type:   Unknown                            ANSI SCSI revision: 04
> >
> > Any ideas on why this wouldn't be working?  Is there a configuration
> > step I'm missing?
> >
> Make sure the initiator name is in the igroup on the filer for
> any luns that you want mapped to the intiator.
> 
> I think what you're seeing is not a real LUN, but the config LUN
> or something like that, probably the result of the initiator name
> not being in the igroup (see "igroup add" command on the filer).

Umm...I doubt it.  The initiator name specified in
'/etc/sysconfig/initiator' is the same as the one specified in
/etc/initiatorname.iscsi (the one for the linux-iscsi initiator, which
works).  And this is the same setup I've had for several months now
with the netapp and the linux-iscsi initiator with now problems.  And
I actually pulled the initiator name from the igroup just to be
certain.

Any other ideas?

Regards,
--
AJ Lewis                                   Voice:  612-638-0500
Red Hat Inc.                               E-Mail: alewis@redhat.com
720 Washington Ave. SE, Suite 200
Minneapolis, MN 55414
   
Current GPG fingerprint = D9F8 EDCE 4242 855F A03D  9B63 F50C 54A8 578C 8715
Grab the key at: http://people.redhat.com/alewis/gpg.html or one of the
many keyservers out there...


----Security_Multipart(Mon_Feb_28_09_16_27_2005_841)--
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCIzXO9QxUqFeMhxURAjC5AJ4tymzXtSkeA37eqGBbKjOM/n44IQCfRJn3
7JuuwA5oYCiD61XFhozs50o=
=eZzX
-----END PGP SIGNATURE-----

----Security_Multipart(Mon_Feb_28_09_16_27_2005_841)----
