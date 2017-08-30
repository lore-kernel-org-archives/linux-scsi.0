From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] storvsc: fix memory leak on ring buffer busy
Date: Wed, 30 Aug 2017 03:48:54 +0000
Message-ID: <MWHPR21MB0190F8C50CCF7CFA0EDCA7A6CE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <20170829004359.28526-1-longli@exchange.microsoft.com>
 <yq18ti1265c.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <yq18ti1265c.fsf@oracle.com>
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
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, August 29, 2017 6:31 PM
> To: Long Li <longli@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; James E . J . Bottomley
> <JBottomley@odin.com>; devel@linuxdriverproject.org; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: Re: [PATCH] storvsc: fix memory leak on ring buffer busy
> 
> 
> Long,
> 
> > When storvsc is sending I/O to Hyper-v, it may allocate a bigger
> > buffer descriptor for large data payload that can't fit into a
> > pre-allocated buffer descriptor. This bigger buffer is freed on return
> > path.
> >
> > If I/O request to Hyper-v fails due to ring buffer busy, the storvsc
> > allocated buffer descriptor should also be freed.
> 
> Which kernel version is this patch aimed at?

Martin, thanks for pointing this out. This should also go to stable trees.

Cc: stable@vger.kernel.org
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
