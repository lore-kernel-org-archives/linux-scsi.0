Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74A5C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 19:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B45864E41
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 19:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhBERyB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 12:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbhBEPpu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 10:45:50 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC566C0613D6;
        Fri,  5 Feb 2021 09:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=rtPxC3IfnkgG1TZWWihdhqpjaVFIkMV+yIPZqBh6yaM=; b=g/YLGCMTHbdmwmHsnSYpzPWf2G
        HJTG+6M9re8sObmTvCGHhXu1HhgYe84PjZJIP/jtHIyTEo8BR1KbfGAQ6XqZXBTcVh/LQHY5AYnv0
        tceoxzzB5UtmB6UTSJuUr2P7UJU4OzxX5A5xWs4EqZbUypmCx4Yeg5Tr1bDwDcGngjfmzJbotmtBY
        5LcHoAugcJ85ZlkeRZA98CXYUHo5Bfuop0YXdqXs8uzhgDPcKysh51MSenG4HiY/Qj29am9AKa/CX
        sEx+Z0mm2ZjqjONJcBVInsMVg+rRKjwlg1bMyZMZt2t887M71CUB/NTsXYCwXxpcqBc04dsTTB7D3
        Cb8SgcXQ==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l84tD-00049n-Kh; Fri, 05 Feb 2021 17:27:27 +0000
Subject: Re: [PATCH] drivers: scsi: lpfc: Mundane spelling and sentence
 construction fixes throughout the file
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210205053036.18054-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <db916e9d-4439-2fc0-9e86-a36a3995aef3@infradead.org>
Date:   Fri, 5 Feb 2021 09:27:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210205053036.18054-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 9:30 PM, Bhaskar Chowdhury wrote:
> 
> 
> Few spellings and sentence  construction done throughout the file.
> 
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index ac67f420ec26..923fadb7945a 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -11022,7 +11022,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
>  			/* We found a matching phys_id, so copy the IRQ info */
>  			cpup->eq = new_cpup->eq;
> 
> -			/* Bump start_cpu to the next slot to minmize the
> +			/* Bump start_cpu to the next slot to minimize the

OK.

>  			 * chance of having multiple unassigned CPU entries
>  			 * selecting the same IRQ.
>  			 */
> @@ -11076,7 +11076,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
>  			/* We found an available entry, copy the IRQ info */
>  			cpup->eq = new_cpup->eq;
> 
> -			/* Bump start_cpu to the next slot to minmize the
> +			/* Bump start_cpu to the next slot to minimize the

OK.

>  			 * chance of having multiple unassigned CPU entries
>  			 * selecting the same IRQ.
>  			 */
> @@ -11246,14 +11246,14 @@ lpfc_cpuhp_get_eq(struct lpfc_hba *phba, unsigned int cpu,
>  		if (!maskp)
>  			continue;
>  		/*
> -		 * if irq is not affinitized to the cpu going

Original may not be a real word, but it conveys the meaning better
than the proposed change does.

> +		 * if irq is not affinities to the cpu going
>  		 * then we don't need to poll the eq attached
>  		 * to it.
>  		 */
>  		if (!cpumask_and(tmp, maskp, cpumask_of(cpu)))
>  			continue;
> -		/* get the cpus that are online and are affini-
> -		 * tized to this irq vector.  If the count is
> +		/* get the cpus that are online and are affinities
> +		 * to this irq vector.  If the count is

ditto.

>  		 * more than 1 then cpuhp is not going to shut-
>  		 * down this vector.  Since this cpu has not
>  		 * gone offline yet, we need >1.
> @@ -11367,7 +11367,7 @@ lpfc_irq_clear_aff(struct lpfc_hba_eq_hdl *eqhdl)
>   * online cpu on the phba's original_mask and migrate all offlining IRQ
>   * affinities.
>   *
> - * If cpu is coming online, reaffinitize the IRQ back to the onlining cpu.
> + * If cpu is coming online, again affinities the IRQ back to the on lining cpu.

ditto.

>   *
>   * Note: Call only if NUMA or NHT mode is enabled, otherwise rely on
>   *	 PCI_IRQ_AFFINITY to auto-manage IRQ affinity.
> @@ -11401,7 +11401,7 @@ lpfc_irq_rebalance(struct lpfc_hba *phba, unsigned int cpu, bool offline)
> 
>  		/* Found a valid CPU */
>  		if ((cpu_select < nr_cpu_ids) && (cpu_select != cpu)) {
> -			/* Go through each eqhdl and ensure offlining

The original looks good to me.

> +			/* Go through each eqhdl and ensure off lining
>  			 * cpu aff_mask is migrated
>  			 */
>  			for (idx = 0; idx < phba->cfg_irq_chann; idx++) {
> @@ -11597,7 +11597,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
>  				 * this vector, set LPFC_CPU_FIRST_IRQ.
>  				 *
>  				 * With certain platforms its possible that irq
> -				 * vectors are affinitized to all the cpu's.

Original is better.

> +				 * vectors are affinities to all the cpu's.
>  				 * This can result in each cpu_map.eq to be set
>  				 * to the last vector, resulting in overwrite
>  				 * of all the previous cpu_map.eq.  Ensure that
> @@ -11635,7 +11635,7 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
>  		free_irq(eqhdl->irq, eqhdl);
>  	}
> 
> -	/* Unconfigure MSI-X capability structure */

ditto.

> +	/* Not configure MSI-X capability structure */
>  	pci_free_irq_vectors(phba->pcidev);
> 
>  vec_fail_out:
> @@ -11744,7 +11744,7 @@ lpfc_sli4_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
>  		}
>  	}
> 
> -	/* Fallback to INTx if both MSI-X/MSI initalization failed */
> +	/* Fallback to INTx if both MSI-X/MSI initialization failed */

OK.

>  	if (phba->intr_type == NONE) {
>  		retval = request_irq(phba->pcidev->irq, lpfc_sli4_intr_handler,
>  				     IRQF_SHARED, LPFC_DRIVER_NAME, phba);
> @@ -12479,7 +12479,7 @@ lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id *pid)
>   * lpfc_pci_remove_one_s3 - PCI func to unreg SLI-3 device from PCI subsystem.
>   * @pdev: pointer to PCI device
>   *
> - * This routine is to be called to disattach a device with SLI-3 interface

detach

> + * This routine is to be called to not attach a device with SLI-3 interface
>   * spec from PCI subsystem. When an Emulex HBA with SLI-3 interface spec is
>   * removed from PCI bus, it performs all the necessary cleanup for the HBA
>   * device to be removed from the PCI subsystem properly.
> @@ -12940,7 +12940,7 @@ lpfc_log_write_firmware_error(struct lpfc_hba *phba, uint32_t offset,
>  	/* Three cases:  (1) FW was not supported on the detected adapter.
>  	 * (2) FW update has been locked out administratively.
>  	 * (3) Some other error during FW update.
> -	 * In each case, an unmaskable message is written to the console

Original conveys the message better than the proposed change.

> +	 * In each case, an unusable message is written to the console
>  	 * for admin diagnosis.
>  	 */
>  	if (offset == ADD_STATUS_FW_NOT_SUPPORTED ||
> --
> 2.30.0
> 


-- 
~Randy

