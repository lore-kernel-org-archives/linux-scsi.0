From: Douglas Gilbert <dougg@torque.net>
Subject: [ANNOUNCE] sdparm 0.94
Date: Thu, 28 Jul 2005 23:35:02 +1000
Message-ID: <42E8DF06.50201@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:14212 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261378AbVG1Nem (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jul 2005 09:34:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). Apart
from SCSI devices (e.g. disks, tapes and enclosures) sdparm
can be used on any device that uses a SCSI command set.
Virtually all CD/DVD drives use the SCSI MMC set irrespective
of the transport. sdparm also can list VPD pages including
the device identification page. sdparm can be used in both
the lk 2.4 and 2.6 series.

The major addition in version 0.94 is a set of commands
mainly for devices with removable media: eject, load,
ready, start, stop and unlock.

For more information and downloads see:
http://www.torque.net/sg/sdparm.html

ChangeLog for sdparm-0.94 [20050728]
   - add CD/DVD (MM) capabilities and mechanical status mode page
   - add Background medium scan (SBC-2 pending) mode subpage
   - add '--command=<cmd>' option with these <cmd>s:
       ready, start, stop, load, eject and unlock
   - add decoding for SCSI Ports VPD page
   - updated to automake version 1.9.5
   - copy of sdparm.html placed in doc directory


Doug Gilbert
