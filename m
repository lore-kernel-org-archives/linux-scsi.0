From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Subject: ESP SCSI and QLGC,ISP SCSI drivers not finding attached devices
Date: Fri, 20 Jul 2007 14:26:24 +0100 (BST)
Message-ID: <Pine.LNX.4.61.0707201404250.7470@mtfhpc.demon.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: davem@davemloft.net, Janmes.Bottomley@SteelEye.com
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi All,

I have been having intermittant issues with the QLGC,isp driver 
(qlogicpti.c) not finding any attached devices on my sun4c. Having now 
moved on to Linux-2.6.22 this problem is now also affecting the ESP SCSI 
driver and is nolonger intermittant.

My test setup uses an NFS root so it is currently independent of the SCSI 
drivers/subsystem. I am hoping to change this in the near future so that 
my sun4c boots into linux by default.

What kernel options can I use to try to work out why the drivers are 
ignoring disks (there are no other types of attached device at present). 
Are any special options needed to force the scsi subsystem to spin the 
disk up and wait untill they become ready (The disk [target 0:0:3] on the 
ESP auto-spins down if it is idle for too long and now that booting takes 
longer ...) ?

Is there a way to get a NON-moduler scsi driver to re-scan its SCSI bus 
from shell prompt (writing to a sysfs/procfs file)?

>From my point of view, it looks like the command timeout is very much too 
short. Is there a simple way of testing this theory on the ESP driver?

Regards
 	Mark Fortescue.
