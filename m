From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Wed, 31 Oct 2007 10:29:43 -0700
Message-ID: <20071031172943.GA29492@kroah.com>
References: <1193671019.3383.13.camel@localhost.localdomain> <1193676852.2655.21.camel@lov.site> <1193677071.3383.56.camel@localhost.localdomain> <47261F50.3050901@s5r6.in-berlin.de> <1193768743.3321.91.camel@localhost.localdomain> <20071031035506.GH14910@kroah.com> <1193841484.3411.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758860AbXJaReA@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193841484.3411.8.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 31, 2007 at 09:38:04AM -0500, James Bottomley wrote:
> On Tue, 2007-10-30 at 20:55 -0700, Greg KH wrote:
> > OSame problem here, if grp->is_visible is not set, sysfs_add_file() would
> > never be called, right?
> > 
> > Other than the logic problem (I think), I have no issue with this idea
> > at all.  Care to redo this so it works?
> 
> It's a fair cop govenor ... new patch attached.

Much better, thanks :)

I have no problem with this, if you want to take this in your tree,
please do and feel free to add:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

to it, or I can take it in mine.

thanks,

greg k-h
