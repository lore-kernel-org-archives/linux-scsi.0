From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: g_NCR5380 - 2.6.0 -  problem with reloading module
Date: Fri, 9 Jan 2004 11:26:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040109112656.25313810.rddunlap@osdl.org>
References: <20040105224220.GA1168@nihil.tappe.netz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:5770 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263173AbUAIT3x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2004 14:29:53 -0500
In-Reply-To: <20040105224220.GA1168@nihil.tappe.netz>
List-Id: linux-scsi@vger.kernel.org
To: Kevin Tappe <kevin@zerodivide.de>
Cc: linux-scsi@vger.kernel.org

On Mon, 5 Jan 2004 23:42:20 +0100 Kevin Tappe <kevin@zerodivide.de> wrote:

| Hi,
| 
| i hope this is the right emailadress for my problem...
| 
| The first time I load the module g_NCR5380 everything works fine:
| scsi0 : interrupts not enabled. for better interactive performance,
| scsi0 : please jumper the board for a free IRQ.
| scsi0 : at port 0x280 interrupts disabled options CAN_QUEUE=16  
| 	CMD_PER_LUN=2 release=1 generic options
| 	AUTOPROBE_IRQ AUTOSENSE USLEEP, USLEEP_POLL=1 USLEEP_SLEEP=20 
| 	generic release=7
| scsi0 : Generic NCR5380/53C400 Driver
| 	   Vendor: UMAX      Model: Astra 1200S
| 		Rev: V2.9   Type:   Scanner ANSI SCSI revision: 02
| Attached scsi generic sg0 at scsi0, channel 0, id 5, lun 0,  type 6
| 
| I can't reload the module g_NCR5380 after an rmmod:
| 
| nihil:~# modprobe -v g_NCR5380
| insmod /lib/modules/2.6.0/kernel/drivers/scsi/g_NCR5380.ko ncr_irq=255
| ncr_addr=0x280 dtc_3181e=1
| FATAL: Error inserting g_NCR5380
| (/lib/modules/2.6.0/kernel/drivers/scsi/g_NCR53
| 80.ko): No such device
| 
| After a reboot everything is just fine again.
| I use a vanilla 2.6.0 kernel. Please let me know if you need any further
| information.

Hi,

Can you show that 'modprobe -v g_NCR5380' output for the first time
that the driver is loaded also?

What's in /proc/scsi/g_NCR5380 while the driver is loaded the first time?
and in /proc/ioports and /proc/iomem?
Also, the latter 2 files after the driver is removed.
and in /proc/scsi after the driver is removed.

--
~Randy
MOTD:  Always include version info.
