From: <WHarms@bfs.de> (Walter Harms)
Subject: cd error locks kernel 2.4.19
Date: Sat, 18 Jan 2003 14:41:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <vines.sxdD+5aJ8yA@SZKOM.BFS.DE>
Reply-To: <WHarms@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bfs.de ([194.94.69.67])
	by ws-han1.win-ip.dfn.de (8.12.1/8.12.1) with ESMTP id h0IDeKws013500
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2003 14:40:20 +0100 (MET)
Received: from localhost (localhost [127.0.0.1])
	by mail.bfs.de (BfS Mail Relay) with ESMTP id 06B242006E
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2003 14:40:20 +0100 (CET)
Received: from apz.bfs (apz.bfs [192.168.0.1])
	by mail.bfs.de (BfS Mail Relay) with ESMTP id 7E11C1FF4B
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2003 14:40:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by apz.bfs (BfS Mail Hub) with ESMTP id B2BAB4734
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2003 14:40:38 +0100 (CET)
Received: from SZKOM.BFS.DE (unknown [193.174.230.136])
	by apz.bfs (BfS Mail Hub) with SMTP id 2C7B646C5
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2003 14:40:38 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi list,
i found that when linux 2.4.19 is accessing my cdrecoder
(via ide-scsi) and the cd is faulty, it can stop
the whole system. I couldnt get the cd back on the normal
way. It was not possible to break the mount-cmd via CTRL-C.
With some luck i managed a kill that broke the deadlock
but the box where very unresponsive.

any way i can help ?

walter



Here are the important parts: the status came actualy much more often.
kernel: hdc: ATAPI reset complete
kernel: hdc: status timeout: status=0xd0 { Busy }
kernel: ide-scsi: Strange, packet command initiated yet DRQ isn't asserted
kernel: scsi : aborting command due status timeout : pid 207383, scsi1, channel 0, id 0, lun 0 0x1e 00 00 00 01 00 
kernel: SCSI host 1 abort (pid 207383) timed out - resetting
kernel: SCSI bus is being reset for host 1 channel 0.
kernel: hdc: ATAPI reset complete
kernel: hdc: status timeout: status=0xd0 { Busy }
kernel: ide-scsi: Strange, packet command initiated yet DRQ isn't asserted
kernel: SCSI error: host 1 id 0 lun 0 return code = 27070000
kernel:         Sense class 0, sense error 0, extended sense 0
omnfr10 kernel: SCSI error: host 1 id 0 lun 0 return code = 27070000
kernel:         Sense class 0, sense error 0, extended sense 0




