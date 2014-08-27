From: worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org (Dale R. Worley)
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Wed, 27 Aug 2014 15:23:46 -0400
Message-ID: <201408271923.s7RJNkHA009793@hobgoblin.ariadne.com>
References: <87801b450dee41dda169a3aa2dd2baf6@serv030.corp.eldorado.org.br>
	 <1408972618.10300.35.camel@linux-fkkt.site>
	 <201408261939.s7QJdg4B013031@hobgoblin.ariadne.com> <1409083158.3812.66.camel@jarvis.lan>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

What I find interesting is that Windows (at least, Windows 7
Professional) seems to be able to handle the deficient adapter.  What
I'd like to do is log the disk commands during the mounting sequence,
preferably at both the SCSI and USB layers.  Then at least we'll know
exactly what the driver is doing.  Are there kernel options to do
this?

Unfortunately, I don't know any way to log what Windows is doing with
the drive.

Dale
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
