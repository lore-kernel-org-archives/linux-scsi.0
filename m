From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: lots and lots of disks again
Date: 17 Feb 2004 12:57:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077040659.2186.31.camel@mulgrave>
References: <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk>
	<20040212150035.GN1780@tpkurt.garloff.de>
	<20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk>
	<20040212161800.GU1780@tpkurt.garloff.de>
	<1076604183.2576.89.camel@mulgrave>
	<20040216124047.GG4011@tpkurt.garloff.de>
	<20040216225704.GA3420@pclin040.win.tue.nl>
	<1076979373.1758.688.camel@mulgrave>
	<20040217144959.GA4282@pclin040.win.tue.nl>
	<1077031099.1757.24.camel@mulgrave>
	<20040217155024.GB4282@pclin040.win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:35220 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266416AbUBQR6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 12:58:00 -0500
In-Reply-To: <20040217155024.GB4282@pclin040.win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Kurt Garloff <garloff@suse.de>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

On Tue, 2004-02-17 at 10:50, Andries Brouwer wrote:
> On Tue, Feb 17, 2004 at 10:18:07AM -0500, James Bottomley wrote:
> > The correct way to solve this is an all or nothing migration gated by a
> > boot time flag.
> 
> Yes, I was also thinking of boot time flags, but not all-or-nothing.
> Almost nobody actually needs these five thousand disks, and programs
> like LILO know about major 8, so I can even imagine that someone with
> lots of disks would like the boot disk to remain sda (8,0) even when
> all the others become (1049,*)-(1073,*).
> 
> Then what is the boot parameter? I don't know. Anything.
> Say, scsi-legacy=sda,sdb,sde.

But this is complexity for no gain.

The proposal is very simple: You want large numbers or discs or large
numbers of partitions, you get fixed tools and use a flat space on the
new major number.  You want legacy, you don't do anything for 2.6; for
2.7 you'll need to specify a boot flag.

James


