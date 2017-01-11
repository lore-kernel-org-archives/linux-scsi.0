From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Wed, 11 Jan 2017 14:36:43 +0100
Message-ID: <20170111133643.GB31565@pali>
References: <CABhjJhMN31Ooq5ewpBft97w2+UpYM8S_hkpgwWm3a0wBhXW14g@mail.gmail.com>
 <Pine.LNX.4.44L0.1701101520510.2462-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1701101520510.2462-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Dainius =?utf-8?Q?Masili=C5=ABnas?= <pastas4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 10 January 2017 15:29:23 Alan Stern wrote:
> > Tom Yan wrote that smartctl/hdparm "works" because they use the SCSI ATA
> > PASSTHROUGH command. It is not an option for kernel?
> 
> No, because many devices do not implement SCSI ATA PASSTHROUGH.  
> (Consider devices whose underlying technology does not use ATA or SATA,
> for example.)  And some of the ones that don't implement it will die if
> you try to send them an ATA PASSTHROUGH command.

It is not possible to detect if underlaying device is ATA?

> You have to understand that consumer USB storage really is very
> low quality in many cases.  Vendors aim for low cost rather than high 
> reliability or correctness.

Understood. But lot of distributions call hdparm for inserted disks and
also set some APM (or at least check it)... That means there is already
some way how to deal with these problems (in userspace).

-- 
Pali Rohár
pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
