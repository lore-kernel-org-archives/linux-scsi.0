From: Simen Thoresen <simentt@dolphinics.no>
Subject: Multiple device (in raid) persistant naming - best practices?
Date: Thu, 19 Oct 2006 17:07:39 +0200
Message-ID: <453794BB.9080406@dolphinics.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [81.175.23.36] ([81.175.23.36]:23272 "EHLO poesci.dolphinics.no")
	by vger.kernel.org with ESMTP id S1161439AbWJSPHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 11:07:38 -0400
Received: from [192.168.1.14] (unknown [84.210.208.151])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by poesci.dolphinics.no (Postfix) with ESMTP id BA4C2B499A
	for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2006 17:07:37 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I'm trying to wrap my mind around how to figure out which of several (in a 
raid set) disks is which physical disk.

How is this done these days?

My constraints;
-My filesystem is on /dev/mdX, so I cannot easily assign a label to a single 
disk without playing with micro-partitions on the disks
-My BIOS/kernel/controllers play reordering games on me. I'm pretty sure the 
disks have moved around, and my boot-disks that started out as /dev/sda and 
/dev/sdb (ports 0 and 1 on my NForce4 SATA-controller) are now sdc and sdd. 
I think both kernel-updates and BIOS-updates may have changed the order, but 
I'm not sure about either.
-My disks do not display activity thru leds, nor are they noisy enough that 
a dd from any one of them will be discernible over the rest of them.
-I did not note down which serial-numbers are attached to which disk, altho 
I know hdparm -I reports them. I was not able to coax serial-numbers from 
udevinfo.

I'm running an RHEL4-based system (2.6.9 with a truckload of vendor 
patches), but I'm wondering if there are any neat udev-hacks or similar that 
make matching /dev/sdX -devics with the drives possible.

Thank you for all replies.

Yours,
-S
-- 
Simen Thoresen, Dolphin ICS
