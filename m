From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] storvsc: Avoid excessive host scan on controller change
Date: Mon, 06 Nov 2017 22:40:14 -0500
Message-ID: <yq1o9oe3gf5.fsf@oracle.com>
References: <20171031215808.11629-1-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20171031215808.11629-1-longli@exchange.microsoft.com> (Long Li's
 message of "Tue, 31 Oct 2017 14:58:08 -0700")
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
Cc: Stephen Hemminger <sthemmin@microsoft.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org


Long,

> When there are multiple disks attached to the same SCSI controller,
> the host may send several VSTOR_OPERATION_REMOVE_DEVICE or
> VSTOR_OPERATION_ENUMERATE_BUS messages in a row, to indicate there is
> a change on the SCSI controller. In response, storvsc rescans the SCSI
> host.

Applied to 4.15/scsi-queue with some fuzz. Please verify, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
