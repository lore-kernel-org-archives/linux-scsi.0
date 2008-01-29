From: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 15:31:10 +0100
Message-ID: <20080129143109.GW15220@kernel.dk>
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <200801291531.39825.oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 29 2008, Oliver Neukum wrote:
> Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
> > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > >> Greg KH wrote:
>  
> > > > No difference, still just a lot of resets.
> > > > 
> > > Where you able to figure out which usb storage transport is used?
> > > 
> > > in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
> > > functions. I'm not sure if these get stored in sysfs perhaps. This will
> > > pinpoint better where to look. Let me research a bit. 
> > 
> > Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' and
> > transport is 'Bulk'
> 
> You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG
> That should tell the reason for the resets.

Sure, I'll do that. Will post the results tonight.

-- 
Jens Axboe
