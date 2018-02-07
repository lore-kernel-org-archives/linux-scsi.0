From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: storvsc: Spread interrupts when picking a
 channel for I/O requests
Date: Tue, 06 Feb 2018 19:39:17 -0500
Message-ID: <yq160793a6i.fsf@oracle.com>
References: <1516831913-26013-1-git-send-email-mikelley@ntdev.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1516831913-26013-1-git-send-email-mikelley@ntdev.microsoft.com>
 (Michael Kelley's message of "Wed, 24 Jan 2018 22:14:08 +0000")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "JBottomley@odin.com" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "longi@microsoft.com" <longi@microsoft.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org


Michael,

> Update the algorithm in storvsc_do_io to look for a channel starting
> with the current CPU + 1 and wrap around (within the current NUMA
> node). This spreads VMbus interrupts more evenly across CPUs. Previous
> code always started with first CPU in the current NUMA node, skewing
> the interrupt load to that CPU.

Applied to 4.16/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
