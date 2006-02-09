From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: read only scsi disk
Date: Thu, 09 Feb 2006 15:01:16 -0500
Message-ID: <1139515276.9367.118.camel@localhost.localdomain>
References: <1139504647.9367.57.camel@localhost.localdomain>
	 <20060209190225.GI1593@parisc-linux.org>
	 <43EB9DDC.2000108@s5r6.in-berlin.de>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orca.ele.uri.edu ([131.128.51.63]:48593 "EHLO orca.ele.uri.edu")
	by vger.kernel.org with ESMTP id S1750743AbWBIUBd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 15:01:33 -0500
In-Reply-To: <43EB9DDC.2000108@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kernel.org>, Damian Pietras <daper@daper.net>

yes, this is more accurate. thx.

ming


On Thu, 2006-02-09 at 20:54 +0100, Stefan Richter wrote:
> Matthew Wilcox wrote:
> > Surely all iSCSI discs are removable, since anyone could unplug the
> > network cable at any time ...
> 
> AFAIU, sdev->removable is about the medium, not about the device. Media 
> can be hot-removed, devices can be hot-unplugged. (Of course an iSCSI 
> target could implement removable media too.)

