From: jonw@coriolis.net
Subject: Symbios 53c875 Robot Timeouts
Date: Fri, 19 Sep 2003 09:26:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309190907280.20352-100000@server.coriolis.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-228-92-64.client.attbi.com ([12.228.92.64]:29948 "EHLO
	server.coriolis.net") by vger.kernel.org with ESMTP id S261621AbTISQ07
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2003 12:26:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by server.coriolis.net (Postfix) with ESMTP id F3A34BE205
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2003 09:26:17 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I am attempting to move my backup installation from Solaris to Redhat 7.3

I have a dual port HVD Symbios 53c875 driving a Storagetek L80 tape 
library.   It seems that all ncr/symbios drivers run into timeout issues while dealing with 
robotic operations.   From what I can tell, the robotic commands are 
completing properly, but at times they seem to take longer than the driver is willing 
to wait:

Sep  9 20:14:29 netbackup kernel: sym0:0:0: ABORT operation started.
Sep  9 20:14:29 netbackup kernel: sym0:0:0: ABORT operation failed.
Sep  9 20:14:29 netbackup kernel: sym0:0:0: DEVICE RESET operation 
started.
Sep  9 20:14:29 netbackup kernel: sym0:0:0: DEVICE RESET operation failed.
Sep  9 20:14:29 netbackup kernel: sym0:0:0: BUS RESET operation started.
Sep  9 20:14:29 netbackup kernel: sym0:0:0: BUS RESET operation failed.
Sep  9 20:14:34 netbackup kernel: sym0:0:0: HOST RESET operation started.
Sep  9 20:14:34 netbackup kernel: sym0:0:0: HOST RESET operation failed.

At this time I have to unload/reload the driver.   I have ruled out 
bad hardware.

I have experienced similar behavior with the sym53c8xx, sym53c8xx_2 and 
ncr53c8xx drivers, all being used by the sg driver for robotic control.   
Can someone point me in the direction as to how to increase this timeout 
value?

Thank you,

-Jon

