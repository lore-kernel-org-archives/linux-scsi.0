From: Kevin Tappe <kevin@zerodivide.de>
Subject: g_NCR5380 - 2.6.0 -  problem with reloading module
Date: Mon, 5 Jan 2004 23:42:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040105224220.GA1168@nihil.tappe.netz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:9102 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265992AbUAEWmV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2004 17:42:21 -0500
Received: from kevin by nihil.tappe.netz with local (Exim 3.35 #1 (Debian))
	id 1AddQS-0000K1-00
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2004 23:42:20 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

i hope this is the right emailadress for my problem...

The first time I load the module g_NCR5380 everything works fine:
scsi0 : interrupts not enabled. for better interactive performance,
scsi0 : please jumper the board for a free IRQ.
scsi0 : at port 0x280 interrupts disabled options CAN_QUEUE=16  
	CMD_PER_LUN=2 release=1 generic options
	AUTOPROBE_IRQ AUTOSENSE USLEEP, USLEEP_POLL=1 USLEEP_SLEEP=20 
	generic release=7
scsi0 : Generic NCR5380/53C400 Driver
	   Vendor: UMAX      Model: Astra 1200S
		Rev: V2.9   Type:   Scanner ANSI SCSI revision: 02
Attached scsi generic sg0 at scsi0, channel 0, id 5, lun 0,  type 6

I can't reload the module g_NCR5380 after an rmmod:

nihil:~# modprobe -v g_NCR5380
insmod /lib/modules/2.6.0/kernel/drivers/scsi/g_NCR5380.ko ncr_irq=255
ncr_addr=0x280 dtc_3181e=1
FATAL: Error inserting g_NCR5380
(/lib/modules/2.6.0/kernel/drivers/scsi/g_NCR53
80.ko): No such device

After a reboot everything is just fine again.
I use a vanilla 2.6.0 kernel. Please let me know if you need any further
information.

-Kevin
-- 
Think how much fear is going to be required to stop people from passing
along copies of things on their computers. I hope you don't want to live
in a world with that much fear. - Richard M. Stallman
