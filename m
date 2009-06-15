From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Mon, 15 Jun 2009 10:59:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906151058460.5057-100000@iolanthe.rowland.org>
References: <3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e7aae30906150742l18e74a8fua5f08686c2c76454-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Jun 2009, Ramya Desai wrote:

> I can not post the code in public because of some limitations I have.
> But Still I am confused with return status (to SCSI layer) for the
> command while it is in progress, to get the next command. Is it some
> thing like PENDING?

If you're talking about the return value from queuecommand(), it should 
be 0.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
