From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH 2.6.1 -- take two] Add CRC32C chksums to crypto and lib routines
Date: Tue, 3 Feb 2004 17:25:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040203172508.B26222@lists.us.dell.com>
References: <yquj4qu8je1m.fsf@chaapala-lnx2.cisco.com> <Xine.LNX.4.44.0402031213120.939-100000@thoron.boston.redhat.com> <20040203175006.GA19751@chaapala-lnx2.cisco.com> <20040203185111.GA31138@waste.org> <yqujad40j7rn.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:1425 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S265964AbUBCXZ2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Feb 2004 18:25:28 -0500
Content-Disposition: inline
In-Reply-To: <yqujad40j7rn.fsf@chaapala-lnx2.cisco.com>; from chaapala@cisco.com on Tue, Feb 03, 2004 at 01:13:48PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: Matt Mackall <mpm@selenic.com>, James Morris <jmorris@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>

> >> +MODULE_LICENSE("GPL and additional rights");
> > 
> > "additional rights?"
> > 
> Take it up with Matt_Domsch@dell.com -- it's his code that I
> cribbed, so that's the license line I used.

The crc32 code came from linux@horizon.com with the following
copyright abandonment disclaimer, which is still in lib/crc32.c:

/*
 * This code is in the public domain; copyright abandoned.
 * Liability for non-performance of this code is limited to the amount
 * you paid for it.  Since it is distributed for free, your refund will
 * be very very small.  If it breaks, you get to keep both pieces.
 */

Thus GPL plus additional rights is appropriate.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
