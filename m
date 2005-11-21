From: Douglas Gilbert <dougg@torque.net>
Subject: [ANNOUNCE] sdparm 0.96
Date: Mon, 21 Nov 2005 11:42:30 +1000
Message-ID: <43812606.6030803@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932164AbVKUBlV@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tomfa@debian.org, kumba@gentoo.org
List-Id: linux-scsi@vger.kernel.org

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). Apart
from SCSI devices (e.g. disks, tapes and enclosures) sdparm
can be used on any device that uses a SCSI command set.
Virtually all CD/DVD drives use the SCSI MMC set irrespective
of the transport. sdparm also can decode VPD pages including
the device identification page. Commands to start and stop
the media; load and unload removable media and some other
housekeeping functions are supported. sdparm can be used in
both the lk 2.4 and 2.6 series.

This release adds 'capacity', 'sense' and 'sync' commands.
Change '-ll' to add explanation of some complex mode page
field values.

For more information and downloads see:
http://www.torque.net/sg/sdparm.html

Changelog:
http://www.torque.net/sg/p/sdparm.ChangeLog


Doug Gilbert
