From: Clay Haapala <chaapala@cisco.com>
Subject: Re: [PATCH 2.6.1 -- take two] Add CRC32C chksums to crypto and lib
 routines
Date: Wed, 04 Feb 2004 10:14:13 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yquj4qu6g6ui.fsf@chaapala-lnx2.cisco.com>
References: <yquj4qu8je1m.fsf@chaapala-lnx2.cisco.com>
	<Xine.LNX.4.44.0402031213120.939-100000@thoron.boston.redhat.com>
	<20040203175006.GA19751@chaapala-lnx2.cisco.com>
	<20040203185111.GA31138@waste.org>
	<yqujad40j7rn.fsf@chaapala-lnx2.cisco.com>
	<20040203172508.B26222@lists.us.dell.com>
	<20040203233737.GD31138@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:30118 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S263466AbUBDQOT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2004 11:14:19 -0500
In-Reply-To: <20040203233737.GD31138@waste.org> (Matt Mackall's message of
 "Tue, 3 Feb 2004 17:37:37 -0600")
List-Id: linux-scsi@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, James Morris <jmorris@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>

On Tue, 3 Feb 2004, Matt Mackall said:
> On Tue, Feb 03, 2004 at 05:25:08PM -0600, Matt Domsch wrote:
>> > >> +MODULE_LICENSE("GPL and additional rights");
>> > > 
>> > > "additional rights?"
>> > > 
>> > Take it up with Matt_Domsch@dell.com -- it's his code that I
>> > cribbed, so that's the license line I used.
>> 
>> The crc32 code came from linux@horizon.com with the following
>> copyright abandonment disclaimer, which is still in lib/crc32.c:
>> 
>> /*
>>  * This code is in the public domain; copyright abandoned.
>>  * Liability for non-performance of this code is limited to the
>>  * amount you paid for it.  Since it is distributed for free, your
>>  * refund will be very very small.  If it breaks, you get to keep
>>  * both pieces.  */
>> 
>> Thus GPL plus additional rights is appropriate.
> 
> Ok, makes sense for CRC32 stuff which can be easily lifted from the
> kernel or 50 other places, but not for stuff that's depends on
> cryptoapi.

Matt is correct about crypto/crc32c.c -- that should be simply "GPL".

As for the derived-from-public-domain-CRC32 stuff, should one even
claim "GPL" on it?  That would be, in effect, licensing public-domain
code and placing restrictions on it, something only a copyright holder
should be able to do, and not the intent of the author, in this case.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
 The marketing flacks who thought the Super Bowl half-time show was the
 best way to reach 25-49-year-old males obviously surf a little too
 much Internet pr0n and read a bit much into the spam they receive.
