From: Jure =?UTF-8?B?UGXEjWFy?= <pegasus@telemach.net>
Subject: qlogicisp error handling
Date: Sat, 28 Feb 2004 11:29:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040228112925.50ce14ff.pegasus@telemach.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pegasus.siol.net ([193.189.160.25]:62933 "EHLO pegasus.siol.net")
	by vger.kernel.org with ESMTP id S261270AbUB1K31 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2004 05:29:27 -0500
Received: from kudu.siol.net ([10.10.10.22]) by pegasus.siol.net
          (InterMail vK.4.03.05.03 201-232-132-103 license 1cbf71897a39210db31154c99f0b4628)
          with ESMTP id <20040228102925.WRAC15612.pegasus@kudu.siol.net>
          for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2004 11:29:25 +0100
Received: from open.pecar.org ([193.95.219.68]) by kudu.siol.net
          (InterMail vK.4.03.05.03 201-232-132-103 license 1cbf71897a39210db31154c99f0b4628)
          with SMTP id <20040228102925.TTAG1595.kudu@open.pecar.org>
          for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2004 11:29:25 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi all,

qlogicisp module on my alphaserver spits this out on 2.6.3-mm1:

ERROR: SCSI host `isp1020' has no error handling
ERROR: This is not a safe way to run your SCSI host
ERROR: The error handling must be added to this driver
fffffc00001f7da8 0000000000000003 fffffc000048b640 fffffc0000685030=20
       fffffc0000685030 fffffc001bf7b800 fffffc0000685030 fffffc001bd7d=
400=20
       fffffc0000000000 fffffc00001f7df0 fffffc00001f7df0 fffffc001bf7b=
800=20
       fffffc00004c0007 fffffc0000685030 fffffc00004c2bac fffffc0000685=
030=20
       0000000000000000 0000000000000000 fffffc0000603308 fffffc0000685=
030=20
       0000000000000000 fffffc0000685108 fffffc000060e400 fffffc000057e=
400=20
Trace:fffffc000048b640 fffffc00004c0007 fffffc00004c2bac fffffc00003101=
9c
fffffc0000315408=20

It looks to me that the error handling is not yet imlemented in this dr=
iver.

How much work is this? Can a kernel hacker wannabe like me do this? Any
pointers?

Thanks,


--=20

Jure Pe=C4=8Dar
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
