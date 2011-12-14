From: Axel Theilmann <theilmann@pre-sense.de>
Subject: status of oops in sd_revalidate_disk?
Date: Wed, 14 Dec 2011 18:59:53 +0100
Message-ID: <4EE8E419.8010000@pre-sense.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.pre-sense.de ([213.238.39.107]:54130 "EHLO
	mail.pre-sense.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab1LNSIN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2011 13:08:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: huajun.li.lee@gmail.com, jbottomley@parallels.com, stefanr@s5r6.in-berlin.de



hi,

two weeks ago Huajun Li posted a patch for a kernel oops, subject [PATC=
H]
SCSI/sd: Fix NULL dereference in sd_revalidate_disk".

The patch was discussed but considered "clearly wrong". The bug shows u=
p for
us in kernel 3.1.4 quite often when unplugging usb sticks and it seems =
a few
other people have the same problem:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/859199
https://bugzilla.redhat.com/show_bug.cgi?id=3D754518
https://bugzilla.novell.com/show_bug.cgi?id=3D722350
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D649735

Can anyone of you maybe give me any status update on that bug?

Thanks

tty, axel


--=20
Dipl.-Inform. Axel Theilmann             theilmann@pre-sense.de
                               Tel.  (+49) 040  / 244 2407 - 13
                               Fax   (+49) 040  / 244 2407 - 24
                               Mobil (+49) 0151 / 116 18 664
PRESENSE Technologies GmbH         Sachsenstr. 5, 20097 Hamburg
                                         USt-IdNr.: DE263765024
Gesch=E4ftsf=FChrer/Managing Directors       AG Hamburg, HRB 107844
Till D=F6rges           J=FCrgen Sander              Axel Theilmann
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
