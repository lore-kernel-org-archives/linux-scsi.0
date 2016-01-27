From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [LSF/MM TOPIC] LIO/SCST Merger
Date: Wed, 27 Jan 2016 09:54:03 -0800
Message-ID: <56A9043B.7030207@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Last year, during the 2015 LSF/MM summit, it has been decided that the 
LIO/SCST merger project should proceed by sending the functionality 
upstream that is present in SCST but not yet in LIO. This will help to 
reduce the workload of target driver maintainers that maintain a version 
of their target driver for both LIO and SCST (QLogic FC and FCoE target 
drivers, Emulex FC and FCoE target drivers, RDMA iSER target driver, 
RDMA SRP target driver, ...). My proposal is to organize a session 
during which the following is discussed:
* Which patches are already upstream in the context of the LIO/SCST 
merger project.
* About which patches there is agreement but that are not yet upstream.
* To discuss how to proceed from here and what to address first.

References:
[1] Bart Van Assche,  [LSF/MM TOPIC] Unifying the LIO and SCST target 
drivers, January 2015 
(http://thread.gmane.org/gmane.linux.scsi.target.devel/7779)
[2] James Bottomley, LIO/SCST merger, April 2015 
(https://plus.google.com/112086662098298535411/posts/HuGsCMU41uy).
