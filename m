From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Tape issues w 2.6.14-4
Date: Wed, 12 Apr 2006 18:06:32 -0400
Message-ID: <87f94c370604121506i4088faa9n57d2a67b2b389ea3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uproxy.gmail.com ([66.249.92.171]:42123 "EHLO uproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932338AbWDLWGd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Apr 2006 18:06:33 -0400
Received: by uproxy.gmail.com with SMTP id m2so949373uge
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2006 15:06:32 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I have an LTO-1 drive that I have been making backups on for about 3 years.

I was trying to read in some older tapes today and something funny is
going on. (2.6.14-4 vanilla kernel).

If a take a recently written tape and do a simple dd I get a nice
stream of non-repeating data.

If I take an older tape  I get the same data repeating over and over.

I tried 4 tapes, 2 of which were tar backups made on this machine and
are labeled 256KB blocks.  The other 2 are NTbackup backups made on
different hardware/OS.  I don't know what blocksize NTbackup uses.

At first I thought it was the data on the media, but now I'm not so
sure.  When I change the dd blocksize I change the amount of data
being repeated.

It appears the first block of data from a dd perspective is just
repeated forever.

ie.
dd bs=10k  gives 1 10k block repeated over and over
dd bs=32k  gives 1 32k block repeated over and over
dd bs=256k gives 1 256k block repeated over and over
dd bs=512k gives 1 512k block repeated over and over

OTOH only the first few kb of the above blocks look valid anyway.  The
rest of the repeating block appears to be full of nulls so I'm not
really getting more data by extending the block size.

Does anyone have any idea what is going on?

Could this be a kernel issue?  I hope so because I don't want to lose
all those old tapes.

Greg
--
Greg Freemyer
The Norcross Group
Forensics for the 21st Century


--
Greg Freemyer
The Norcross Group
Forensics for the 21st Century
