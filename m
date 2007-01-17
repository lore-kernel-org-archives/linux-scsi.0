From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Tue, 16 Jan 2007 20:50:43 -0500
Message-ID: <45AD80F3.6020100@torque.net>
References: <45ACA765.3030701@aboo.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53415 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbXAQBuy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jan 2007 20:50:54 -0500
In-Reply-To: <45ACA765.3030701@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: linux-scsi@vger.kernel.org

Aboo Valappil wrote:
> Hi All,
>=20
> I have tried this before but I guess I was unsuccessful in presenting=
 it
> properly in the mailing list. I think it is really useful especially =
for
> prototyping and also for people who wants to develop their own scsi
> targets and transports.
> There are few people told me about the SCSI target and initiator
> implementation of XEN. But I do not think it is this simple and might
> take a while to port it to normal linux kernel.  At the moment, there=
 is
> nothing like this available in a simplest form.
>=20
> Please visit this site http://vscsihba.aboo.org. I put a complete
> description of the project and the source code. I appreciate if you
> could go through it and put your thoughts....  This is my final attem=
pt
> in this mailing list before I throw away whole of my work.

Throwing it away sounds a bit drastic. It tooks me a
while finding the tarball on your site. Perhaps you
could put it in a table under a "Downloads" section.
The table would be for different versions as it looks
like you may need a new one for bleeding edge kernels.

I didn't get far trying to build the kernel module
against lk 2.6.20-rc5:

# make
make -C /lib/modules/2.6.20-rc5/build M=3D/home/upgrades/apps/vscsihba1=
/vscsihba1/kernel modules
make[1]: Entering directory `/usr/src/linux-2.6.19'
  CC [M]  /home/upgrades/apps/vscsihba1/vscsihba1/kernel/hba.o
/home/upgrades/apps/vscsihba1/vscsihba1/kernel/hba.c:26: warning: =91km=
em_cache_t=92 is deprecated
  CC [M]  /home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.o
/home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.c:263:51: error: =
macro "INIT_WORK" passed 3 arguments, but takes just 2
/home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.c: In function =91=
scsitap_ctl_ioctl=92:
/home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.c:263: error: =91=
INIT_WORK=92 undeclared (first use in this function)
/home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.c:263: error: (Ea=
ch undeclared identifier is reported only once
/home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.c:263: error: for=
 each function it appears in.)
make[2]: *** [/home/upgrades/apps/vscsihba1/vscsihba1/kernel/device.o] =
Error 1
make[1]: *** [_module_/home/upgrades/apps/vscsihba1/vscsihba1/kernel] E=
rror 2
make[1]: Leaving directory `/usr/src/linux-2.6.19'
make: *** [modules] Error 2

Doug Gilbert


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
