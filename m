From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH ] drivers/base/bus.c - export reprobe
Date: Tue, 14 Mar 2006 09:29:33 -0800
Message-ID: <20060314172933.GA24619@suse.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F36D829@NAMAIL2.ad.lsil.com> <20060314153455.GA8071@suse.de> <20060314170855.GA18342@infradead.org> <20060314171951.GA22678@suse.de> <20060314172543.GA20331@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751506AbWCNR3i@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060314172543.GA20331@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 14, 2006 at 05:25:43PM +0000, Christoph Hellwig wrote:
> On Tue, Mar 14, 2006 at 09:19:51AM -0800, Greg KH wrote:
> > I saw the:
> > 
> > +       if (dev->driver) {^M
> > +               if (dev->parent)        /* Needed for USB */^M
> > +                       down(&dev->parent->sem);^M
> > 
> > portion and thought it came from USB core code somewhere.  Or are you
> > referring to the need for USB-storage here?
> 
> It's copied from a runtime close to this one in the driver core.
> Unfortunately it's not easily sharable so I duplicated those few lines.

Ah, ok, that makes more sense.

Eric, care to resend without the mime crud so I can apply it?

thanks,

greg k-h
