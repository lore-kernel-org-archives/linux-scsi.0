From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH/RFC 1/2] 3ware 9000 SATA-RAID driver v2.26.00.009
Date: Fri, 28 May 2004 05:32:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040528043244.GK5850@parcelfarce.linux.theplanet.co.uk>
References: <HYCD4000.31K@hadar.amcc.com> <40B6235B.1080507@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:42402 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262194AbUE1Ecr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 00:32:47 -0400
Content-Disposition: inline
In-Reply-To: <40B6235B.1080507@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Adam Radford <aradford@amcc.com>, akpm@osdl.org, james.bottomley@steeleye.com, hch@lst.de, linux-scsi@vger.kernel.org

On Thu, May 27, 2004 at 01:20:27PM -0400, Jeff Garzik wrote:
> Adam Radford wrote:
> >- The card can take up to 256 io's at a time, but 2 are marked off
> >  for internal use.  There are no 'per device' limits.  The firmware queue
> >  depth is 256 total for all devices.
> 
> I would therefore recommend not setting device queue depth in 
> ->slave_configure(), but rather setting the Scsi_Host_Template's 
> ->can_queue to 256.
> 
> This more accurately reflects the hardware.

254, surely?  The midlayer can't be expected to know about the 2 reserved
ones ;-)

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
