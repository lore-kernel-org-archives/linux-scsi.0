From: worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org (Dale R. Worley)
Subject: Re: Large disk drives
Date: Thu, 6 Nov 2014 14:17:14 -0500
Message-ID: <201411061917.sA6JHEGg007026@hobgoblin.ariadne.com>
References: <Pine.LNX.4.44L0.1411041112010.966-100000@iolanthe.rowland.org>
 <1415203668.13212.2.camel@jarvis> <20141105191505.GF27083@thunk.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20141105191505.GF27083-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org> (tytso-3s7WtUTddSA@public.gmane.org)
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tytso-3s7WtUTddSA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

> From: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> 
> On Wed, Nov 05, 2014 at 05:07:48PM +0100, James Bottomley wrote:
> > 
> > OK, but I still don't understand how windows gets the partition table on
> > there in the first place ... that must surely be some sort of guess the
> > disk size hack.
> 
> 99% of the time the partition table was provided by the drive
> manufacturer; I would assume they have a way of doing that as a part
> of their manufacturing processes that don't require an OS individually
> running the equivalent of fdisk or gdisk on said drive.

I would expect it as part of the manufacturer's testing process.
After all, the disks are going to be plugged into a machine whose
whole purpose is to run the disk through its paces, and the machine
knows in advance exactly how big the disk is.

Dale
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
