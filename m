From: Christian Schmid <webmaster@rapidforum.com>
Subject: Frozen system even with Raid 5
Date: Wed, 11 Oct 2006 01:18:56 +0200
Message-ID: <452C2A60.2070300@rapidforum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.rapidforum.com ([80.237.244.2]:34235 "HELO rapidforum.com")
	by vger.kernel.org with SMTP id S1030334AbWJJXTC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 19:19:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxraid@amcc.com, linux-scsi@vger.kernel.org

Hello.

We are right now having a 360 TB Raid-system with 3-Ware controllers. Unfortunately there are 2 ways 
a disk can fail: A complete sudden fail, which results in a immediate shutdown of the disk, causing 
the array to continue in degraded mode (raid5), and the soft-fail, which results in a complete hang 
of the system, the system always prints errors of timeout sending command, card was resetted. A 
hard-remove of the drive clears the problem, but I dont think thats supposed to be that way, is it? 
The warnings below keep printed for hours, until the drive is removed. In this time the IOs hang.

Oct 10 23:41:19 kernel: [2850624.586613] sd 0:0:4:0: WARNING: (0x06:0x002C): Command (0x28) timed 
out, resetting card.
Oct 10 23:41:33 kernel: [2850638.425847] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized 
after power fail:unit=0.
Oct 10 23:41:33 kernel: [2850638.545663] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized 
after power fail:unit=1.
Oct 10 23:41:33 kernel: [2850638.665481] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized 
after power fail:unit=2.
Oct 10 23:41:33 kernel: [2850638.785296] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized 
after power fail:unit=3.
Oct 10 23:41:33 kernel: [2850638.905123] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized 
after power fail:unit=4.
Oct 10 23:41:33 kernel: [2850639.024934] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized 
after power fail:unit=5.
Oct 10 23:41:33 kernel: [2850639.144759] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized 
after power fail:unit=6.
Oct 10 23:41:34 kernel: [2850639.264575] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized 
after power fail:unit=7.

Linux 2.6.17.11 vanilla.

Regards,
Chris
