From: Douglas Gilbert <dougg@torque.net>
Subject: [2.6.0-test4] blocking access to mounted scsi devices
Date: Mon, 25 Aug 2003 17:04:53 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F49B515.6010107@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:33712 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S261484AbTHYHGE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 03:06:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ballen@gravity.phys.uwm.edu

A recent test of smartmontools on lk 2.6.0-test4 failed
miserably on my main SCSI disk. It would seem that
attempts to use either the:
    SCSI_IOCTL_SEND_COMMAND
    SG_IO
ioctls on a mounted SCSI "block" device fail with EBUSY.
These ioctls work fine on devices that don't have mounted
file systems on then. If this is a new policy then it needs
to be reconsidered. smartmontools still works ok on ATA disks
in lk 2.6.0-test4.

Both the ioctls in question still work via the corresponding
scsi generic device. Will scsi generic devices make a
re-appearance in sysfs (as indicated by Christoph when the
relevant code in sg was removed)?

Doug Gilbert

