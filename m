From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill obsolete typedefs and wrappers from tmscsim
Date: Sat, 26 Jun 2004 13:17:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040626111701.GA15170@lst.de>
References: <20040624081510.GA7950@lst.de> <Pine.LNX.4.60.0406242247500.4258@poirot.grange> <20040625095022.GA28822@lst.de> <Pine.LNX.4.60.0406252022400.3953@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:12773 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267163AbUFZLRE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jun 2004 07:17:04 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0406252022400.3953@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

> >That'll happen sooner or later :)
> 
> So, why not now?:-)

Okay, okay - you've won :)

> Sure, that's easy!:-) I kept capitals initially, because all functions are 
> called like FindDCB, DoingSRB_Done, etc. But if we rename dc390_dcb into 
> dc390_lun, we would have to rename all respective functions, but that's 
> a bit too much, I think. So, is it ok to just "smallify" the types, going 
> the Middle Way?:-)

Yes.

> Do you want to rediff your 3rd patch yourself or should I do it? 

I can rediff it.

> Essentially, as you know, up to now the "old" EH code was used by tmscsim. 
> Switching to the "new" one seems a pretty essential change.

No.  Old EH is completely gone in 2.6.  The tmscsim driver claims to
implement new EH but gets it wrong currently..

> Is there a way 
> I could test it a bit? I can now boot and run from IDE, loading tmscsim as 
> a module, to which I have a disk and a CD-ROM connected. How can I 
> exercise eh-paths a bit without destroying the hardware?:-)

A good way to test EH is to improperly terminate the bus and wait for
failures to happen or similar things.

