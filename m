From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: CPU lock-ups with 4.12.0+ kernels related to usb_storage
Date: Wed, 26 Jul 2017 17:47:17 +0200
Message-ID: <20170726154716.GA5722@lst.de>
References: <20170712165200.GA29145@lst.de> <Pine.LNX.4.44L0.1707131258190.1571-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1707131258190.1571-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Arthur Marsh <arthur.marsh-CkBdp7X+a1oIQCUVoCVjmQ@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 13, 2017 at 01:00:29PM -0400, Alan Stern wrote:
> All right.  In the meantime, changing usb-storage won't hurt.
> Arthur, can you test the patch below?

Do you plan to send this fix to Greg for 4.13-rc?
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
