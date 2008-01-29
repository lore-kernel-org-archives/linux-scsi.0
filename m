From: Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 18:42:56 +0100
Message-ID: <200801291842.57937.oliver@neukum.org>
References: <20080128204935.GI15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <479F4B4B.2020000@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <479F4B4B.2020000-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Am Dienstag, 29. Januar 2008 16:50:35 schrieb Boaz Harrosh:
> On Tue, Jan 29 2008 at 16:31 +0200, Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org> wrote:
 
> I can not see what it is. Yes CONFIG_USB_STORAGE_DEBUG will help.
> I have a device here that uses the same trasport/protocol I'll
> try to reproduce the failure here.

This is the most common combination of transport and protocol. If it were
broken in a larger number of cases, we'd hear more reports. You'll probably
need the debug output to figure out what's wrong.

	Regards
		Oliver
