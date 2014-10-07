From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: cciss module doesn't create subdevices on boot
Date: Tue, 7 Oct 2014 10:58:18 +0200
Message-ID: <20141007085818.GA810@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.apartia.fr ([178.63.80.89]:50292 "EHLO mail.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaJGJHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 05:07:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

When booting the latest grml on an HP Proliant blade the cciss module
doesn't create subdevices representing disk partitions. I only see main
devices for the two disks:

/dev/cciss/c0d0
/dev/cciss/c0d1

Once I run both of these devices through a "fdisk <device>" with only the
"w" (write) command then subdevices appear:

/dev/cciss/c0d0p1
/dev/cciss/c0d0p2
/dev/cciss/c0d1p1
/dev/cciss/c0d1p2

The strange thing is that these partitions are detected on boot as "p1
p2" and displayed in front of each disk's device name when loading the
cciss module but no actual /dev/cciss/c0d[01]p[12] appear.

This is with 3.13 and 3.16.2 kernels.

Thanks in advance for any idea,
