From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.07 + scsi host information?
Date: Fri, 14 Feb 2003 09:43:58 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E4C1FAE.2090904@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-52.triode.net.au [202.147.125.52])
	by iggy.triode.net.au (8.12.7/8.12.7) with ESMTP id h1DMfSN0017795
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2003 09:41:28 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility the uses sysfs in kernels >= lk 2.5.50
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices).
Both a compact format (default), one line per device, and
a "classic" format (like the output of 'cat /proc/scsi/scsi')
are supported.

Version 0.07 is available at
http://www.torque.net/scsi/lsscsi.html

In lk 2.5.60 the prefix to the "queue_depth" sysfs name
was removed.



I would like lsscsi to list SCSI hosts (portals?) but there
doesn't seem to be enough normalized sysfs information
available to do that. Is the "/sys/class/scsi-host" sub-tree
the place to be looking? Of the scsi hosts I have, only
scsi_debug (thanks to work by Mike Anderson) puts an
entry in that sub-tree. I would also like to have normalized
information from the scsi_host structure available (similar
to what Patrick Mansfield provided for scsi devices).


Doug Gilbert

