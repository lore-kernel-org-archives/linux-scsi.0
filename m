From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] storvsc: Set up correct queue depth values for IDE
 devices
Date: Fri, 20 Apr 2018 15:36:45 -0400
Message-ID: <yq1fu3pisaa.fsf@oracle.com>
References: <20180322214718.29547-1-longli@linuxonhyperv.com>
 <DM5PR2101MB1030FD5B6261CC7BCF0092D1DCAF0@DM5PR2101MB1030.namprd21.prod.outlook.com>
 <MWHPR2101MB072978A101FEFBCF2D32E872CEB60@MWHPR2101MB0729.namprd21.prod.outlook.com>
 <yq1bmefna14.fsf@oracle.com>
 <MWHPR2101MB072916BAB0F56AA2CD8C444BCEB50@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <MWHPR2101MB072916BAB0F56AA2CD8C444BCEB50@MWHPR2101MB0729.namprd21.prod.outlook.com>
 (Long Li's message of "Thu, 19 Apr 2018 04:59:12 +0000")
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
Cc: Stephen Hemminger <sthemmin@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Long Li <longli@linuxonhyperv.com>
List-Id: linux-scsi@vger.kernel.org


Long,

> If num_cpus=1, we don't have any sub channels.
>
> The host offers one sub channel for VM with 5 CPUs, after that it offers
> an additional sub channel every 4 CPUs.
>
> The primary channel is always offered.

Applied to 4.17/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
