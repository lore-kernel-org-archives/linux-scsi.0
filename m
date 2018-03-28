From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Resend Patch 1/3] Vmbus: Add function to report available ring
 buffer to write in total ring size percentage
Date: Wed, 28 Mar 2018 18:00:11 -0400
Message-ID: <yq1y3ibhndg.fsf@oracle.com>
References: <20180328004840.22787-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180328004840.22787-1-longli@linuxonhyperv.com> (Long Li's
 message of "Tue, 27 Mar 2018 17:48:38 -0700")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Long Li <longli@linuxonhyperv.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org


Long,

> Netvsc has a function to calculate how much ring buffer in percentage is
> available to write. This function is also useful for storvsc and other
> vmbus devices.

What is the submission strategy for this series? Do you expect it to go
through net or scsi? If the latter, I'll need an ack from davem.

-- 
Martin K. Petersen	Oracle Linux Engineering
