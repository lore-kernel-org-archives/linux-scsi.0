From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: new kernel = megaraid performance cut in half
Date: Thu, 16 May 2002 19:09:29 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E178Pgv-0004l5-00@the-village.bc.nu>
References: <3CE3E0B3.4000108@aptalaska.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CE3E0B3.4000108@aptalaska.net> from "Matthew Schumacher" at May 16, 2002 08:39:15 AM
List-Id: linux-scsi@vger.kernel.org
To: Matthew Schumacher <matt.s@aptalaska.net>
Cc: linux-scsi@vger.kernel.org

> > I am running 7.3 (upgraded from 7.2) and I feel that the 2.4.18 kernel
> > with the new VM code is actually inferior to that of 2.4.9-31. I have lots
> > of memory (1.2 gig) and lots of disk access, and I see more swap and worse
> > interactive performance on 2.4.18 (redhat supplied kernel) as compared to 
> > the redhat supplied 2.4.9-31 for 7.2.
> 
> Hmm, the reason why I upgraded to 2.4.18 in the first place was to fix a 
> bunch of problems with quota.  I wonder if 2.4.9-31 will work with the 
> quotas correctly, I was on 2.4.7.

Quite a few quota race fixes are after 2.4.9. Its also going to depend
entirely on your workload what works best.
