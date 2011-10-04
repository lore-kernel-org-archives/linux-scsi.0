From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: =?windows-1252?Q?Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD=92s?=
 =?windows-1252?Q?_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5Ftype?=
 =?windows-1252?Q?=29?=
Date: Tue, 4 Oct 2011 10:10:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
References: <CADDb1s0ZnHzM72sDnFmRrM=GFJtxj5JkYUSPo6GdyQ_=7L2m9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADDb1s0ZnHzM72sDnFmRrM=GFJtxj5JkYUSPo6GdyQ_=7L2m9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amit Sahrawat <amit.sahrawat83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 4 Oct 2011, Amit Sahrawat wrote:

> Not able to get tools which can show the Caching Information when
> connected USB device to Windows 7(Except one option which allows for
> optimizing Performance by enabling/disabling Cache - But that option
> is available for all the Mass storage device) - Please let me know if
> there is option to view this.

I have no idea.

> So, I have collected USB analyzer logs for Device after connected to
> Windows 7.  Please find the attached logs.

It would be more informative if your logs did not show the initial
connection, but did show what happens when you write a small file to
the drive and then go through the "Safely Remove Hardware" procedure.

The real question is whether or not Windows sends a SYNCHRONIZE CACHE 
command to the drive.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
