From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.39-rc3-git3 problem   etc , next problems
Date: Fri, 15 Apr 2011 21:06:38 -0400
Message-ID: <web-506064138@zbackend1.aha.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zfrontend2.aha.ru ([195.2.83.148]:56669 "EHLO zfrontend2.aha.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab1DPBGl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2011 21:06:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, randy.dunlap@oracle.com, Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>, gregkh@suse.de, tj@kernel.orgrandy.dunlap@oracl

With -git4 and the patchs you mailed me, it's more stable, 
but there happens the following problems:

1)  Ocasionally come kernel messages, as below

2)  All reported problems happens with the fbdev and vesa 
X11 drivers.  The nv driver don't start at all;  if I put 
nv in xorg.conf then typing in 'startx' it comes an error 
message that any kernel module is claiming the device, 
this should be freed.

3) There happen reboot-resistent crash problems.   After a 
crash, if I reboot, on an early stage of booting it crashs 
again, the error message ends with c2328066  i386_stat_ked 
 +0xb6/0cbd  .     After this come error messages like: 
  ata1: nv: skipping hardreset on occupied port , and 
messages that a device with 0 cyl/tracks/sect cannot be 
read.  This looks as the nv grafic card is wrongly 
interpreted as a SCSI device.   After several of such 
messages, it hangs.       After reboot and even after 
switch off the power, the same error continues. 
       Only if then I boot in another kernel, f.ex. 
2.6.38.3 it works normal, and then I can reboot again into 
2.6.39-rc3-git4, until it crashs again, then this 
reboot/power -resistent problem repeats.



Werner Landgraf

Linux SYS





===================================
  Message from syslogd@werner at Fri Apr 15 20:57:55 2011 
...
werner kernel: Stack:

  Message from syslogd@werner at Fri Apr 15 20:57:55 2011 
...
werner kernel: last sysfs file: 
/sys/devices/pci0000:00/0000:00:0d.0/boot_vga

  Message from syslogd@werner at Fri Apr 15 20:57:55 2011 
...
werner kernel: Process nmap (pid: 9346, ti=ee3c0000 
task=ee214e40 task.ti=ee3c0000)

  Message from syslogd@werner at Fri Apr 15 20:57:55 2011 
...
werner kernel: CR2: 0000000000000004

  Message from syslogd@werner at Fri Apr 15 20:57:55 2011 
...
werner kernel: EIP: [<c1cc1a86>] skb_dequeue+0x3c/0x51 
SS:ESP 0068:ee3c1eec

  Message from syslogd@werner at Fri Apr 15 20:57:55 2011 
...
werner kernel: Oops: 0002 [#1] SMP

  Message from syslogd@werner at Fri Apr 15 20:57:55 2011 
...
werner kernel: Call Trace:

  Message from syslogd@werner at Fri Apr 15 20:57:55 2011 
...
werner kernel: Code: f8 e8 cc a2 13 00 89 c1 8b 1e 39 f3 
75 04 31 db eb 1e 85 db 74 1a ff 4e 08 8b 13 8b 43 04 c7 
43 04 00 00 00 00 c7 03 00 00 00 00
---
Professional hosting for everyone - http://www.host.ru

