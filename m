From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.03
Date: Wed, 08 Jan 2003 22:46:14 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1C0F86.5000109@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-41.triode.net.au [202.147.125.41])
	by iggy.triode.net.au (8.12.7/8.12.7) with ESMTP id h08BhJQ0013397
	for <linux-scsi@vger.kernel.org>; Wed, 8 Jan 2003 22:43:20 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility the uses sysfs in kernels >= lk 2.5.50
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices).
Both a compact format (default), one line per device, and
a "classic" format (like the output of 'cat /proc/scsi/scsi')
are supported.

A '-g' switch has been added in version 0.03 to show the
corresponding scsi generic device name:

$ lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0105  /dev/sda
[2:0:0:0]    CDROM   CREATIVE CD5233E          1.00  /dev/sr0

$ lsscsi -g
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0105  /dev/sda  /dev/sg0
[2:0:0:0]    CDROM   CREATIVE CD5233E          1.00  /dev/sr0  /dev/sg1

Patrick Mansfield's patch to output the scsi_level in
"classic" mode is also included. The scsi_level is also
output with the '-l' switch. [Until Patrick's kernel
patch for sysfs to output scsi_level gets into the kernel,
the ANSI SCSI revision will appear as "?".]

See http://www.torque.net/scsi/lsscsi.html for more information
and downloads.

Doug Gilbert


