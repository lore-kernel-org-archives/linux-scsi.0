From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.06
Date: Mon, 20 Jan 2003 08:09:43 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2B1417.6090606@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-85.triode.net.au [202.147.125.85])
	by iggy.triode.net.au (8.12.7/8.12.7) with ESMTP id h0JL8u3J027011
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2003 08:08:57 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility the uses sysfs in kernels >= lk 2.5.50
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices).
Both a compact format (default), one line per device, and
a "classic" format (like the output of 'cat /proc/scsi/scsi')
are supported.

Version 0.06 is available at
http://www.torque.net/scsi/lsscsi.html

Previous version didn't properly deal with osst devices.


Doug Gilbert

