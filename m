From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI Adapter
Date: Fri, 5 Nov 2004 14:19:43 +0000
Message-ID: <20041105141943.GX24690@parcelfarce.linux.theplanet.co.uk>
References: <418B7790.3060905@babut.net> <20041105134331.GV24690@parcelfarce.linux.theplanet.co.uk> <418B873D.30305@babut.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:32431 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262703AbUKEOTo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 09:19:44 -0500
Content-Disposition: inline
In-Reply-To: <418B873D.30305@babut.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Babut <thomas@babut.net>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Fri, Nov 05, 2004 at 02:59:25PM +0100, Thomas Babut wrote:
> >Can you turn on negotiation debugging and send me the result?  If you
> >have 2.1.18m, that's sym53c8xx.debug=0x200 ... earlier than that, it's
> >sym53c8xx=debug:0x200
> Sorry, I can't because this a dedicated server. :(

I need something to work with ... can you schedule some downtime?

> I've got two screenshots from the local administrator:
> http://tomek.tueddeln.de/screenshot1.jpg
> http://tomek.tueddeln.de/screenshot2.jpg

Hey!  There's a *lot* more information there than you gave me ;-(

I see a lot of parity errors there.  Can you check the cabling, termination,
etc?  How about putting a serial console on it so I can see all the messages?

> Btw: Where can I get the newest sym53c8xx_2 driver?

I commit to the parisc-linux CVS tree on a regular basis, then bundle up
what I have once per upstream release and send it to linux-scsi.  Last
patches:
http://marc.theaimsgroup.com/?l=linux-scsi&m=109840610525441&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=109844985008496&w=2

James then commits it to the linux-scsi scsi-misc-2.6 BK tree.
You can see it at
http://linux-scsi.bkbits.net:8080/scsi-misc-2.6/ChangeSet@-2w?nav=index.html

I believe Andrew Morton then includes scsi-misc-2.6 in his -mm releases.

So that's four different places you can get it, depending on what's
easiest for you.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
