From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: MPTSAS: ("activate status led" | "find disc") in external
 enclosure
Date: Wed, 23 Apr 2008 10:11:43 +0200
Message-ID: <20080423101143.d1fa10d0.taeuber@bbaw.de>
References: <20080422091837.12790125.taeuber@bbaw.de>
	<0631C836DBF79F42B5A60C8C8D4E8229FFECC9@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:57129 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYDWIKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Apr 2008 04:10:25 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229FFECC9@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

Hallo Eric,

"Moore, Eric" <Eric.Moore@lsi.com> schrieb:
> On Tuesday, April 22, 2008 1:19 AM, Lars T=C3=A4uber wrote: =20
>=20
> > So this will never work for the SATA discs in our enclosure,=20
> > right? Or is there a chance with asking LSI to do something=20
> > in their firmware?
> >=20
> > Seems I have no chance to get to know which slot contains the=20
> > failed drive without a shutdown. Bad luck.
> >=20
>=20
> If you want to upgrade your controller fw, I need the contents of all=
 the attributes in /sys/class/scsi_host/host#.  Just yesterday we got W=
arner Wakko upgraded, and I believe it might of solved his problems.   =
I'm not sure what problems your experiencing, as this thread has been h=
ard to follow.

I hoped I had the newet version of the firmware on the HBA.
monosan:~ # cat /sys/class/scsi_host/host6/version_fw=20
01.24.01.00
monosan:~ # cat /sys/class/scsi_host/host6/version_mpi=20
105
monosan:~ # cat /sys/class/scsi_host/host6/version_nvdata_default=20
2d02h
monosan:~ # cat /sys/class/scsi_host/host6/version_nvdata_persistent=20
2d02h
monosan:~ # cat /sys/class/scsi_host/host6/version_product=20
LSISAS1068 B1
monosan:~ # cat /sys/class/scsi_host/host6/board_name=20
SAS3801X


> I would like to point out there is a firmware request for sending SEP=
 request, for instance setting LEDS.   Here is a copy of the structure.=
  We call this function to set LED when there is SMART errors (for non-=
raid devices).  For RAID, the firmware handles it.   Is this what your =
looking for?

I'm not firm enough with scsi to understand all your words. But the pro=
blem I have is not that something doesn't work. It works with 2.6.25.
I can get the LEDs to blink. I can choose which one should do. I simply=
 don't know which one it should be.

The problem is, I wanted to simultate a faulty drive without being one =
faulty.
Therefore I choosed a (working) disk to be faulty by its mutlipath-name=
: dm-9
Then I found out which disk it is in sd? notation. Then I read the seri=
al number of this disk with the smartmontools.
Now I want this LED of the bay containing the disk with this serial num=
ber to blink. But I can't find out which LED matches which serial numbe=
r of the containing disk.

I know my english is not the best. Ask and I try to explain again.

Regards
Lars

--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
