From: "Dennis Ruzeski" <dennisr@corp.kanoodle.com>
Subject: RE: Raid1 on Dell Poweredge with Perc4e/Di Raid Controller runnin gDebian Sarge (3.1)
Date: Fri, 22 Apr 2005 15:14:16 -0400
Message-ID: <B12F824A463BE441AB91C9AF3582F6BE02A41F@KAN-MAIL.corp.kanoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.corp.kanoodle.com ([208.247.105.190]:18828 "EHLO
	mail.corp.kanoodle.com") by vger.kernel.org with ESMTP
	id S262113AbVDVTO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2005 15:14:29 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: oliver@windfinder.com, "Ju, Seokmann" <sju@lsil.com>, aschultz@warp10.net, Matt_Domsch@dell.com, linux-poweredge@dell.com, linux-scsi@vger.kernel.org, Jonas Kaufmann <me@j0nes.de>, Thomas Glas <thomas.glas@hanse.net>, Sebastian Kamp <sebastian.kamp@ottogroup.com>

=46or that you'll need to edit /etc/modules.conf and change the megarai=
d2 entry to megaraid_mbox. Also, make sure you have the latest version =
of mkinitrd (to recognize the .ko module extension).

Good luck,=20
Dennis



-----Original Message-----
=46rom: linux-poweredge-bounces@dell.com [mailto:linux-poweredge-bounce=
s@dell.com] On Behalf Of oliver@windfinder.com
Sent: Friday, April 22, 2005 3:08 PM
To: Ju, Seokmann; aschultz@warp10.net; Matt_Domsch@dell.com; linux-powe=
redge@dell.com; linux-scsi@vger.kernel.org; Jonas Kaufmann; Thomas Glas=
; Sebastian Kamp
Subject: Re: Raid1 on Dell Poweredge with Perc4e/Di Raid Controller run=
nin gDebian Sarge (3.1)

Hello Ju,
thanks for your help. I am a total newbie but I managed to compile a ne=
w=20
kernel with your patch:

/boot/vmlinuz-2.6.8-1

Then I did:
server:/boot # mkinitrd -o /boot/initrd.img-2.6.8-1 2.6.8-1
=46atal: Module megaraid2 not found.
Warning: This failure MAY indicate that your kernel will not boot!=20
but it can also be triggered by needed modules being compiled into the =
kernel.

Does this mean, that you patch is not working or did I make a mistake?

Best regards,
Oliver



On Friday 22 April 2005 15:30, you wrote:
> On Thursday, April 21, 2005 4:31 AM, Oliver wrote,
>
> > Is there a megaraid driver for the 2.6.8 kernel? If so, where?
>
> Try attached. It has driver source with one patch file (2.6.8-24.patc=
h).
> Please make sure to apply the patch before compile.
>
> Thank you.
>
> > -----Original Message-----
> > From: oliver@windfinder.com [mailto:oliver@windfinder.com]
> > Sent: Thursday, April 21, 2005 4:31 AM
> > To: Matt_Domsch@dell.com; linux-poweredge@dell.com;
> > linux-scsi@vger.kernel.org
> > Cc: Thomas Glas
> > Subject: Raid1 on Dell Poweredge with Perc4e/Di Raid
> > Controller running Debian Sarge (3.1)
> >
> > Hello,
> > I would like to use Raid1 on the Dell Poweredge with
> > Perc4e/Di Raid Controller
> > and two 2 73 GB drives running Debian Sarge (3.1).
> >
> > At http://linux.dell.com/storage.shtml I read that the
> > Powerege 2850 Perc4e/Di
> > requires megaraid2 driver 2.00.3 or higher on 2.4.x kernel.
> > On 2.6.x kernels
> > (x < 9) there is no driver for these adapters. On 2.6.x (x >=3D
> > 9) use the
> > 'megaraid_mbox' and 'megaraid_mm' drivers.
> >
> > Problem: The Debian Installers offers only to install:
> >
> > - 2.4.x (which seems to be okay for the raid) OR
> > - 2.6.8 (which would not allow the use of the Raid)
> >
> > Solution:
> > Is there a megaraid driver for the 2.6.8 kernel? If so, where?
> >
> > If not, should I use 2.4.x kernel or try to install a 2.6.9
> > kernel on Debian
> > Sarge?
> >
> > --
> > Oliver K=F6nig
> >
> > Windfinder.com
> > Knorrstr. 24 Hinterhaus
> > 24106 Kiel
> > Germany
> > phone +49 431-8008643
> > VoIP +49 1801-7775558229
> > fax +49 431-8008644
> > Mobile +49 177-4933362
> > oliver@windfinder.com
> > www.windfinder.com
> > -
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Oliver K=F6nig

Windfinder.com
Knorrstr. 24 Hinterhaus
24106 Kiel
Germany
phone +49 431-8008643
VoIP +49 1801-7775558229
fax +49 431-8008644
Mobile +49 177-4933362
oliver@windfinder.com
www.windfinder.com

_______________________________________________
Linux-PowerEdge mailing list
Linux-PowerEdge@dell.com
http://lists.us.dell.com/mailman/listinfo/linux-poweredge
Please read the FAQ at http://lists.us.dell.com/faq
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
