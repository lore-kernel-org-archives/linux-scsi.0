From: Lucia Mazzoni <lucia.mazzoniATATATaster.it@aster.it>
Subject: megaraid 2.10.1 and raid10
Date: Tue, 10 Aug 2004 14:58:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040810130129.CDE6B53AF7@aster001>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.aster.it ([193.207.59.1]:26240 "EHLO aster001")
	by vger.kernel.org with ESMTP id S265051AbUHJM6Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 08:58:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I've just subscribed this list trying to solve a big problem with 
megaraid2.c (I think...!).

We installed a Debian stable on 2 Intel server with an INTEL SRCU42X 
raid controller.
The compiled kernel is a vanilla kernel 2.4.26 and the version of 
megaraid2 is 2.10.1.

The first server is configured only with raid1: no problem at all.
The second one  is configured with a raid 10: 4 disks, 2 raid1 between 
disks on different channel and a raid0 on this set (with stripe size of 64k)

We experienced that when the second server has to do with file of 
"significant" size (greater than 10 Mb) it hangs during its operation 
(do not respond at all). After a while ...it ends the operation.
This time depends on the size of the file (greater size ==> more time).
Operation are: copy, reading.... (files on this server are generally 
mailboxes).
After the first time the access time to a single file is faster for a while.

We tried megaraid 2.10.3 with kernel 2.4.27 but the timing results were 
even worst (35 sec for a file of 35Mb.......)

Any suggestions?
Raid 10 is not reliable with megaraid2? (that was the Intel support 
answer to my question.....)

Thanks in advance for any help
Lucia
