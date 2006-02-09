From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: read only scsi disk
Date: Thu, 09 Feb 2006 14:19:15 -0500
Message-ID: <1139512755.9367.94.camel@localhost.localdomain>
References: <1139504647.9367.57.camel@localhost.localdomain>
	 <20060209190225.GI1593@parisc-linux.org>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orca.ele.uri.edu ([131.128.51.63]:6346 "EHLO orca.ele.uri.edu")
	by vger.kernel.org with ESMTP id S1750720AbWBITTa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 14:19:30 -0500
In-Reply-To: <20060209190225.GI1593@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Damian Pietras <daper@daper.net>

so fc disk is also removable, since anyone could unplug the fc cable at
any time...

so even parallel scsi disk, sata disk...

i donot think this is a good reason. ;)

ming

On Thu, 2006-02-09 at 12:02 -0700, Matthew Wilcox wrote:
> On Thu, Feb 09, 2006 at 12:04:07PM -0500, Ming Zhang wrote:
> > We are adding the support for an OSS iscsi target to support export an
> > iscsi disk as readonly. We set correct read only bit in sense dbd. But
> > we found that only when we set the removable bit, the linux will
> > actually check the ro bit. more detail information can be found from
> 
> Surely all iSCSI discs are removable, since anyone could unplug the
> network cable at any time ...

