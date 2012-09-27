From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in
 usb3 port
Date: Thu, 27 Sep 2012 14:50:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209271447340.1230-100000@iolanthe.rowland.org>
References: <CAEG-z2-QqRs4rK58BsPafnqLuQKXxHCGE_Q5R-WkhpPGNz1RoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEG-z2-QqRs4rK58BsPafnqLuQKXxHCGE_Q5R-WkhpPGNz1RoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Sandu <dexter-aBDqsGrG5hJxuZdfhUSrJg@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 27 Sep 2012, Adrian Sandu wrote:

> >> Adrian Sandu wrote:
> >>> I tried with a 3.3.8 , same thing happened. I don't understand why my
> >>> gentoo (asrock) fails and fedora(laptop) didn't ! :|
> 
> Tried to use the live cd on my laptop, can't reproduce it in any way
> on my computer ..
> Using the same live cd I can reproduce the problem on the asrock :|
> 
> Tried with 3.3.8, 3.4.11, 3.5.4. I don't get what's causing the drive
> to die from a simple hdparm -tT .. :|
> The even more weird thing is that it's not dying every time ..
> sometimes a hdparm runs successfully once or a few times before dying
> .. :|
> Guess I just have a bad luck .. ( altough .. I don't believe in "luck"
> when it comes to hardware/software/science .. :) )

Since you are using the same live CD on both computers, this has to be
caused by a difference in the hardware.  What do "lspci -vvv" and
"lspci -vvv -n" show on the two computers?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
