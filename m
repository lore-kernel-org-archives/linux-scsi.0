From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: lots and lots of disks again
Date: 17 Feb 2004 10:08:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077030506.1757.13.camel@mulgrave>
References: <20040211220918.GJ4010@tpkurt.garloff.de>
	<20040211142933.484ca978.akpm@osdl.org>
	<20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk>
	<20040212150035.GN1780@tpkurt.garloff.de>
	<20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk>
	<20040212161800.GU1780@tpkurt.garloff.de>
	<1076604183.2576.89.camel@mulgrave>
	<20040216124047.GG4011@tpkurt.garloff.de>
	<20040216225704.GA3420@pclin040.win.tue.nl>
	<1076979373.1758.688.camel@mulgrave>
	<20040217075724.GA3805@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:12423 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266222AbUBQPIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 10:08:50 -0500
In-Reply-To: <20040217075724.GA3805@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Andries Brouwer <aebr@win.tue.nl>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

On Tue, 2004-02-17 at 02:57, Kurt Garloff wrote:
> You underestimate the amount of cruft code out there that does care.
> Unfortunately. Some programs (think scsiformat, ...) do want to know
> what transport the underlying hardware actually uses. And determine
> this by looking at the device number.
> I expect it will take some time to sort this all out.

Well, yes, that's why the opt in for 2.6, opt out for 2.7 expect all
apps to be fixed by 2.8 roadmap...

James


