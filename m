From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: lots and lots of disks again
Date: Tue, 17 Feb 2004 19:44:41 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040217184441.GA4498@pclin040.win.tue.nl>
References: <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk> <20040212161800.GU1780@tpkurt.garloff.de> <1076604183.2576.89.camel@mulgrave> <20040216124047.GG4011@tpkurt.garloff.de> <20040216225704.GA3420@pclin040.win.tue.nl> <1076979373.1758.688.camel@mulgrave> <20040217144959.GA4282@pclin040.win.tue.nl> <1077031099.1757.24.camel@mulgrave> <20040217155024.GB4282@pclin040.win.tue.nl> <1077040659.2186.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.tue.nl ([131.155.2.7]:56071 "EHLO mailhost.tue.nl")
	by vger.kernel.org with ESMTP id S266428AbUBQSow (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 13:44:52 -0500
Content-Disposition: inline
In-Reply-To: <1077040659.2186.31.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries Brouwer <aebr@win.tue.nl>, Kurt Garloff <garloff@suse.de>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

On Tue, Feb 17, 2004 at 12:57:37PM -0500, James Bottomley wrote:

> > Then what is the boot parameter? I don't know. Anything.
> > Say, scsi-legacy=sda,sdb,sde.
> 
> But this is complexity for no gain.
> 
> The proposal is very simple: You want large numbers or discs or large
> numbers of partitions, you get fixed tools and use a flat space on the
> new major number.  You want legacy, you don't do anything for 2.6; for
> 2.7 you'll need to specify a boot flag.

Yes, I understand what you propose.
I describe something more backwards compatible. Without a flag day.
Without the need to change device nodes that you have already.
Without the need to change them back when you boot an old kernel.

Change is painful. All-or-nothing changes even more so.
I like keeping support for the old stuff, but making its use
slowly more inconvenient (by making the new things the default).

Andries
