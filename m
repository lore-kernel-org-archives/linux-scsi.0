From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] storvsc: fix memory leak on ring buffer busy
Date: Tue, 29 Aug 2017 21:31:11 -0400
Message-ID: <yq18ti1265c.fsf@oracle.com>
References: <20170829004359.28526-1-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170829004359.28526-1-longli@exchange.microsoft.com> (Long Li's
 message of "Mon, 28 Aug 2017 17:43:59 -0700")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Long Li <longli@exchange.microsoft.com>
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org


Long,

> When storvsc is sending I/O to Hyper-v, it may allocate a bigger
> buffer descriptor for large data payload that can't fit into a
> pre-allocated buffer descriptor. This bigger buffer is freed on return
> path.
>
> If I/O request to Hyper-v fails due to ring buffer busy, the storvsc
> allocated buffer descriptor should also be freed.

Which kernel version is this patch aimed at?

-- 
Martin K. Petersen	Oracle Linux Engineering
