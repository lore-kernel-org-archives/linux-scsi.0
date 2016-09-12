From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: Use of schedule() function while holding a lock in ql4_nx.c
Date: Mon, 12 Sep 2016 10:49:03 +0530
Message-ID: <57D63AC7.9010507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

I was wondering about the call to schedule in function qla4_82xx_crb_win_lock for driver
drivers/scsi/qla4xxx/ql4_nx.c. It is called in 2 functions [qla4_82xx_rd_32 and
qla4_82xx_wr_32] while holding a write_lock_irqsave. Normally we avoid using sleeping
functions while holding a lock.

Is there some reason that I am overlooking? Why it is OK in this case? Are we using
schedule() here intentionally?

Thank you.


-- 
Vaishali
