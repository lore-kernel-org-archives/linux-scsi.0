From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 15:31:38 +0100
Message-ID: <200801291531.39825.oliver@neukum.org>
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764799AbYA2O2Z@vger.kernel.org>
In-Reply-To: <20080129141108.GV15220@kernel.dk>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
> On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > >> Greg KH wrote:
 
> > > No difference, still just a lot of resets.
> > > 
> > Where you able to figure out which usb storage transport is used?
> > 
> > in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
> > functions. I'm not sure if these get stored in sysfs perhaps. This will
> > pinpoint better where to look. Let me research a bit. 
> 
> Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' and
> transport is 'Bulk'

You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG
That should tell the reason for the resets.

	Regards
		Oliver
