From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: lots and lots of disks again
Date: 12 Feb 2004 11:43:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076604183.2576.89.camel@mulgrave>
References: <20040210133932.A3870@infradead.org>
	<20040210154751.GH4010@tpkurt.garloff.de>
	<20040210102603.0c835212.akpm@osdl.org>
	<20040211145614.GA4010@tpkurt.garloff.de>
	<20040211132848.49eece0d.akpm@osdl.org>
	<20040211220918.GJ4010@tpkurt.garloff.de>
	<20040211142933.484ca978.akpm@osdl.org>
	<20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk>
	<20040212150035.GN1780@tpkurt.garloff.de>
	<20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk>
	<20040212161800.GU1780@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:32426 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266506AbUBLQnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 11:43:11 -0500
In-Reply-To: <20040212161800.GU1780@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

On Thu, 2004-02-12 at 11:18, Kurt Garloff wrote:
> Unless we go for the gendisk aliasing suggestion from James and allocate 
> a new major additionally. I did not yet check whether it's feasible.

Well, I've had my ear bent about gendisk aliasing not being feasible, so
to use the new major scheme, we'd have to have something like a boot
time switch in the kernel and only register either the old majors or the
new major.

James


