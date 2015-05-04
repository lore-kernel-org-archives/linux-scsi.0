From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v3 1/2] libahci: Add support to handle HOST_IRQ_STAT as
 edge trigger latch.
Date: Mon, 04 May 2015 16:08:08 +0300
Message-ID: <55476F38.7080002@cogentembedded.com>
References: <1430667220-23477-1-git-send-email-stripathi@apm.com> <1430667220-23477-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1430667220-23477-2-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>, olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

Hello.

On 5/3/2015 6:33 PM, Suman Tripathi wrote:

> This patch adds the support to handle HOST_IRQ_STAT as edge trigger
> latch.

> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>   drivers/ata/ahci.h    |  2 ++
>   drivers/ata/libahci.c | 19 +++++++++++++++++++
>   2 files changed, 21 insertions(+)

> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 71262e0..2df2237 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
[...]
> +++ b/drivers/ata/libahci.c
> @@ -1879,6 +1879,25 @@ static irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
>   	 */
>   	writel(irq_stat, mmio + HOST_IRQ_STAT);
>
> +	/*
> +	 * HOST_IRQ_STAT behaves as edge trigger latch. When HOST_IRQ_STAT
> +	 * detects a egde from PORT_IRQ_STAT, it happens to loose interrupts

    s/loose/lose/.

MBR, Sergei

