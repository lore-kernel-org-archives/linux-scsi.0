From: webster@lexmark.com
Subject: PERC4/DC (LSI Megaraid) on PowerEdge 2850
Date: Mon, 6 Dec 2004 21:27:43 -0500
Message-ID: <OF471775C1.63CE2BB0-ON85256F63.000B34DD-85256F63.000DB1FE@lexmark.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw1.lexmark.com ([192.146.101.70]:50439 "EHLO sw1.lexmark.com")
	by vger.kernel.org with ESMTP id S261734AbULGCYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2004 21:24:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-poweredge@dell.com
Cc: linux-scsi@vger.kernel.org

Hello.
I am trying to use a Dell PERC4/DC RAID controller in a Dell PowerEdge 
2850 with SUSE Linux .

Every time I try to copy files to a partition on this controller, after 
~10GB, I start receiving this in syslog:

Dec  6 20:25:14 tasker0 kernel: megaraid: aborting-484304 cmd=2a <c=2 t=1 
l=0>
Dec  6 20:25:14 tasker0 kernel: megaraid abort: 484304:115[255:1], fw 
owner
Dec  6 20:25:14 tasker0 kernel: megaraid: aborting-484307 cmd=2a <c=2 t=0 
l=0>
Dec  6 20:25:14 tasker0 kernel: megaraid abort: 484307:46[255:0], fw owner
.
.
.
Dec  6 20:28:14 tasker0 kernel: megaraid: aborting-484438 cmd=2a <c=2 t=1 
l=0>
Dec  6 20:28:14 tasker0 kernel: megaraid abort: 484438[255:1], driver 
owner
Dec  6 20:28:14 tasker0 kernel: megaraid: reseting the host...
Dec  6 20:28:14 tasker0 kernel: megaraid: 71 outstanding commands. Max 
wait 180 sec
Dec  6 20:28:14 tasker0 kernel: megaraid mbox: Wait for 71 commands to 
complete:180
Dec  6 20:28:14 tasker0 kernel: 3>scsi2 (1:0): rejecting I/O to offline 
device
Dec  6 20:28:14 tasker0 kernel: scsi2 (0:0): rejecting I/O to offline 
device
Dec  6 20:28:14 tasker0 kernel: scsi2 (1:0): rejecting I/O to offline 
device
Dec  6 20:28:14 tasker0 kernel: scsi2 (1:0): rejecting I/O to offline 
device
Dec  6 20:28:14 tasker0 kernel: SCSI error : <2 2 0 0> return code = 
0x6000000
Dec  6 20:28:14 tasker0 kernel: end_request: I/O error, dev sdf, sector 
1064044038
Dec  6 20:28:14 tasker0 kernel: scsi2 (0:0): rejecting I/O to offline 
device
Dec  6 20:28:14 tasker0 kernel: SCSI error : <2 2 0 0> return code = 
0x6000000
Dec  6 20:28:14 tasker0 kernel: end_request: I/O error, dev sdf, sector 
1064043910
.
.
.



Any advice?

Thanks.

