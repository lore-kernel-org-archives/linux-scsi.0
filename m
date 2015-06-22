From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Mon, 22 Jun 2015 16:16:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1506221615390.1799-100000@iolanthe.rowland.org>
References: <CAOcK=COj7=akJUhsg2Pfr5aeh_tC9dEL3rZK1yKuvTN0KyJB1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOcK=COj7=akJUhsg2Pfr5aeh_tC9dEL3rZK1yKuvTN0KyJB1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Rathgeb <maggu2810-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, James Bottomley <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Jun Itou <itou_jun-6LX5ZuzTTw53+QwDJ9on6Q@public.gmane.org>, Matt <vickm78-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 22 Jun 2015, Markus Rathgeb wrote:

> >> > Maybe your patch will be acceptable, though.  We'll have to hear from
> >> > Markus and Matt.
> >>
> >> We'll probably have to take this to fsdevel as well ... they might have
> >> opinions about whether the FS wants to be informed about flush failure.
> 
> So, it is okay to wait for the end of that discussion before I start
> further testing or should I test the patch above?

Please test it now.  I'd like to know if it fixes your problem, 
regardless of how the discussion goes.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
