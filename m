From: Greg KH <greg@kroah.com>
Subject: Re: cciss CSMI via sysfs for 2.6
Date: Fri, 18 Feb 2005 12:05:52 -0800
Message-ID: <20050218200552.GC20171@kroah.com>
References: <20050216164512.GA5734@beardog.cca.cpqcorp.net> <20050218194628.GA24583@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mail.kroah.org ([69.55.234.183]:414 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S261520AbVBRV3c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 16:29:32 -0500
Content-Disposition: inline
In-Reply-To: <20050218194628.GA24583@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, mike.miller@hp.com, linux-kernel@vger.kernel.org, mochel@osdl.org, akpm@osdl.org, eric.moore@lsil.com, linux-scsi@vger.kernel.org

On Fri, Feb 18, 2005 at 07:46:28PM +0000, Christoph Hellwig wrote:
> >  /*
> > + * sysfs stuff
> > + * this should be moved to it's own file, maybe cciss_sysfs.h
> > + */
> > +
> > +static ssize_t cciss_firmver_show(struct device *dev, char *buf)
> > +{
> > +	ctlr_info_t *h = dev->driver_data;
> > +        return sprintf(buf,"%c%c%c%c\n", h->firm_ver[0], h->firm_ver[1],
> > +                                h->firm_ver[2], h->firm_ver[3]);
> > +}
> 
> I really wish we had a common firmver release attribut in the driver
> core, as mentioned in the fc transport class thread.  Greg?

For a device?  It seems a huge overkill to add this attribute for
_every_ device in the system, when only a small minority can actually
use it.  Just put it as a default scsi or transport class attribute
instead.

thanks,

greg k-h
