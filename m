From: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Subject: Re: patch
	scsi-add-a-field-to-scsi_device-to-count-open-file-references.patch
	added to gregkh-2.6 tree
Date: Wed, 5 Mar 2008 12:41:33 -0800
Message-ID: <20080305204133.GA27937@suse.de>
References: <1204748015695@kroah.org> <1204749410.3047.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1204749410.3047.57.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 05, 2008 at 02:36:50PM -0600, James Bottomley wrote:
> On Wed, 2008-03-05 at 12:13 -0800, gregkh-l3A5Bk7waGM@public.gmane.org wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >      Subject: SCSI: add a field to scsi_device to count open file references
> > 
> > to my gregkh-2.6 tree.  Its filename is
> > 
> >      scsi-add-a-field-to-scsi_device-to-count-open-file-references.patch
> > 
> > This tree can be found at 
> >     http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
> 
> Could you un add it, please ... as I've explained several times,
> shadowing bdev->bd_openers isn't the right thing to do in SCSI.

Ok, I wanted to at least test this stuff out.  As the follow-on patch
doesn't compile yet, I'll drop this one as well and let Alan send
updates after this gets all hashed out.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
