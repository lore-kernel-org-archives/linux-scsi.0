From: Gary_Lerhaupt@Dell.com
Subject: saferawdevices - Avoiding device name inconsistency with raw
 devi ces
Date: Mon, 8 Jul 2002 10:43:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F44891A593A6DE4B99FDCB7CC537BBBB18A17A@AUSXMPS308.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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

