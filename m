From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] more ncr updates
Date: Fri, 26 Sep 2003 17:46:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030926154647.GA24222@lst.de>
References: <20030926151751.GA23650@lst.de> <20030926154433.GN24824@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:17542 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262373AbTIZPqv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 11:46:51 -0400
Content-Disposition: inline
In-Reply-To: <20030926154433.GN24824@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Fri, Sep 26, 2003 at 04:44:33PM +0100, Matthew Wilcox wrote:
> > -	if ((driver_setup.led_pin ||
> > -	     (nvram && nvram->type == SCSI_NCR_SYMBIOS_NVRAM)) &&
> > -	    !(np->features & FE_LEDC) && !(np->sv_gpcntl & 0x01))
> > +	if (driver_setup.led_pin)
> >  		np->features |= FE_LED0;
> >  
> >  	/*
> 
> Are you sure this is right?  I have:
> 
>         if ((driver_setup.led_pin) &&
>             !(np->features & FE_LEDC) && !(np->sv_gpcntl & 0x01))
>                 np->features |= FE_LED0;

Yes, you're right.

