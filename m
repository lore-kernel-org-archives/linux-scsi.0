From: oliver@windfinder.com
Subject: Re: Raid1 on Dell Poweredge with Perc4e/Di Raid Controller runnin g Debian Sarge (3.1)
Date: Fri, 22 Apr 2005 21:07:49 +0200
Message-ID: <200504222107.50290.oliver@windfinder.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703662801@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.windfinder.de ([81.201.107.60]:23726 "HELO windfinder.com")
	by vger.kernel.org with SMTP id S262111AbVDVTIe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2005 15:08:34 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703662801@exa-atlanta>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>, aschultz@warp10.net, Matt_Domsch@dell.com, linux-poweredge@dell.com, linux-scsi@vger.kernel.org, Jonas Kaufmann <me@j0nes.de>, Thomas Glas <thomas.glas@hanse.net>, Sebastian Kamp <sebastian.kamp@ottogroup.com>

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
> > Oliver K=C3=B6nig
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
Oliver K=C3=B6nig

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
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
