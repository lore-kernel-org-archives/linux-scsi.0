From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH v2] storvsc: Set up correct queue depth values for IDE
 devices
Date: Thu, 19 Apr 2018 04:59:12 +0000
Message-ID: <MWHPR2101MB072916BAB0F56AA2CD8C444BCEB50@MWHPR2101MB0729.namprd21.prod.outlook.com>
References: <20180322214718.29547-1-longli@linuxonhyperv.com>
 <DM5PR2101MB1030FD5B6261CC7BCF0092D1DCAF0@DM5PR2101MB1030.namprd21.prod.outlook.com>
 <MWHPR2101MB072978A101FEFBCF2D32E872CEB60@MWHPR2101MB0729.namprd21.prod.outlook.com>
 <yq1bmefna14.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <yq1bmefna14.fsf@oracle.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "James
 E . J . Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Long Li <longli@linuxonhyperv.com>
List-Id: linux-scsi@vger.kernel.org

> Subject: Re: [PATCH v2] storvsc: Set up correct queue depth values for IDE
> devices
> 
> 
> Long,
> 
> > Can you take a look at the following patch?
> 
> >> > + max_sub_channels =
> >> > + 		(num_cpus - 1) / storvsc_vcpus_per_sub_channel;
> 
> What happens if num_cpus = 1?

If num_cpus=1, we don't have any sub channels.

The host offers one sub channel for VM with 5 CPUs, after that it offers an additional sub channel every 4 CPUs.

The primary channel is always offered.

> 
> --
> Martin K. Petersen	Oracle Linux Engineering
