From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH] storvsc: Set up correct queue depth values for IDE devices
Date: Thu, 15 Mar 2018 18:53:42 -0700
Message-ID: <20180315185342.6190f1e9@xeon-e3>
References: <20180315235223.19844-1-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180315235223.19844-1-longli@exchange.microsoft.com>
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

On Thu, 15 Mar 2018 16:52:23 -0700
Long Li <longli@exchange.microsoft.com> wrote:

> From: Long Li <longli@microsoft.com>
> 
> Unlike SCSI and FC, we don't use multiple channels for IDE. So set queue depth
> correctly for IDE.
> 
> Also set the correct cmd_per_lun for all devices.
> 
> Signed-off-by: Long Li <longli@microsoft.com>

Looks correct.
Acked-by: Stephen Hemminger <sthemmin@microsoft.com>
