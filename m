From: David Zeuthen <david-o55+BOBDEFg@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 31 Mar 2010 13:17:54 -0400
Message-ID: <1270055874.16657.28.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.1003311054500.1739-100000@iolanthe.rowland.org>
	 <1270048801.16657.8.camel@localhost.localdomain>
	 <4BB37454.8070808@interlog.com>
	 <1270053444.16657.17.camel@localhost.localdomain>
	 <20100331165807.GA20547@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100331165807.GA20547-kS5D54t9nk0aINubkmmoJbNAH6kLmebB@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Cc: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-03-31 at 18:58 +0200, Lennart Poettering wrote:
> > I actually don't think libatasmart has any business making such
> > decisions on behalf of the user... Lennart, any chance we can stop
> > libatasmart from doing this? Thanks.
> 
> Uh. I think it definitely needs to call this. I am pretty sure most USB
> HDDs you plug in have SMART disabled by default until libatasmart
> enables it. So, libatasmart would stop enabling it automatically you'd
> end up with no SMART at all for these devices.
> 
> Also, on my desktop here, when you reset the BIOS settings to the
> defaults, SMART is off. So, that means that somebody needs to enable
> SMART from Linux, and who should do that if not libatasmart?

Depends. If it's safe to enable SMART when available, sure, let's go for
it. If it's not safe, we can prompt the user that SMART monitoring is
available yet turned off. Much the same way we currently prompt the user
when the disk is failing

http://people.freedesktop.org/~david/smart-fail-1.png

It wouldn't be much work to do this.

    David


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
