From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: Mount by WWN (FC, using qlogic 2200)
Date: Wed, 4 Feb 2004 20:58:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF21001894.F77A2C4A-ONC1256E30.006C8B35-C1256E30.006E2DB9@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:6784 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S263880AbUBDT6j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2004 14:58:39 -0500
List-Id: linux-scsi@vger.kernel.org
To: "Robert J. Adams (jason)" <radams@siscom.net>
Cc: EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>






Hi,

> > Which path would you expect to mount by specifying the WWID ?
>
> In Solaris it's possible to tie down a particular WWN to a device,
> otherwise the device my be detected at a different point at the next
> boot (thus get assigned a different /dev/sdX). Is this possible w/ Li=
nux?

As there might be several paths to a device identified by a WWPN
in the form of 2 or more host bus adapters connecting to that WWPN,
don't you want to mount an FCP device by
<adapter identifier> + <WWPN> + <FCP_LUN> ?

There has been a discussion about how to represent such
device attributes in sysfs. If udev acknowledged these attributes
and created proper devices nodes, then you could safely
mount your FCP devices.

If multipathing support matters, then you want your favourite mp soluti=
on
to lay claim to the SCSI device node identified as above and
provide another device node, which might then have any convenient
name.

That's my theory...

Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


"Robert J. Adams (jason)" <radams@siscom.net>@vger.kernel.org on 04/02/=
2004
19:39:22

Sent by:    linux-scsi-owner@vger.kernel.org


To:    EXT / DEVOTEAM VAROQUI Christophe <ext.devoteam.varoqui@sncf.fr>
cc:    "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Subject:    Re: Mount by WWN (FC, using qlogic 2200)


EXT / DEVOTEAM VAROQUI Christophe wrote:

> Which path would you expect to mount by specifying the WWID ?

In Solaris it's possible to tie down a particular WWN to a device,
otherwise the device my be detected at a different point at the next
boot (thus get assigned a different /dev/sdX). Is this possible w/ Linu=
x?

Thanks,
jason
NH
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
