From: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Thu, 1 Apr 2010 16:05:35 +0200
Message-ID: <k2zac3eb2511004010705he844fff8wfa8e18626b8f3e45@mail.gmail.com>
References: <4BB37454.8070808@interlog.com> <Pine.LNX.4.44L0.1003311229460.1739-100000@iolanthe.rowland.org>
	<n2r59ca64281004010632h9dec0e98pdc0bc9a923b43206@mail.gmail.com>
	<s2zac3eb2511004010642ic2e8f973h2e038d3c90c6ca75@mail.gmail.com>
	<r2k59ca64281004010655z93fedfa8rdeb447d82a848d9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <r2k59ca64281004010655z93fedfa8rdeb447d82a848d9f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 1, 2010 at 15:55, Jonas Schwertfeger
<jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Apr 1, 2010 at 3:42 PM, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org> wr=
ote:
>>> Renamed both /usr/bin/udisks
>>
>> That's the commandline tool, you need to check for something like:
>> =C2=A0/usr/lib/udisks/udisks-daemon
>>
>> Can you run as root:
>> =C2=A0udevadm test /sys/class/block/sd...
>> and post the output here. So we see what udev would run on bootup.
>
> Since the drive doesn't even show up as a block device when connected
> to the USB 3.0 port I can't run that command for the device directly.

That means it does not show up, or it disappears after something is
trying to do something with it. If it does not appear at all, we don't
need to look in userspace, I guess. :)

> However, what I completely forgot to mention is that the drive works
> just fine when connected to a USB 2.0 port. This was why I initially
> thought the xHCI driver is to blame, but now that we are investigatin=
g
> udev this does seem kind of odd to me. So, attached is the udevadm
> test output with the drive connected to a USB 2.0 port.

What are your rules trying to do with hdparm on the drive, that seems
rather odd to apply to a USB device:
  RUN '/lib/udev/hdparm' /lib/udev/rules.d/85-hdparm.rules:2

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
