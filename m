From: Patrick Mochel <mochel@osdl.org>
Subject: Re: Removal of driverfs files in drivers/cdrom/cdrom.c
Date: Mon, 29 Jul 2002 12:46:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0207291241590.22697-100000@cherise.pdx.osdl.net>
References: <200207281950.g6SJo2Z02368@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200207281950.g6SJo2Z02368@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org


> I think the root cause of all the ugly code is that none of us knows how to 
> match up the partitions or other adjunct elements which belong in the class 
> code with the actual device, and the fact that the generic code (cdrom and 
> genhd) is more than just SCSI, so we're all a little wary of messing too much 
> with it.  Are you planning to embed a driverfs parent pointer in the relevant 
> structures?  Do you think the best approach is to do driverfs creation/removal 
> for everything in the generic cdrom driver?  We're all a bit reticent to do a 
> wholesale rework of none scsi code without a clear idea of what we're supposed 
> to be doing.
> 
> If you give me an idea of how you are thinking of matching up the parent 
> pointers, I'll have a go at doing this more generally.

I wasn't attacking the code per se; it just looked wrong that a completely 
different layer was removing the files than was adding them...

I'm not sure I understand your question. You already have a parent 
pointer in struct device. Is that what you're referring to, or do you need 
something more?

As far as what to do with the SCSI and cdrom-specific stuff: you may be 
unclear, but you have a far better idea than I. So, I'm leaving it in your 
hands. And, don't try and suck me in. ;)

	-pat

