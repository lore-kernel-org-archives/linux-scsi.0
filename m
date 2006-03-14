From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH ] drivers/base/bus.c - export reprobe
Date: Tue, 14 Mar 2006 09:57:41 -0800
Message-ID: <20060314175741.GA2697@suse.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F36D829@NAMAIL2.ad.lsil.com> <20060314153455.GA8071@suse.de> <20060314170855.GA18342@infradead.org> <20060314171951.GA22678@suse.de> <20060314172543.GA20331@infradead.org> <20060314172933.GA24619@suse.de> <1142358210.3241.28.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750726AbWCNR5y@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1142358210.3241.28.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 14, 2006 at 11:43:30AM -0600, James Bottomley wrote:
> On Tue, 2006-03-14 at 09:29 -0800, Greg KH wrote:
> > Ah, ok, that makes more sense.
> > 
> > Eric, care to resend without the mime crud so I can apply it?
> 
> Actually, would it be OK if you sign off on this and I take it via the
> scsi tree?  Otherwise there'll be a nasty cross dependency between
> scsi-misc and usb and I'll spend the next week explaining what trees you
> need to pull in to get scsi-misc to build.

Sure, that makes a lot of sense:

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Oh, and please make that scsi wrapper function either
EXPORT_SYMBOL_GPL() or an inline function or macro.

thanks,

greg k-h
