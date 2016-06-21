From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libfc: fix seconds_since_last_reset calculation
Date: Mon, 20 Jun 2016 22:05:24 -0400
Message-ID: <yq1r3br47q3.fsf@sermon.lab.mkp.net>
References: <20160617154737.633440-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160617154737.633440-1-arnd@arndb.de> (Arnd Bergmann's message
	of "Fri, 17 Jun 2016 17:47:25 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vasu Dev <vasu.dev@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, y2038@lists.linaro.org, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> The fc_get_host_stats() function contains a complex conversion
Arnd> from jiffies to timespec to seconds. As we try to get rid of uses
Arnd> of struct timespec, we can clean this up and replace it with a
Arnd> simpler computation.

Arnd> Simply dividing the difference in jiffies by HZ is not only much
Arnd> more efficient, it also avoids a problem that causes the
Arnd> seconds_since_last_reset value to be incorrect if jiffies has
Arnd> overrun since the 'boot_time' value was recorded.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
