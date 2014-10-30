From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH 1/1 linux-next] hpsa: remove set but unused variable rc
Date: Thu, 30 Oct 2014 10:21:05 -0500
Message-ID: <54525761.8070800@gmail.com>
References: <1414595704-3119-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1414595704-3119-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, don.brace@pmcs.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On 10/29/2014 10:15 AM, Fabian Frederick wrote:
> Fix -Wunused-but-set-variable warning
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   drivers/scsi/hpsa.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index cef5d49..34330e1 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6619,11 +6619,11 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
>
>   static void hpsa_irq_affinity_hints(struct ctlr_info *h)
>   {
> -	int i, cpu, rc;
> +	int i, cpu;
>
>   	cpu = cpumask_first(cpu_online_mask);
>   	for (i = 0; i < h->msix_vector; i++) {
> -		rc = irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
> +		irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
>   		cpu = cpumask_next(cpu, cpu_online_mask);
>   	}
>   }
>

I can add this patch to my current set of patches for 3.19 or ack this 
now, What would you prefer?

---
Don Brace
don.brace@pmcs.com
