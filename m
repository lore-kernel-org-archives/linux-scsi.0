From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Mon, 15 Jun 2009 10:01:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>
References: <4A363EB4.8000102@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4A363EB4.8000102-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Jun 2009, Boaz Harrosh wrote:

> >> If you are using the existing USB mass storage infrastructure then
> >>  it will not work. This is because all commands are issued from a
> >>  thread per host, which does a synchronous execution of one command
> >>  at a time. In fact it does not even have a Q, but a global one cmnd
> >>  pointer per host. And therefor sets can_queue to 1.
> >>
> >>  Are you using the existing USB infrastructure?
> >>
> >>
> >>  Boaz
> >>
> > I am replacing the default USB mass storage driver with the one I am
> > developing. But I am using the default SCSI and USB stack provided by
> > Linux.
> > 
> > So is there any another way to make my driver asynchronous?
> > 
> > -RD
> 
> I was afraid so.
> 
> There is a lot of code you will need to change in current USB storage stack
> SCSI is built with native support for queuing, but not so USB-storage-stack.

Boaz:

It looks like you didn't read Ramya's reply to your last message.  
Ramya isn't keeping the USB storage "stack" -- it is being replaced by
a new driver -- so there's no point talking about making changes to it.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
