From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: MPTSAS: ("activate status led" | "find disc") in external
 enclosure
Date: Tue, 22 Apr 2008 09:18:37 +0200
Message-ID: <20080422091837.12790125.taeuber@bbaw.de>
References: <20080418124104.9ca87130.taeuber@bbaw.de>
	<1208528945.3063.7.camel@localhost.localdomain>
	<20080421110148.1918485e.taeuber@bbaw.de>
	<1208791005.3640.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:59513 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbYDVHRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Apr 2008 03:17:25 -0400
In-Reply-To: <1208791005.3640.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> schrieb:
> On Mon, 2008-04-21 at 11:01 +0200, Lars T=C3=A4uber wrote:
> > # ls /sys/class/enclosure/*/
> > /sys/class/enclosure/6:0:16:0/:
> > 0  10  12  14  2  4  6  8  components  subsystem
> > 1  11  13  15  3  5  7  9  device      uevent
> >=20
> > /sys/class/enclosure/6:0:33:0/:
> > 0  10  12  14  2  4  6  8  components  subsystem
> > 1  11  13  15  3  5  7  9  device      uevent
> >=20
> > This is two times the same enclosure.
>=20
> That's unusual .. to have two devices managing the same enclosure, bu=
t
> if you only have 16 slots and not 32, I suppose it must be so.

I use both external connections to both expanderboards of the enclosure=
 just for redundancy.


> > monosan:/sys/class/enclosure/6:0:16:0/0 # ls -l
> > insgesamt 0
> > -rw-r--r-- 1 root root 4096 21. Apr 10:48 active
> > -rw-r--r-- 1 root root 4096 21. Apr 10:48 fault
> > -rw-r--r-- 1 root root 4096 21. Apr 10:48 locate
> > -rw-r--r-- 1 root root 4096 21. Apr 10:48 status
> > lrwxrwxrwx 1 root root    0 21. Apr 10:46 subsystem -> ../../../enc=
losure_component
> > -r--r--r-- 1 root root 4096 21. Apr 10:48 type
> > --w------- 1 root root 4096 21. Apr 10:48 uevent
> >=20
> > There seems to be no device link if I understood you correctly.
> > Is the subdirctory numbering somehow in relation to the SCSI ID?
>=20
> If the slot is populated a device link should appear (this
> is the tricky bit because the ses driver uses VPD inquiries to match =
up
> the reported disk, assuming the enclosure reports it, to the actual o=
ne.
> These work for SAS disks, but not for SATA ones).

So this will never work for the SATA discs in our enclosure, right? Or =
is there a chance with asking LSI to do something in their firmware?

Seems I have no chance to get to know which slot contains the failed dr=
ive without a shutdown. Bad luck.

But thanks alot anyway.
Best regards
Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
