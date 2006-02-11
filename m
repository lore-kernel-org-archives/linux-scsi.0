From: Fredrik Roubert <roubert@df.lth.se>
Subject: Error using DC315U to drive ScanJet 4c
Date: Sat, 11 Feb 2006 02:14:57 +0100
Message-ID: <20060211011457.GA1839@igloo.df.lth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from igloo.df.lth.se ([194.47.250.47]:30197 "EHLO df.lth.se")
	by vger.kernel.org with ESMTP id S932290AbWBKBPD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 20:15:03 -0500
Received: from igloo.df.lth.se (localhost [127.0.0.1])
	by df.lth.se (8.13.1/8.13.1) with ESMTP id k1B1EvNo002228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 11 Feb 2006 02:14:58 +0100 (CET)
Received: (from roubert@localhost)
	by igloo.df.lth.se (8.13.1/8.13.1/Submit) id k1B1EvIL002225
	for linux-scsi@vger.kernel.org; Sat, 11 Feb 2006 02:14:57 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I just connected my old HP ScanJet 4c to my new DC315U SCSI adapter
(connected to an ASRock 939Dual-SATA2 motherboard with AMD Athlon 64 X2=
)
and tried using the dc395x kernel module with Linux 2.6.15 and scan an
image using xscanimage.

Sometimes it works, but sometimes xscanimage hangs for a long time and
then aborts with a message about I/O error. When that happends, the
following is printed in the dmesg output:

drivers/scsi/dc395x.c: Please, contact <linux-scsi@vger.kernel.org> to =
help improve support for your system.
dc395x: reselect: w/o disconnected cmds <02-0>
dc395x: disconnect: Unexpected reselection <02-0>

So, what can I do to help you resolve this? (I'm familiar with kernel
programming, in case you need me to check something "complicated".)

Cheers // Fredrik Roubert

--=20
S=F6rbyplan 5       |  +46 8 7609169 / +46 708 776974
SE-163 71 Sp=E5nga  |  http://www.df.lth.se/~roubert/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
