From: Matthew Wilcox <willy@debian.org>
Subject: Re: Sym53c8xx_2
Date: Mon, 16 Aug 2004 12:12:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040816111242.GB28995@parcelfarce.linux.theplanet.co.uk>
References: <1092366037.28144.202254467@webmail.messagingengine.com> <Pine.LNX.4.60.0408132049060.4069@poirot.grange> <1092432298.18813.202307545@webmail.messagingengine.com> <Pine.LNX.4.60.0408150005570.5333@poirot.grange> <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local> <1092624889.15338.202386294@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:38322 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267536AbUHPLMo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 07:12:44 -0400
Content-Disposition: inline
In-Reply-To: <1092624889.15338.202386294@webmail.messagingengine.com>
List-Id: linux-scsi@vger.kernel.org
To: Kai OM <epimetreus@fastmail.fm>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org

On Sun, Aug 15, 2004 at 10:54:49PM -0400, Kai OM wrote:
> 
> On Sun, 15 Aug 2004 10:21:35 +0300 (EEST), "Kai Makisara"
> <Kai.Makisara@kolumbus.fi> said:
> 
> > Domain Validation does not fail in all configurations. I am using 
> > sym53c8xx_2 in two machines to drive the system disk and some other 
> > devices. I have had no SCSI problems with these systems.
> 
> What chipset is your controller based on?

I don't think the problem lies with the controller; I think it lies with
one or more devices on the bus.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
