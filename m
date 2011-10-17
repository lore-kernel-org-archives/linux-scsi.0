From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
 staging
Date: Mon, 17 Oct 2011 08:54:42 -0700
Message-ID: <20111017155442.GA14911@suse.de>
References: <1318660132-21529-1-git-send-email-kys@microsoft.com>
 <1318714047.7271.49.camel@dabdike.int.hansenpartnership.com>
 <6E21E5352C11B742B20C142EB499E0481AA0FED0@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <1318859976.4794.8.camel@dabdike.int.hansenpartnership.com>
 <6E21E5352C11B742B20C142EB499E0481AA15174@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <1318865202.4794.21.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab1JQPzH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2011 11:55:07 -0400
Content-Disposition: inline
In-Reply-To: <1318865202.4794.21.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: KY Srinivasan <kys@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, Haiyang Zhang <haiyangz@microsoft.com>

On Mon, Oct 17, 2011 at 10:26:42AM -0500, James Bottomley wrote:
> On Mon, 2011-10-17 at 15:15 +0000, KY Srinivasan wrote:
> > This patch is against Greg's staging tree where recently I merged all
> > of the storage
> > drivers into a single driver. This change may not have percolated up
> > yet - Greg has
> > checked this into his staging tree though.
> 
> OK, that explains the difference.
> 
> > As I deal with the review comments now, do you want me to get these
> > changes
> > applied first to Greg's tree before you would consider moving this
> > driver to drivers/scsi
> > directory, or could you move the driver as it is in Greg's tree under
> > staging and I could give
> > you patches against the moved driver.
> 
> Either way is fine by me.  The best route for this is to get the staging
> update into Linus head, then work on the actual SCSI problems.  I'd like
> other SCSI people besides me to review it.

That will happen for the 3.2-rc1 release, so that might be the better
time to review this.

greg k-h
