From: berthiaume_wayne@emc.com
Subject: RE: QLA2200 driver
Date: Fri, 26 Apr 2002 09:09:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049BF95D@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: arun.mittal@qlogic.com
Cc: linux-scsi@vger.kernel.org, ttonino@corp.home.nl

	Arun, the problem is the qla2x00 driver never makes it out to the
Linux base so the community at large is not always aware of it or the need
to go to your website to obtain the correct driver for the QLA2200 and
QLA2300. BTW: It's nice to see you are out there and listening. =;^)

-----Original Message-----
From: Arun Mittal [mailto:arun.mittal@qlogic.com]
Sent: Thursday, April 25, 2002 2:15 PM
To: berthiaume_wayne@emc.com; ttonino@corp.home.nl
Cc: linux-scsi@vger.kernel.org
Subject: RE: QLA2200 driver


The 6.0beta20 driver
(http://www.qlogic.com/support/home_resources.asp?id=57) maintained by
QLogic (QLA2200 and QLA23xx) includes the changes made by Arjan in RH3
version + other robustness changes. Please download and use this driver.

Arun

-----Original Message-----
From: berthiaume_wayne@emc.com [mailto:berthiaume_wayne@emc.com]
Sent: Thursday, April 25, 2002 6:41 AM
To: ttonino@corp.home.nl
Cc: linux-scsi@vger.kernel.org
Subject: RE: QLA2200 driver


	The qla2x00 driver is not in the Linus tree; however, if you pull
down a Red Hat tree you'll find it is in there. QLogic maintains the driver
and, perhaps, just hasn't gotten around to submitting it to Marcello, Linus,
et al for inclusion in the LSB. Duane ol' buddy are you listening????  =;^)

-----Original Message-----
From: Thomas Tonino [mailto:ttonino@corp.home.nl]
Sent: Thursday, April 25, 2002 7:35 AM
To: linux-scsi@vger.kernel.org
Subject: QLA2200 driver


We're setting up a server with a 14 Seagate Cheetah fibre JBOD attached 
to a single QLA2200 controller.

The Qlogic fibre driver in 2.4.18 crashes very quickly in this setup, 
with the message "qlogicfc0 : no handle slots, this should not happen". 
This crash happens after writing less than 100GB of data to the JBODs.

I've seen that message before with an older drive and kernel (around 
2.4.5?) version. At the time, I observed the same problem while  syncing 
a software raid5.

I found Feral's GPL'd driver (available at ftp://ftp.feral.com/pub/isp/) 
to work correctly so far (~ 1 TB).

Is there a reason why Feral's driver is not in the kernel? Having a 
driver that is so non-functional is really bad, IMO.

Who is using the in-kernel driver without problems? Could a connection 
be made between the problem and, say, the number of drives, or the 
achieved throughput?


Thomas
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
