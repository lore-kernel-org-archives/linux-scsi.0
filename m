From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Weird SCSI error, can anyone interpret?
Date: Wed, 03 Mar 2004 21:06:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4046AB54.9010909@backtobasicsmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wsip-68-14-253-125.ph.ph.cox.net ([68.14.253.125]:20362 "EHLO
	office.labsysgrp.com") by vger.kernel.org with ESMTP
	id S261930AbUCDPOi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Mar 2004 10:14:38 -0500
Received: from [127.0.0.1] (helo=localhost)
	by office.labsysgrp.com with esmtp (Exim 4.24)
	id 1AyuYX-0003c0-Bv
	for linux-scsi@vger.kernel.org; Thu, 04 Mar 2004 08:14:37 -0700
Received: from office.labsysgrp.com ([127.0.0.1])
 by localhost (office.lsg.internal [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 13293-05 for <linux-scsi@vger.kernel.org>;
 Thu,  4 Mar 2004 08:14:26 -0700 (MST)
Received: from jeeves.kpf.internal ([192.168.170.1])
	by office.labsysgrp.com with esmtp (Exim 4.24)
	id 1AyuYC-0003bP-Od
	for linux-scsi@vger.kernel.org; Thu, 04 Mar 2004 08:14:16 -0700
Received: from [192.168.172.107] (helo=backtobasicsmgmt.com)
	by jeeves.kpf.internal with esmtp (Exim 4.05)
	id 1Ayk86-00017m-00
	for linux-scsi@vger.kernel.org; Wed, 03 Mar 2004 21:06:38 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've got a client with a server running 2.6.3-rc2, using a QLogic 
ISP2100 connected to a CMD FC-to-SCSI RAID controller. On Saturday 
morning, the system lost access to the RAID array, with thousands of 
messages like these in the log:

Feb 28 03:15:46 alpha kernel: SCSI error : <2 0 0 0> return code = 0x20000
Feb 28 03:15:46 alpha kernel: end_request: I/O error, dev sdc, sector 
278362544
Feb 28 03:15:51 alpha kernel: SCSI error : <2 0 0 0> return code = 0x20000
Feb 28 03:15:51 alpha kernel: end_request: I/O error, dev sdc, sector 
304356160
Feb 28 03:16:06 alpha kernel: SCSI error : <2 0 0 0> return code = 0x20000
Feb 28 03:16:06 alpha kernel: end_request: I/O error, dev sdc, sector 
360710592
Feb 28 03:16:06 alpha kernel: SCSI error : <2 0 0 0> return code = 0x20000
Feb 28 03:16:06 alpha kernel: end_request: I/O error, dev sdc, sector 
327384736

There are also some with "return code = 0x20008".

Restarting the Linux system did not help; power cycling the RAID array 
did help. I'd like to get some clue as to whether this points to a 
problem with the RAID controller, the FC host adapter, or the kernel's 
QLogic driver. This system had been previously using the QLogic driver 
from SourceForge for months on a 2.6.0-pre(something) kernel, but 
recently got upgraded once the QLogic driver was merged into the main 
kernel distribution.

Please CC me on any replies, I'm not subscribed to linux-scsi. Thanks!
