From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: lots and lots of disks again
Date: 29 Feb 2004 10:41:36 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078072902.1779.41.camel@mulgrave>
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
	<20040217152714.GG3810@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:63948 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262076AbUB2Ql6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 11:41:58 -0500
In-Reply-To: <20040217152714.GG3810@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Andries Brouwer <aebr@win.tue.nl>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

On Tue, 2004-02-17 at 09:27, Kurt Garloff wrote:
> Agreed. Having it the new scheme optional now (defaulting to off), 
> deprecating the old numbers in 2.7 (defaulting new scheme to on)
> and drop from 2.8 looks like a reasonable plan to me.
> 
> Now we ionly need to get some device space allocated.
> 
> PS: I believe 64 partitions is enough. 

OK, this all went quiet again.

The choices are between the current patch from Kurt which is limited to
16 partitions, or a new patch (which no-one has yet produced) to raise
us to 64 partitions on a new major number with a switching scheme.

Kurt, since you're pushing the patch, which do you want me to do?  Apply
your current patch for 16 or wait for a new one for 64?

James


