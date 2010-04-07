From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 7 Apr 2010 10:36:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004071032500.1779-100000@iolanthe.rowland.org>
References: <4BBC25C9.5030201@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BBC25C9.5030201-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mark Lord <mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org, Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 7 Apr 2010, Jonas Schwertfeger wrote:

> Here is the trace with Mark's fix:
> 
> ffff88003772c0c0 1008628966 S Bo:10:002:2 -115 31 = 55534243 95000000 
> 00020000 80001085 082e0000 00010000 00000000 40ec00
> ffff88003772c0c0 1008629074 C Bo:10:002:2 0 31 >
> ffff880035b1d600 1008629094 S Bi:10:002:1 -115 512 <
> ffff880035b1d600 1008634784 C Bi:10:002:1 0 512 Z
> ffff88003772c0c0 1008634827 S Bi:10:002:1 -115 13 <
> ffff88003772c0c0 1008634861 C Bi:10:002:1 0 13 = 55534253 95000000 
> 00000000 00
> ffff88003772c0c0 1008635021 S Bo:10:002:2 -115 31 = 55534243 96000000 
> 00020000 80001085 082e0000 00010000 00000000 40a100
> ffff88003772c0c0 1008635050 C Bo:10:002:2 0 31 >
> ffff880035b1d600 1008635058 S Bi:10:002:1 -115 512 <
> ffff880035b1d600 1008635305 C Bi:10:002:1 -32 0
> ffff88003772c0c0 1008635375 S Co:10:002:0 s 02 01 0000 0081 0000 0
> ffff88003772c0c0 1008635645 C Co:10:002:0 0 0
> ffff88003772c0c0 1008635665 S Bi:10:002:1 -115 13 <
> ffff88003772c0c0 1008635910 C Bi:10:002:1 0 13 = 55534253 96000000 
> 00020000 01
> ffff88003772c0c0 1008635925 S Bo:10:002:2 -115 31 = 55534243 97000000 
> 60000000 80000603 00000060 00000000 00000000 000000
> ffff88003772c0c0 1008636017 C Bo:10:002:2 0 31 >
> ffff880035b1d600 1008636032 S Bi:10:002:1 -115 96 <
> ffff880035b1d600 1008636123 C Bi:10:002:1 0 96 Z
> ffff88003772c0c0 1008636137 S Bi:10:002:1 -115 13 <
> ffff88003772c0c0 1008636207 C Bi:10:002:1 0 13 = 55534253 97000000 
> 00000000 00
> ffff88003772c0c0 1008638008 S Bo:10:002:2 -115 31 = 55534243 98000000 
> 00100000 80000a28 00000000 00000008 00000000 000000
> ffff88003772c0c0 1008638101 C Bo:10:002:2 0 31 >
> ffff880008c53b40 1008638179 S Bi:10:002:1 -115 4096 <
> ffff880008c53b40 1008648547 C Bi:10:002:1 0 4096 Z
> ffff88003772c0c0 1008648627 S Bi:10:002:1 -115 13 <
> ffff88003772c0c0 1008648715 C Bi:10:002:1 0 13 = 55534253 98000000 
> 00000000 00

This is not what I expected.  What version of the kernel are you using?  
Those 'Z' entries should not be possible in 2.6.33 or later.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
