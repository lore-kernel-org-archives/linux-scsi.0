From: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Mon, 7 Jul 2014 17:25:54 +0100
Message-ID: <20140707162554.GF19630@localhost.localdomain>
References: <CANudz+sYkDthT9-xpt_hdqXHj+pSeTR5UcNmsPa4uP+YCvzSiw@mail.gmail.com>
 <20140707092029.GA19630@localhost.localdomain>
 <CANudz+uUuhLdfkVSseXXHW6ugm126Q4Taau+s7wavAP=Z9=4XA@mail.gmail.com>
 <53BAB5DF.5090606@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D1726D887@AcuExch.aculab.com>
 <CANudz+uOS3VVyz6FcHoui8z678R6Xc0CQrdqFRdS5NyfCB59Zw@mail.gmail.com>
 <20140707155233.GD19630@localhost.localdomain>
 <CANudz+s8R3AnxEJ229EwAOOxEk2WZUjMjoE3rwdRM1YM5ZO=og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANudz+s8R3AnxEJ229EwAOOxEk2WZUjMjoE3rwdRM1YM5ZO=og-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: loody <miloody-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>, Lars Melin <larsm17-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 08, 2014 at 12:15:54AM +0800, loody wrote:
> so sg_read will not hammer on the page cache like dd without "iflags=direct"
> 
> thanks for your kind help,

The sg_read program (and other programs in sg3_utils) sends a command directly
to the device using an SG_IO ioctl. This bypasses all the caching layers in
the kernel and always results in IO to the device (if it succeeds).

Regards,
Bryn.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
