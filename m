From: berthiaume_wayne@emc.com
Subject: RE: saferawdevices - Avoiding device name inconsistency with raw
	devi ces
Date: Tue, 9 Jul 2002 08:34:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049BFCB0@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Gary_Lerhaupt@Dell.com
Cc: linux-scsi@vger.kernel.org

	This link keeps pushing me into a support registration screen. What
gives?

-----Original Message-----
From: Gary_Lerhaupt@Dell.com [mailto:Gary_Lerhaupt@Dell.com]
Sent: Monday, July 08, 2002 11:43 AM
To: linux-scsi@vger.kernel.org
Subject: saferawdevices - Avoiding device name inconsistency with raw
devi ces


saferawdevices available @
http://support.dell.com/us/en/filelib/download/index.asp?fileid=r45472

This is a replacement for the rawdevices System V initialization script
which grabs SCSI page83/page80 information from your devices and adds this
information to /etc/sysconfig/saferawdevices.  With these unique identifiers
placed with each raw -> block device mapping, user's can be assured that the
correct mapping will take place.  This can especially important when running
an Oracle database amongst other scenarios.  

In the event that your device names have changed, it will not allow the
mappings to occur and instead will prompt you to run a remap, where it will
attempt to determine the new names of your devices based off of the UUIDs in
the file.  This should serve as a decent band-aid until the whole device
consistency issue is firmly answered.  A man page is included with the RPM.

Gary Lerhaupt
ESG Linux Solutions
Dell Computer Corporation
(512) 728-1860

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
