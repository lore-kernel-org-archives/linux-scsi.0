From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in
 usb3 port
Date: Thu, 27 Sep 2012 10:44:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209271044030.1596-100000@iolanthe.rowland.org>
References: <CAEG-z2-JCSsuiTOauUc9P9U7fNvbC0AB2Y=RmfRKrWb_d1SisQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEG-z2-JCSsuiTOauUc9P9U7fNvbC0AB2Y=RmfRKrWb_d1SisQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Sandu <dexter-aBDqsGrG5hJxuZdfhUSrJg@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 27 Sep 2012, Adrian Sandu wrote:

> >> Anything else I can help with ? :| I'm stuck .. dunno what to test
> >> more or what else helpfull info I could give ya' guys ..
> >
> > You could run a test with a 3.3 kernel, as Sarah asked earlier.  Other
> > than that, I can't think of anything.  Maybe Sarah will come up with a
> > patch for you to try out.
> 
> I tried with a 3.3.8 , same thing happened. I don't understand why my
> gentoo (asrock) fails and fedora(laptop) didn't ! :|
> Why ? What causes it to shutdown ? It can copy to/from drives ( in the
> hub or directly in the root hub ) .. but what makes it fail sometimes
> :|

If we knew the answer, the problem would already be fixed.  :-)

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
