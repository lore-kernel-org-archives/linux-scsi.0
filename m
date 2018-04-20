From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Patch v2] Storvsc: Select channel based on available percentage
 of ring buffer to write
Date: Fri, 20 Apr 2018 15:40:11 -0400
Message-ID: <yq1bmedis4k.fsf@oracle.com>
References: <20180419215424.3557-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180419215424.3557-1-longli@linuxonhyperv.com> (Long Li's
 message of "Thu, 19 Apr 2018 14:54:24 -0700")
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
Cc: Stephen Hemminger <sthemmin@microsoft.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org


Long,

> This is a best effort for estimating on how busy the ring buffer is
> for that channel, based on available buffer to write in percentage. It
> is still possible that at the time of actual ring buffer write, the
> space may not be available due to other processes may be writing at
> the time.
>
> Selecting a channel based on how full it is can reduce the possibility
> that a ring buffer write will fail, and avoid the situation a channel
> is over busy.
>
> Now it's possible that storvsc can use a smaller ring buffer size
> (e.g. 40k bytes) to take advantage of cache locality.

Applied to 4.18/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
