From: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/RFC] UASP enhancement to usb-storage
Date: Thu, 01 Apr 2010 15:28:52 -0400
Message-ID: <4BB4F3F4.3060706@interlog.com>
References: <201004011738.o31HcpDb025872@us01dwamd020.synopsys.com> <20100401175242.GA10642@xanatos>
Reply-To: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100401175242.GA10642@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Hrant Dalalyan <Hrant.Dalalyan-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, USB mailing list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB storage mailing list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, Paul Zimmerman <Paul.Zimmerman-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, John Youn <John.Youn-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Ashot Madatyan <Ashot.Madatyan-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Sarah Sharp wrote:
> Forwarding to the linux-scsi list too.

Why "UASP"? The t10.org document defining it is
called "UAS" (USB Attached SCSI).

It is a USB transport protocol but not a SCSI
transport protocol in the sense that it hasn't
been given a SCSI protocol identifier.

Not that t10.org naming is very consistent for
transports: some have a trailing P (e.g. FCP
and SRP), some prefer I for interface (e.g.
SPI and ADI) and some have neither (e.g. SAS
and SRPC).

Doug Gilbert
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
