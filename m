From: Madison Kelly <linux@alteeve.com>
Subject: Rescanning a usb-mounted fs causes scsi device address to change
Date: Tue, 13 Jul 2004 17:28:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F453E3.2050308@alteeve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [209.167.86.38] ([209.167.86.38]:35725 "EHLO srv1.alteeve.com")
	by vger.kernel.org with ESMTP id S265946AbUGMV1r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 17:27:47 -0400
Received: from alteeve.com (nabiki.thelinuxexperience.com [209.167.86.34])
	by srv1.alteeve.com (8.12.10/8.12.10) with ESMTP id i6DKWVop024945
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2004 16:32:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello all!

   This is my first post to the list so let me appologise if I am 
missing something obvious.

   I am writting a perl program that backs up data to a USB2/Firewire 
connected hard drives. I've been writting it under Fedora Core 1 and 2 
and I use Kurt Garloff's 'rescan SCSI bus' script. What I have found is 
that if a usb-connected partition (say at '/dev/sda1') is mounted and 
the rescan script is run (via 'sudo' with the '-r' remove switch) the 
device shifts to '/dev/sdb1' instead of being ignored. This obviously 
breaks any mounts and associated bad stuff (tm) happens.

   I am an amature programmer so again I worry that I am missing 
something obvious. I've been reading as much as I can on the 'scsi 
add|remove-single-device w x y z > /proc/scsi/scsi' call but there seems 
to be very little documentation on how these calls work. If someone 
doesn't know what's happening but can point me at something that might 
help be figure this out that would be greatly appreciated, too.

   In case it helps, I am currently developing this on an IBM thinkpad 
a22m (Intel 440BX/P3 1GHz) machine with an ALI USB2/Firewire PCMCIA card 
and an external USB2->IDE carrier that uses removable 3.5" IDE trays 
(poor person's hot-swap). If any other info/specs will help I'll be glad 
to pass them along.

   Thank you in advance!

Madison
