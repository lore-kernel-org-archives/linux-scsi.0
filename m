From: "Ionut Nistor" <ionut@modulo.ro>
Subject: Re: Support for lun > 7 on HP's XP128 storage
Date: Fri, 20 Jun 2003 14:08:19 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <00e901c3371c$42117c40$0cc7e7c1@EEL>
References: <004a01c33561$1c3cc3b0$6e51960a@EEL>        <1055942750.8263.10.camel@lvadplx> <1562.193.231.199.62.1055959426.squirrel@mail.wsp.ro>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.wsp.ro ([193.231.199.126]:6571 "EHLO www.wsp.ro")
	by vger.kernel.org with ESMTP id S262872AbTFTK41 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 06:56:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: Ionut Nistor <ionut@wsp.ro>, andrew@fc.hp.com
Cc: linux-scsi@vger.kernel.org

Sorry for being coming back on the same issue but should this (blacklisting
for XP) not be included in the kernel?

Thanks,
Ionut

----- Original Message ----- 
From: "Ionut Nistor" <ionut@wsp.ro>
To: <andrew@fc.hp.com>
Cc: <ionut@modulo.ro>
Sent: Wednesday, June 18, 2003 9:03 PM
Subject: Re: Support for lun > 7 on HP's XP128 storage


> Hello Andrew,
>
> I know this, but I was hoping this gets included in the kernel's blacklist
> - should be since this is how XP works.
>
> By the way, do you happen to know why XP reports SCSI ver 2 but allows
> more than 8 LUNs? This sort of breaks the standard.
>
> Thanks,
> Ionut
>
> > On Wed, 2003-06-18 at 00:16, Ionut Nistor wrote:
> >> Hello,
> >>
> >> I am running a 2.4.18-ac3 kernel on a ia32 system.
> >> This system is connected to a SAN via an Emulex LP8000 HBA. The
> >> storage is HP's XP128. The controller on the storage reports scsi
> >> version 2 however, luns with ID > 7 are also supported. When the HBA
> >> driver is loaded, no LUNs are detected but if "scsi add-single-device"
> >> is used later, the luns are visible.
> >>
> >> Maybe it should be added to the kernel with BLIST_LARGELUN - correct
> >> me if I am wrong.
> >>
> >> Thanks,
> >> Ionut
> >>
> >
> > Try adding the following entries to the device_list in scsi_scan.c:
> >
> > {"HP", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> > {"HP", "DISK-SUBSYSTEM", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> >
> >
> >
> >> -
> >> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> >> in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > --
> > =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> >    Andrew Patterson                          Voice:  (970) 898-3261
> > Hewlett-Packard Company                   Email:  andrew@fc.hp.com
>
>
>
>

