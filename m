From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.05
Date: Sun, 19 Jan 2003 10:41:02 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E29E60E.2000005@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-14.triode.net.au [202.147.125.14])
	by iggy.triode.net.au (8.12.7/8.12.7) with ESMTP id h0INeL3J008533
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2003 10:40:21 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility the uses sysfs in kernels >= lk 2.5.50
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices).
Both a compact format (default), one line per device, and
a "classic" format (like the output of 'cat /proc/scsi/scsi')
are supported.

Version 0.05 is available at
http://www.torque.net/scsi/lsscsi.html

This version adds st and osst device names:

# lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0105  /dev/sda
[2:0:0:0]    CDROM   CREATIVE CD5233E          1.00  /dev/sr0
[3:0:6:0]    tape    SONY     SDT-7000         0192  /dev/st0

In the previous version "-" was output rather than "/dev/st0".
There are some minor formatting clean ups in this version.

Doug Gilbert

