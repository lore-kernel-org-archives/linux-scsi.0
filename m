From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Wed, 29 Sep 2004 18:22:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929182204.A15308@infradead.org>
References: <415A67B8.2080003@suse.de> <20040929130332.A11785@infradead.org> <415AAB0F.2080802@suse.de> <20040929171251.GA5368@us.ibm.com> <1096478376.2123.32.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:47108 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268728AbUI2RWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 13:22:14 -0400
Content-Disposition: inline
In-Reply-To: <1096478376.2123.32.camel@mulgrave>; from James.Bottomley@SteelEye.com on Wed, Sep 29, 2004 at 01:19:28PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Alan Stern <stern@rowland.harvard.edu>

On Wed, Sep 29, 2004 at 01:19:28PM -0400, James Bottomley wrote:
> On Wed, 2004-09-29 at 13:12, Mike Anderson wrote:
> > We may want to reconsider a method to distinguish unexpected removals
> > from clean removals.
> 
> Technically we have this: it's the recovery flag to scsi_host_cancel(). 
> Unfortunately, scsi_remove_host doesn't have such a flag so it's always
> set to zero at the moment.

and ->remove for the bus drivers doesn't know either, so adding such
a flag wouldn't help us much.
