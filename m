From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Resend Patch 1/3] Vmbus: Add function to report available ring
 buffer to write in total ring size percentage
Date: Mon, 09 Apr 2018 22:58:38 -0400
Message-ID: <yq1d0z722e9.fsf@oracle.com>
References: <20180328004840.22787-1-longli@linuxonhyperv.com>
 <yq1y3ibhndg.fsf@oracle.com>
 <MWHPR2101MB072958DDC25845615C3B1ADCCEA30@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <MWHPR2101MB072958DDC25845615C3B1ADCCEA30@MWHPR2101MB0729.namprd21.prod.outlook.com>
 (Long Li's message of "Wed, 28 Mar 2018 22:42:45 +0000")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Long Li <longli@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Long Li <longli@linuxonhyperv.com>
List-Id: linux-scsi@vger.kernel.org


Long,

> I hope this patch set goes through SCSI, because it's purpose is to
> improve storvsc.
>
> If this strategy is not possible, I can resubmit the 1st two patches to
> net, and the 3rd patch to scsi after the 1st two are merged.

Applied to my staging tree for 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
