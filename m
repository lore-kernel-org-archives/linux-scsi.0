From: Ben Collins <bcollins@debian.org>
Subject: Re: sbp2: modprobe -r fails, module allegedly in use
Date: Sun, 10 Jul 2005 13:52:09 -0400
Message-ID: <20050710175209.GH14956@phunnypharm.org>
References: <42D133EE.9090204@s5r6.in-berlin.de> <20050710153126.GB14956@phunnypharm.org> <20050710174054.GA28623@infradead.org> <20050710174643.GG14956@phunnypharm.org> <20050710174913.GA28702@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:29412 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261991AbVGJRwM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:52:12 -0400
Content-Disposition: inline
In-Reply-To: <20050710174913.GA28702@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Sun, Jul 10, 2005 at 06:49:13PM +0100, Christoph Hellwig wrote:
> On Sun, Jul 10, 2005 at 01:46:43PM -0400, Ben Collins wrote:
> > The exposed implementation might not have, but atleast 3 times now, since
> > the driver model started being used, I've had to change the way I use the
> > exposed implementation in order to get bean counting right with the device
> > and host devices.
> 
> What about reporting your problems to linux-scsi instead of all this
> silly bitching?

I just did, and I have. Never got a reply before. Plus the fact that
generally the fix I needed was in the USB storage driver led me to believe
"yes, we know it changed", so why bother?

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
