From: Matthew Wilcox <willy@debian.org>
Subject: Re: lots and lots of disks again
Date: Tue, 17 Feb 2004 15:28:13 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040217152813.GS31168@parcelfarce.linux.theplanet.co.uk>
References: <20040211142933.484ca978.akpm@osdl.org> <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk> <20040212150035.GN1780@tpkurt.garloff.de> <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk> <20040212161800.GU1780@tpkurt.garloff.de> <1076604183.2576.89.camel@mulgrave> <20040216124047.GG4011@tpkurt.garloff.de> <20040216225704.GA3420@pclin040.win.tue.nl> <1076979373.1758.688.camel@mulgrave> <20040217075724.GA3805@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9123 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266234AbUBQP2U
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 10:28:20 -0500
Content-Disposition: inline
In-Reply-To: <20040217075724.GA3805@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Andries Brouwer <aebr@win.tue.nl>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

On Tue, Feb 17, 2004 at 08:57:24AM +0100, Kurt Garloff wrote:
> OK, if you take care to register some major number (or some space for 
> dev_t in newspeak), I'll write the patch to allow the SCSI disks to
> be registered there. We need about 20 bits, IMHO.

20 bits might not be quite big enough.  Assuming 6 bits for partitions,
that gives us 14 bits (16384 devices).  I'd like a fibrechannel person
to chime in here and tell us about the biggest FC array they've ever
seen, but given multipathing showing us the same device multiple times,
that seems a little tight (given how much pain it is to move to a new
numbering scheme).

If we're talking about the numberspace for /dev/drive, I don't see why
we shouldn't take a quarter of the space; ie 2^30 bits.  I suggest we
take 64.0.0.0/30 to leave the top half unused for now.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
