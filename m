From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] libsas: Check that the firmware loader is present in
	sas_request_addr
Date: Thu, 6 Mar 2008 20:54:13 -0800
Message-ID: <20080307045413.GB913@kroah.com>
References: <20080306090904.258f92eb.randy.dunlap@oracle.com> <20080306181645.GA6046@kroah.com> <47D03666.9080000@oracle.com> <20080306210212.GC7430@tree.beaverton.ibm.com> <1204838233.3062.53.camel@localhost.localdomain> <20080306140437.8a193423.randy.dunlap@oracle.com> <1204841781.3062.69.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:32906 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYCGGIG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 01:08:06 -0500
Content-Disposition: inline
In-Reply-To: <1204841781.3062.69.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>

On Thu, Mar 06, 2008 at 04:16:21PM -0600, James Bottomley wrote:
> On Thu, 2008-03-06 at 14:04 -0800, Randy Dunlap wrote:
> > On Thu, 06 Mar 2008 15:17:13 -0600 James Bottomley wrote:
> > 
> > > We could do it that way ... I suspect what Greg was asking for was more
> > > like this:
> > > 
> > > James
> > 
> > Builds cleanly for CONFIG_FW_LOADER=n.
> > I'm having trouble setting CONFIG_FW_LOADER=m for test building it.
> 
> Ironically, I can, and have, tested that config ... I just couldn't
> build with CONFIG_FW_LOADER=n.
> 
> I think we've covered all the test cases between us.
> 
> > Anyway,
> > Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Thanks.

Yes, this is what I was thinking was needed.

Care to resend it with a signed-off-by?

thanks,

greg k-h
