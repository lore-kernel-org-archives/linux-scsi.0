From: Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: Re: [PATCH] scsi/eh: fix hang adding ehandler wakeups after
 decrementing host_busy
Date: Wed, 8 Nov 2017 23:38:29 -0600
Message-ID: <ae6cce43-108a-aec8-2023-20f04c8506e5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, devel@openvz.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org


Are there any issues with this patch (https://patchwork.kernel.org/patch/9938919/) that Pavel Tikhomirov submitted back in September?  I am willing to help if there's anything I can do to help get it accepted.

The failing case I'm working on involves lots of servers with disk read/write activity with periodic INQUIRY commands that aren't supported by the target device, so the error handler gets invoked periodically, and some of the systems will hang after a day or two.

Thanks
Stuart

---
This email has been checked for viruses by Avast antivirus software.
https://www.avast.com/antivirus
