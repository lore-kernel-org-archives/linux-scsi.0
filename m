From: Shanker Balan <shanu@exocore.com>
Subject: Re: aic7xxx: SCSI Bus Reset
Date: Tue, 24 Dec 2002 17:39:56 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021224120956.GB667@exocore.com>
References: <20021224112158.GA667@exocore.com> <Pine.LNX.4.44.0212241230510.3657-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from godzilla.exocore.com ([202.141.128.95])
	(authenticated)
	by premium.exocore.com (8.11.6/8.11.6) with ESMTP id gBOCA1p04359
	for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2002 17:40:01 +0530
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0212241230510.3657-100000@uplift.swm.pp.se>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Hello:

Mikael Abrahamsson wrote,
> I get this too. Different drives from time to time, I get the same
> errors either with a AH3950U2 (on a VP6 Abit motherboard) or a 7899
> based U160 onboard controller (on my new Tyan 2688 motherboard).

I was planning to move from the Gigabyte to a Tyan Tiger MPX S2466.

> I run in LVD mode with a cable which is less than a meter long and
> with a LVD-SCA 6 drive backplane with built in termination.
 
Hmm.. I never thought about the termination part as I am using a 4U
SuperMicro rack mount cabinet with hot swappable drive bays.

http://www.supermicro.com/PRODUCT/Chassis/SC742-2.htm

Perhaps I should take my drives out and hook them up directly to the
SCSI cable!
 
> My stop usually lasts for 30 seconds and then it clears and continues.

My box is the NFS server for a 10 node cluster. A small disruption in
service usually brings everything to a halt. :(

> I use Redhat 7.3 as well with the redhat supplied kernels (I've tried
> different ones).

Sigh! Everyone has the same problem :(

-- Shanu
http://shankerbalan.com/


-- 
It will be advantageous to cross the great stream ... the Dragon is on
the wing in the Sky ... the Great Man rouses himself to his Work.
