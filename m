From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Thu, 4 Sep 2008 18:00:18 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A7788413663D229@GVW0547EXC.americas.hpqcorp.net>
References: <48AD02B2.7020004@oracle.com>
	 <0F5B06BAB751E047AB5C87D1F77A778835116209D3@GVW0547EXC.americas.hpqcorp.net>
	 <20080821084333.c471b439.randy.dunlap@oracle.com>
	 <0F5B06BAB751E047AB5C87D1F77A7788351181004C@GVW0547EXC.americas.hpqcorp.net>
	 <20080821091514.8f56e2d5.randy.dunlap@oracle.com>
	 <0F5B06BAB751E047AB5C87D1F77A778835118100D6@GVW0547EXC.americas.hpqcorp.net>
	 <20080821172653.3e3e855c.randy.dunlap@oracle.com>
	 <0F5B06BAB751E047AB5C87D1F77A77883511810706@GVW0547EXC.americas.hpqcorp.net>
	 <1219420487.3339.22.camel@localhost.localdomain>
	 <48AEEE0A.1010900@oracle.com>
 <1219424538.3339.51.camel@localhost.localdomain>
 <0F5B06BAB751E047AB5C87D1F77A77883511810894@GVW0547EXC.americas.hpqcorp.net>
 <48C013D9.7060309@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:3616 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYIDSBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 14:01:04 -0400
In-Reply-To: <48C013D9.7060309@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>

> >>> 0x3bb2 <do_cciss_intr+1649>:    mov    0x2(%r8),%dx
> >>> 0x3bb7 <do_cciss_intr+1654>:    test   %dx,%dx
> >>> 0x3bba <do_cciss_intr+1657>:    je     0x3f0e <do_cciss_intr+2509>
> >>>
> >>>
> >>> $ addr2line -e cciss.o -f  do_cciss_intr+0x627 SA5_fifo_full
> >>>
> /home/rdunlap/linsrc/linux-2.6.27-rc3-git7/drivers/block/cciss.h:206
> >> OK ...that's confusing.  It seems to be saying that ctrlr_info_t *
> >> was NULL.  However, I can't see a way of getting into the
> fifo_full
> >> callback from do_cciss_intr ..
> >> especially not with an NULL host.
> >>
> >> James
> >
> > That is weird. Even if we could get there fifo_full doesn't
> do anything but wait for a bit.
>
> Hi,
>
> This just happened again.  This time it's on 2.6.27-rc5-git3.
>
> ~Randy

Thanks Randy. I think. :)

I'll try to recreate in my lab.

-- mikem
>
