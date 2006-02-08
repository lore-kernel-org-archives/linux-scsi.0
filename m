From: "Todd Reichert" <Todd.Reichert@dothill.com>
Subject: Add/Remove single device
Date: Wed, 8 Feb 2006 13:24:01 -0800
Message-ID: <55E9A7FDB6C7B540930C9426790BBC4E09068B@earthex3.power.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 17.129.dothill.com ([155.254.129.17]:49430 "EHLO
	earthex1.power.com") by vger.kernel.org with ESMTP id S965023AbWBHVYD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 16:24:03 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

It appears that the operations of 'add single device' and 'remove single
device' via the procfs are no longer available/provided by some HBA
drivers in the 2. 6 kernel.  Is there some equivalent function to cause
re-instancaion of devices for a specific bus and or HBA?

 

I work on a unit test program wherein a RAID controller appears on a bus
as target 0, lun 0, device type 3 or 13 with an sg path, but when a
logical drive is created it is now target 0, lun 0 with a logical drive
ID.  In most cases, a 2.6 kernel does not seem to see this target lun
with an appropriate '/dev/sdX' path and device type 0.

 

Should I expect that issuing an ioctl SG_SCSI_RESET for the host, bus or
device to the initial sg path accomplish what I need?

 

Thanks in advance for any input.

 

Todd Reichert
