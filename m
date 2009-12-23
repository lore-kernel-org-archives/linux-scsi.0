From: "Caspar Smit" <c.smit@truebit.nl>
Subject: mvsas: Disks detected in 'wrong' order.
Date: Wed, 23 Dec 2009 13:08:15 +0100 (CET)
Message-ID: <30140.87.210.74.220.1261570095.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:49754 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbZLWMIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2009 07:08:17 -0500
Received: from ns1.emsolutions.nl (www-data@localhost.localdomain [127.0.0.1])
	by ns1.emsolutions.nl (8.13.8/8.13.8/Debian-3) with ESMTP id nBNC8Fh2026206
	for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2009 13:08:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I was wondering if others have the same issue with the disk ordering of
the mvsas driver.

I use AOC-SASLP-MV8 Cards (Marvell 88SE6480 Controller)

When I boot my system, it is detecting disks in this order

Detecting Port 3
Detecting Port 2
Detecting Port 1
Detecting Port 0
Detecting Port 7
Detecting Port 6
Detecting Port 5
Detecting Port 4

In the summary it gives ID's to disks and says:

ID:0  Port:3
ID:1  Port:2
ID:2  Port:1
ID:3  Port:0
ID:4  Port:7
ID:5  Port:6
ID:6  Port:5
ID:7  Port:4

In linux /dev/sdb is in slot 3 (disk 4)
In linux /dev/sdc is in slot 2 (disk 3)
In linux /dev/sdd is in slot 1 (disk 2)
In linux /dev/sde is in slot 0 (disk 1)
In linux /dev/sdf is in slot 7 (disk 8)
In linux /dev/sdg is in slot 6 (disk 7)
In linux /dev/sdh is in slot 5 (disk 6)
In linux /dev/sdi is in slot 4 (disk 5)

Previous drivers I used (from scst and from supermicro) assigned /dev/sdb
to slot 0, sdc to slot 1, etc.. like it should.
With this driver it suddenly changed.

Kind regards,
Caspar Smit
