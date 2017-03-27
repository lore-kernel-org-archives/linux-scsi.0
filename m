From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: [REGRESSION][Stable][v3.12.y][v4.4.y][v4.9.y][v4.10.y][v4.11-rc1]
 scsi: storvsc: properly set residual data length on errors
Date: Mon, 27 Mar 2017 16:22:09 -0400
Message-ID: <5df6cd65-92d5-e4c5-56e3-771643f86861@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: longli@microsoft.com
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg KH <gregkh@linuxfoundation.org>, Haiyang Zhang <haiyangz@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, devel@linuxdriverproject.org, sthemmin@microsoft.com
List-Id: linux-scsi@vger.kernel.org

Hi Long Li,

A kernel bug report was opened against Ubuntu [0].  After a kernel
bisect, it was found that reverting the following commit resolved this bug:

commit 40630f462824ee24bc00d692865c86c3828094e0
Author: Long Li <longli@microsoft.com>
Date:   Wed Dec 14 18:46:03 2016 -0800

    scsi: storvsc: properly set residual data length on errors


The regression was introduced in mainline as of v4.11-rc1.  It was also
cc'd to stable and has landed in v3.12.y, v4.4.y, v4.9.y and v4.10.y.


This regression seems pretty severe since it's preventing virtual
machines from booting.  It's affecting a couple of users so far.  I was
hoping to get your feedback, since you are the patch author.  Do you
think gathering any additional data will help diagnose this issue, or
would it be best to submit a revert request?


Thanks,

Joe


[0] http://pad.lv/1674635
