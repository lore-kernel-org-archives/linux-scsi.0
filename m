From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] Staging: hv: Applied all the patches already in the
 staging queue
Date: Thu, 9 Feb 2012 08:29:40 -0800
Message-ID: <20120209162940.GA16395@kroah.com>
References: <1327599460-12593-1-git-send-email-kys@microsoft.com>
 <1327599515-12679-1-git-send-email-kys@microsoft.com>
 <20120126173751.GA14400@suse.de>
 <1327600244.6151.5.camel@dabdike.int.hansenpartnership.com>
 <6E21E5352C11B742B20C142EB499E0481B70C8A1@TK5EX14MBXC128.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B70C8A1@TK5EX14MBXC128.redmond.corp.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <gregkh@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 09, 2012 at 03:31:50PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> > Sent: Thursday, January 26, 2012 12:51 PM
> > To: Greg KH
> > Cc: KY Srinivasan; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org; ohering@suse.com; hch@infradead.org; linux-
> > scsi@vger.kernel.org
> > Subject: Re: [PATCH 1/2] Staging: hv: Applied all the patches already in the staging
> > queue
> > 
> > > Yes, I have pending patches for this driver in my "to-apply" queue, but
> > > that is for 3.4, not now.
> > >
> > > So, how about I just apply those patches, and then apply a patch that
> > > moves it out of staging into drivers/scsi/, and queue all of those up
> > > for 3.4.
> > >
> > > James, any objection to that?
> > 
> > Well, we were going to try to stage this driver for 3.3-rc.  If everyone
> > agrees to push it back to 3.4, then this works for me.
> 
> Greg,
> 
> Now that you have applied all the pending patches for the Hyper-V storage
> driver; do you want me to resend the patch that moved this driver out of staging?

Please do, I need James's ACK on it as well.

thanks,

greg k-h
