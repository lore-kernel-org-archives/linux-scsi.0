From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Mon, 15 Jun 2009 10:49:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906151044540.5057-100000@iolanthe.rowland.org>
References: <4A365DCA.2030907@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4A365DCA.2030907-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Jun 2009, Boaz Harrosh wrote:

> You are right, this is not what I understood. I understood that he is hacking
> on current USB driver to try and enhance it in such a way that it will support
> command queuing at the target.
> 
> He is not currently concerned about any devices but his own HW. But he is certainly
> not writing a driver from scratch. He is basing on the current code base.
> 
> Did I understand right?

It's hard to tell from what he wrote.  Ramya's description of his code
is not very complete or precise.

> Do you think you have any tips for him. For example at the USB transport side,
> what is needed for asynchronous command execution as opposed to what is done now?

Nothing extra is needed as far as the lower parts of the USB stack are
concerned; they already are fully asynchronous.  But the entire
transport mechanism of usb-storage would have to be rewritten, since it
runs in a single thread and always waits for one command to finish
before accepting a new command.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
