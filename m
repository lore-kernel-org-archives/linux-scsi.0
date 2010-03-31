From: David Zeuthen <david-o55+BOBDEFg@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 31 Mar 2010 13:06:38 -0400
Message-ID: <1270055198.16657.20.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.1003311054500.1739-100000@iolanthe.rowland.org>
	 <1270048801.16657.8.camel@localhost.localdomain>
	 <4BB37454.8070808@interlog.com>
	 <1270053444.16657.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1270053444.16657.17.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-03-31 at 12:37 -0400, David Zeuthen wrote:
> As I said above, I don't think it's ata_id that is the problem - I think
> it's udisks-probe-ata-smart, via libatasmart, that is responsible for
> submitting the SET FEATURES command:
> 
> http://git.0pointer.de/?p=libatasmart.git;a=blob;f=atasmart.c;h=a4b60c0eedf8e4f1ebafd932b7070c030459ef16;hb=HEAD#l2561
> 
> when it finds out that the SMART feature is available, yet not turned
> on.

Actually, reading the source again and speaking to Lennart, I don't
think libatasmart submits a SET FEATURES command. (libatasmart might be
responsible for the 16-byte IDENTIFY command though)

Thanks,
David

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
