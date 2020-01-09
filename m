Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F76C32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 09:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B27EF20678
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 09:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbgAIJiG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 04:38:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:58622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729623AbgAIJiF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 04:38:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 653BDBFCC;
        Thu,  9 Jan 2020 09:37:49 +0000 (UTC)
Subject: Re: [PATCH v2 16/32] elx: efct: Driver initialization routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-17-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <85ebc215-82c4-4432-5327-d566e3d5dbc0@suse.de>
Date:   Thu, 9 Jan 2020 10:01:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-17-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 11:37 PM, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Emulex FC Target driver init, attach and hardware setup routines.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/efct/efct_driver.c | 1031 +++++++++++++++++++++++++++++
>  drivers/scsi/elx/efct/efct_driver.h |  150 +++++
>  drivers/scsi/elx/efct/efct_hw.c     | 1222 +++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/efct/efct_hw.h     |   16 +-
>  drivers/scsi/elx/efct/efct_xport.c  |  587 +++++++++++++++++
>  drivers/scsi/elx/efct/efct_xport.h  |  205 ++++++
>  6 files changed, 3210 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/scsi/elx/efct/efct_driver.c
>  create mode 100644 drivers/scsi/elx/efct/efct_driver.h
>  create mode 100644 drivers/scsi/elx/efct/efct_hw.c
>  create mode 100644 drivers/scsi/elx/efct/efct_xport.c
>  create mode 100644 drivers/scsi/elx/efct/efct_xport.h
> 
> diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
> new file mode 100644
> index 000000000000..f0ec132bdd0e
> --- /dev/null
> +++ b/drivers/scsi/elx/efct/efct_driver.c
> @@ -0,0 +1,1031 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#include "efct_driver.h"
> +#include "efct_utils.h"
> +
> +#include "efct_els.h"
> +#include "efct_hw.h"
> +#include "efct_unsol.h"
> +#include "efct_scsi.h"
> +
> +struct efct *efct_devices[MAX_EFCT_DEVICES];
> +
> +static int logmask;
> +module_param(logmask, int, 0444);
> +MODULE_PARM_DESC(logmask, "logging bitmask (default 0)");
> +
> +static struct libefc_function_template efct_libefc_templ = {
> +	.hw_domain_alloc = efct_hw_domain_alloc,
> +	.hw_domain_attach = efct_hw_domain_attach,
> +	.hw_domain_free = efct_hw_domain_free,
> +	.hw_domain_force_free = efct_hw_domain_force_free,
> +	.domain_hold_frames = efct_domain_hold_frames,
> +	.domain_accept_frames = efct_domain_accept_frames,
> +
> +	.hw_port_alloc = efct_hw_port_alloc,
> +	.hw_port_attach = efct_hw_port_attach,
> +	.hw_port_free = efct_hw_port_free,
> +
> +	.hw_node_alloc = efct_hw_node_alloc,
> +	.hw_node_attach = efct_hw_node_attach,
> +	.hw_node_detach = efct_hw_node_detach,
> +	.hw_node_free_resources = efct_hw_node_free_resources,
> +	.node_purge_pending = efct_node_purge_pending,
> +
> +	.scsi_io_alloc_disable = efct_scsi_io_alloc_disable,
> +	.scsi_io_alloc_enable = efct_scsi_io_alloc_enable,
> +	.scsi_validate_node = efct_scsi_validate_initiator,
> +	.new_domain = efct_scsi_tgt_new_domain,
> +	.del_domain = efct_scsi_tgt_del_domain,
> +	.new_sport = efct_scsi_tgt_new_sport,
> +	.del_sport = efct_scsi_tgt_del_sport,
> +	.scsi_new_node = efct_scsi_new_initiator,
> +	.scsi_del_node = efct_scsi_del_initiator,
> +
> +	.els_send = efct_els_req_send,
> +	.els_send_ct = efct_els_send_ct,
> +	.els_send_resp = efct_els_resp_send,
> +	.bls_send_acc_hdr = efct_bls_send_acc_hdr,
> +	.send_flogi_p2p_acc = efct_send_flogi_p2p_acc,
> +	.send_ct_rsp = efct_send_ct_rsp,
> +	.send_ls_rjt = efct_send_ls_rjt,
> +
> +	.node_io_cleanup = efct_node_io_cleanup,
> +	.node_els_cleanup = efct_node_els_cleanup,
> +	.node_abort_all_els = efct_node_abort_all_els,
> +
> +	.dispatch_fcp_cmd = efct_dispatch_fcp_cmd,
> +	.recv_abts_frame = efct_node_recv_abts_frame,
> +};
> +
> +static char *queue_topology =
> +	"eq cq rq cq mq $nulp($nwq(cq wq:ulp=$rpt1)) cq wq:len=256:class=1";
> +

What on earth ...
That _does_ warrant an explanation.

> +static int
> +efct_device_init(void)
> +{
> +	int rc;
> +
> +	hw_global.queue_topology_string = queue_topology;
> +
> +	/* driver-wide init for target-server */
> +	rc = efct_scsi_tgt_driver_init();
> +	if (rc) {
> +		pr_err("efct_scsi_tgt_init failed rc=%d\n",
> +			     rc);
> +		return -1;
> +	}
> +
> +	rc = efct_scsi_reg_fc_transport();
> +	if (rc) {
> +		pr_err("failed to register to FC host\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void
> +efct_device_shutdown(void)
> +{
> +	efct_scsi_release_fc_transport();
> +
> +	efct_scsi_tgt_driver_exit();
> +}
> +
> +static void *
> +efct_device_alloc(u32 nid)
> +{
> +	struct efct *efct = NULL;
> +	u32 i;
> +
> +	efct = kmalloc_node(sizeof(*efct), GFP_ATOMIC, nid);
> +
> +	if (efct) {
> +		memset(efct, 0, sizeof(*efct));
> +		for (i = 0; i < ARRAY_SIZE(efct_devices); i++) {
> +			if (!efct_devices[i]) {
> +				efct->instance_index = i;
> +				efct_devices[i] = efct;
> +				break;
> +			}
> +		}
> +
> +		if (i == ARRAY_SIZE(efct_devices)) {
> +			pr_err("Exceeded max supported devices.\n");
> +			kfree(efct);
> +			efct = NULL;
> +		} else {
> +			efct->attached = false;
> +		}
> +	}
> +	return efct;
> +}
> +
> +static struct efct *
> +efct_get_instance(u32 index)
> +{
> +	if (index < ARRAY_SIZE(efct_devices))
> +		return efct_devices[index];
> +
> +	return NULL;
> +}
> +
> +static void
> +efct_device_interrupt_handler(struct efct *efct, u32 vector)
> +{
> +	efct_hw_process(&efct->hw, vector, efct->max_isr_time_msec);
> +}
> +
> +static int
> +efct_intr_thread(struct efct_intr_context *intr_context)
> +{
> +	struct efct *efct = intr_context->efct;
> +	int rc;
> +	u32 tstart, tnow;
> +
> +	tstart = jiffies_to_msecs(jiffies);
> +
> +	while (!kthread_should_stop()) {
> +		rc = wait_for_completion_timeout(&intr_context->done,
> +				  usecs_to_jiffies(100000));
> +		if (!rc)
> +			continue;
> +
> +		efct_device_interrupt_handler(efct, intr_context->index);
> +
> +		/* If we've been running for too long, then yield */
> +		tnow = jiffies_to_msecs(jiffies);
> +		if ((tnow - tstart) > 5000) {
> +			cond_resched();
> +			tstart = tnow;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +efct_start_event_processing(struct efct *efct)
> +{
> +	u32 i;
> +
> +	for (i = 0; i < efct->n_msix_vec; i++) {
> +		char label[32];
> +		struct efct_intr_context *intr_ctx = NULL;
> +
> +		intr_ctx = &efct->intr_context[i];
> +
> +		intr_ctx->efct = efct;
> +		intr_ctx->index = i;
> +
> +		init_completion(&intr_ctx->done);
> +
> +		snprintf(label, sizeof(label),
> +			 "efct:%d:%d", efct->instance_index, i);
> +
> +		intr_ctx->thread =
> +			kthread_create((int(*)(void *)) efct_intr_thread,
> +				       intr_ctx, label);
> +
> +		if (IS_ERR(intr_ctx->thread)) {
> +			efc_log_err(efct, "kthread_create failed: %ld\n",
> +				     PTR_ERR(intr_ctx->thread));
> +			intr_ctx->thread = NULL;
> +
> +			return -1;
> +		}
> +
> +		wake_up_process(intr_ctx->thread);
> +	}
> +
> +	return 0;
> +}
> +

Hmpf.
We _do_ have a generic threaded interrupt model.
Any particular reason why you have to reimplement it?

> +static void
> +efct_teardown_msix(struct efct *efct)
> +{
> +	u32 i;
> +
> +	for (i = 0; i < efct->n_msix_vec; i++) {
> +		synchronize_irq(efct->msix_vec[i].vector);
> +		free_irq(efct->msix_vec[i].vector,
> +			 &efct->intr_context[i]);
> +	}
> +	pci_disable_msix(efct->pcidev);
> +}
> +
> +static int
> +efct_efclib_config(struct efct *efct, struct libefc_function_template *tt)
> +{
> +	struct efc *efc;
> +	struct sli4 *sli;
> +
> +	efc = kmalloc(sizeof(*efc), GFP_KERNEL);
> +	if (!efc)
> +		return -1;
> +
> +	memset(efc, 0, sizeof(struct efc));
> +	efct->efcport = efc;
> +
> +	memcpy(&efc->tt, tt, sizeof(*tt));
> +	efc->base = efct;
> +	efc->pcidev = efct->pcidev;
> +
> +	efc->def_wwnn = efct_get_wwn(&efct->hw, EFCT_HW_WWN_NODE);
> +	efc->def_wwpn = efct_get_wwn(&efct->hw, EFCT_HW_WWN_PORT);
> +	efc->enable_tgt = 1;
> +	efc->log_level = EFC_LOG_LIB;
> +
> +	sli = &efct->hw.sli;
> +	efc->max_xfer_size = sli->sge_supported_length *
> +			     sli_get_max_sgl(&efct->hw.sli);
> +
> +	efcport_init(efc);
> +
> +	return 0;
> +}
> +
> +static int efct_request_firmware_update(struct efct *efct);
> +
> +static int
> +efct_device_attach(struct efct *efct)
> +{
> +	u32 rc = 0, i = 0;
> +
> +	if (efct->attached) {
> +		efc_log_warn(efct, "Device is already attached\n");
> +		rc = -1;
> +	} else {
> +		snprintf(efct->display_name, sizeof(efct->display_name),
> +			 "[%s%d] ", "fc",  efct->instance_index);
> +
> +		efct->logmask = logmask;
> +		efct->enable_numa_support = 1;
> +		efct->filter_def = "0,0,0,0";
> +		efct->max_isr_time_msec = EFCT_OS_MAX_ISR_TIME_MSEC;
> +		efct->model =
> +			(efct->pcidev->device == EFCT_DEVICE_ID_LPE31004) ?
> +			"LPE31004" : "unknown";

That is _so_ lame.
You already know which devices you bind to, and even the names.
So please update this check.

> +		efct->fw_version = (const char *)efct_hw_get_ptr(&efct->hw,
> +							EFCT_HW_FW_REV);
> +		efct->driver_version = EFCT_DRIVER_VERSION;
> +
> +		efct->efct_req_fw_upgrade = true;
> +
> +		/* Allocate transport object and bring online */
> +		efct->xport = efct_xport_alloc(efct);
> +		if (!efct->xport) {
> +			efc_log_err(efct, "failed to allocate transport object\n");
> +			rc = -1;
> +		} else if (efct_xport_attach(efct->xport) != 0) {
> +			efc_log_err(efct, "failed to attach transport object\n");
> +			rc = -1;
> +		} else if (efct_xport_initialize(efct->xport) != 0) {
> +			efc_log_err(efct, "failed to initialize transport object\n");
> +			rc = -1;
> +		} else if (efct_efclib_config(efct, &efct_libefc_templ)) {
> +			efc_log_err(efct, "failed to init efclib\n");
> +			rc = -1;
> +		} else if (efct_start_event_processing(efct)) {
> +			efc_log_err(efct, "failed to start event processing\n");
> +			rc = -1;
> +		} else {
> +			for (i = 0; i < efct->n_msix_vec; i++) {
> +				efc_log_debug(efct, "irq %d enabled\n",
> +					efct->msix_vec[i].vector);
> +				enable_irq(efct->msix_vec[i].vector);
> +			}
> +		}

Curious programming.
The 'normal' way would be using plain if statements and gotos.
Please fix.
And check if the cleanup is done correctly.

> +
> +		efct->desc = efct->hw.sli.modeldesc;
> +		efc_log_info(efct, "adapter model description: %s\n",
> +			      efct->desc);
> +
> +		if (rc == 0) {
> +			efct->attached = true;
> +		} else {
> +			efct_teardown_msix(efct);
> +			if (efct->xport) {
> +				efct_xport_free(efct->xport);
> +				efct->xport = NULL;
> +			}
> +		}
> +
> +		if (efct->efct_req_fw_upgrade) {
> +			efc_log_debug(efct, "firmware update is in progress\n");
> +			efct_request_firmware_update(efct);
> +		}
> +	}
> +
> +	return rc;
> +}
> +
> +static void
> +efct_stop_event_processing(struct efct *efct)
> +{
> +	u32 i;
> +	struct task_struct *thread = NULL;
> +
> +	for (i = 0; i < efct->n_msix_vec; i++) {
> +		disable_irq(efct->msix_vec[i].vector);
> +
> +		thread = efct->intr_context[i].thread;
> +		if (!thread)
> +			continue;
> +
> +		/* Call stop */
> +		kthread_stop(thread);
> +	}
> +}
> +
> +static int
> +efct_device_detach(struct efct *efct)
> +{
> +	int rc = 0;
> +
> +	if (efct) {
> +		if (!efct->attached) {
> +			efc_log_warn(efct, "Device is not attached\n");
> +			return -1;
> +		}
> +
> +		rc = efct_xport_control(efct->xport, EFCT_XPORT_SHUTDOWN);
> +		if (rc)
> +			efc_log_err(efct, "Transport Shutdown timed out\n");
> +
> +		efct_stop_event_processing(efct);
> +
> +		if (efct_xport_detach(efct->xport) != 0)
> +			efc_log_err(efct, "Transport detach failed\n");
> +
> +		efct_xport_free(efct->xport);
> +		efct->xport = NULL;
> +
> +		efcport_destroy(efct->efcport);
> +		kfree(efct->efcport);
> +
> +		efct->attached = false;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +efct_fw_reset(struct efct *efct)
> +{
> +	int rc = 0;
> +	int index = 0;
> +	u8 bus, dev;
> +	struct efct *other_efct;
> +
> +	bus = efct->pcidev->bus->number;
> +	dev = PCI_SLOT(efct->pcidev->devfn);
> +
> +	while ((other_efct = efct_get_instance(index++)) != NULL) {
> +		u8 other_bus, other_dev;
> +
> +		other_bus = other_efct->pcidev->bus->number;
> +		other_dev = PCI_SLOT(other_efct->pcidev->devfn);
> +
> +		if (bus == other_bus && dev == other_dev &&
> +		    timer_pending(&other_efct->xport->stats_timer)) {
> +			efc_log_debug(other_efct,
> +				       "removing link stats timer\n");
> +			del_timer(&other_efct->xport->stats_timer);
> +		}
> +	}
> +

???
You're not telling me you're doing a cross-PCI device reset, do you?
This does need some documentation explaining what it's trying to do and
why this is necessary.

> +	if (efct_hw_reset(&efct->hw, EFCT_HW_RESET_FIRMWARE)) {
> +		efc_log_test(efct, "failed to reset firmware\n");
> +		rc = -1;
> +	} else {
> +		efc_log_debug(efct,
> +			       "successfully reset firmware.Now resetting port\n");
> +		/* now flag all functions on the same device
> +		 * as this port as uninitialized
> +		 */
> +		index = 0;
> +
> +		while ((other_efct = efct_get_instance(index++)) != NULL) {
> +			u8 other_bus, other_dev;
> +
> +			other_bus = other_efct->pcidev->bus->number;
> +			other_dev = PCI_SLOT(other_efct->pcidev->devfn);
> +
> +			if (bus == other_bus && dev == other_dev) {
> +				if (other_efct->hw.state !=
> +						EFCT_HW_STATE_UNINITIALIZED) {
> +					other_efct->hw.state =
> +						EFCT_HW_STATE_QUEUES_ALLOCATED;
> +				}
> +				efct_device_detach(efct);
> +				rc = efct_device_attach(efct);
> +
> +				efc_log_debug(other_efct,
> +					       "re-start driver with new firmware\n");
> +			}
> +		}
> +	}
> +	return rc;
> +}
> +

Similar here.

> +static void
> +efct_fw_write_cb(int status, u32 actual_write_length,
> +		 u32 change_status, void *arg)
> +{
> +	struct efct_fw_write_result *result = arg;
> +
> +	result->status = status;
> +	result->actual_xfer = actual_write_length;
> +	result->change_status = change_status;
> +
> +	complete(&result->done);
> +}
> +
> +static int
> +efct_firmware_write(struct efct *efct, const u8 *buf, size_t buf_len,
> +		    u8 *change_status)
> +{
> +	int rc = 0;
> +	u32 bytes_left;
> +	u32 xfer_size;
> +	u32 offset;
> +	struct efc_dma dma;
> +	int last = 0;
> +	struct efct_fw_write_result result;
> +
> +	init_completion(&result.done);
> +
> +	bytes_left = buf_len;
> +	offset = 0;
> +
> +	dma.size = FW_WRITE_BUFSIZE;
> +	dma.virt = dma_alloc_coherent(&efct->pcidev->dev,
> +				      dma.size, &dma.phys, GFP_DMA);
> +	if (!dma.virt)
> +		return -ENOMEM;
> +
> +	while (bytes_left > 0) {
> +		if (bytes_left > FW_WRITE_BUFSIZE)
> +			xfer_size = FW_WRITE_BUFSIZE;
> +		else
> +			xfer_size = bytes_left;
> +
> +		memcpy(dma.virt, buf + offset, xfer_size);
> +
> +		if (bytes_left == xfer_size)
> +			last = 1;
> +
> +		efct_hw_firmware_write(&efct->hw, &dma, xfer_size, offset,
> +				       last, efct_fw_write_cb, &result);
> +
> +		if (wait_for_completion_interruptible(&result.done) != 0) {
> +			rc = -ENXIO;
> +			break;
> +		}
> +
> +		if (result.actual_xfer == 0 || result.status != 0) {
> +			rc = -EFAULT;
> +			break;
> +		}
> +
> +		if (last)
> +			*change_status = result.change_status;
> +
> +		bytes_left -= result.actual_xfer;
> +		offset += result.actual_xfer;
> +	}
> +
> +	dma_free_coherent(&efct->pcidev->dev, dma.size, dma.virt, dma.phys);
> +	return rc;
> +}
> +
> +static int
> +efct_request_firmware_update(struct efct *efct)
> +{
> +	int rc = 0;
> +	u8 file_name[256], fw_change_status = 0;
> +	const struct firmware *fw;
> +	struct efct_hw_grp_hdr *fw_image;
> +
> +	snprintf(file_name, 256, "%s.grp", efct->model);
> +	rc = request_firmware(&fw, file_name, &efct->pcidev->dev);
> +	if (rc) {
> +		efc_log_err(efct, "Firmware file(%s) not found.\n", file_name);
> +		return rc;
> +	}
> +	fw_image = (struct efct_hw_grp_hdr *)fw->data;
> +
> +	/* Check if firmware provided is compatible with this particular
> +	 * Adapter of not
> +	 */
> +	if ((be32_to_cpu(fw_image->magic_number) != EFCT_HW_OBJECT_G5) &&
> +	    (be32_to_cpu(fw_image->magic_number) != EFCT_HW_OBJECT_G6)) {
> +		efc_log_warn(efct,
> +			      "Invalid FW image found Magic: 0x%x Size: %ld\n",
> +			be32_to_cpu(fw_image->magic_number), fw->size);
> +		rc = -1;
> +		goto exit;
> +	}
> +
> +	if (!strncmp(efct->fw_version, fw_image->revision,
> +		     strnlen(fw_image->revision, 16))) {
> +		efc_log_debug(efct,
> +			       "No update req. Firmware is already up to date.\n");
> +		rc = 0;
> +		goto exit;
> +	}
> +	rc = efct_firmware_write(efct, fw->data, fw->size, &fw_change_status);
> +	if (rc) {
> +		efc_log_err(efct,
> +			     "Firmware update failed. Return code = %d\n", rc);
> +	} else {
> +		efc_log_info(efct, "Firmware updated successfully\n");
> +		switch (fw_change_status) {
> +		case 0x00:
> +			efc_log_debug(efct,
> +				       "No reset needed, new firmware is active.\n");
> +			break;
> +		case 0x01:
> +			efc_log_warn(efct,
> +				      "A physical device reset (host reboot) is needed to activate the new firmware\n");
> +			break;
> +		case 0x02:
> +		case 0x03:
> +			efc_log_debug(efct,
> +				       "firmware is resetting to activate the new firmware\n");
> +			efct_fw_reset(efct);
> +			break;
> +		default:
> +			efc_log_debug(efct,
> +				       "Unexected value change_status: %d\n",
> +				fw_change_status);
> +			break;
> +		}
> +	}
> +
> +exit:
> +	release_firmware(fw);
> +
> +	return rc;
> +}
> +
> +static void
> +efct_device_free(struct efct *efct)
> +{
> +	if (efct) {
> +		efct_devices[efct->instance_index] = NULL;
> +
> +		kfree(efct);
> +	}
> +}
> +
> +static int
> +efct_device_interrupts_required(struct efct *efct)
> +{
> +	if (efct_hw_setup(&efct->hw, efct, efct->pcidev)
> +				!= EFCT_HW_RTN_SUCCESS) {
> +		return -1;
> +	}
> +	return efct_hw_qtop_eq_count(&efct->hw);
> +}
> +
> +static irqreturn_t
> +efct_intr_msix(int irq, void *handle)
> +{
> +	struct efct_intr_context *intr_context = handle;
> +
> +	complete(&intr_context->done);
> +	return IRQ_HANDLED;
> +}
> +
> +static int
> +efct_setup_msix(struct efct *efct, u32 num_interrupts)
> +{
> +	int	rc = 0;
> +	u32 i;
> +
> +	if (!pci_find_capability(efct->pcidev, PCI_CAP_ID_MSIX)) {
> +		dev_err(&efct->pcidev->dev,
> +			"%s : MSI-X not available\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	if (num_interrupts > ARRAY_SIZE(efct->msix_vec)) {
> +		dev_err(&efct->pcidev->dev,
> +			"%s : num_interrupts: %d greater than vectors\n",
> +			__func__, num_interrupts);
> +		return -1;
> +	}
> +
> +	efct->n_msix_vec = num_interrupts;
> +	for (i = 0; i < num_interrupts; i++)
> +		efct->msix_vec[i].entry = i;
> +
> +	rc = pci_enable_msix_exact(efct->pcidev,
> +				   efct->msix_vec, efct->n_msix_vec);
> +	if (!rc) {
> +		for (i = 0; i < num_interrupts; i++) {
> +			rc = request_irq(efct->msix_vec[i].vector,
> +					 efct_intr_msix,
> +					 0, EFCT_DRIVER_NAME,
> +					 &efct->intr_context[i]);
> +			if (rc)
> +				break;
> +		}
> +	} else {
> +		dev_err(&efct->pcidev->dev,
> +			"%s : rc % d returned, IRQ allocation failed\n",
> +			   __func__, rc);
> +	}
> +
> +	return rc;
> +}

Interrupt affinity?

> +
> +static struct pci_device_id efct_pci_table[] = {
> +	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_ID_LPE31004), 0},
> +	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_ID_G7), 0},
> +	{}	/* terminate list */
> +};
> +

Ah. What happened to the G6 HW mentioned at the top?

> +static int
> +efct_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct efct *efct = NULL;
> +	int rc;
> +	u32 i, r;
> +	int num_interrupts = 0;
> +	int nid;
> +	struct task_struct *thread = NULL;
> +
> +	dev_info(&pdev->dev, "%s\n", EFCT_DRIVER_NAME);
> +
> +	rc = pci_enable_device_mem(pdev);
> +	if (rc)
> +		goto efct_pci_probe_err_enable;
> +
> +	pci_set_master(pdev);
> +
> +	rc = pci_set_mwi(pdev);
> +	if (rc) {
> +		dev_info(&pdev->dev,
> +			 "pci_set_mwi returned %d\n", rc);
> +		goto efct_pci_probe_err_set_mwi;
> +	}
> +
> +	rc = pci_request_regions(pdev, EFCT_DRIVER_NAME);
> +	if (rc) {
> +		dev_err(&pdev->dev, "pci_request_regions failed\n");
> +		goto efct_pci_probe_err_request_regions;
> +	}
> +
> +	/* Fetch the Numa node id for this device */
> +	nid = dev_to_node(&pdev->dev);
> +	if (nid < 0) {
> +		dev_err(&pdev->dev,
> +			"Warning Numa node ID is %d\n", nid);
> +		nid = 0;
> +	}
> +
> +	/* Allocate efct */
> +	efct = efct_device_alloc(nid);
> +	if (!efct) {
> +		dev_err(&pdev->dev, "Failed to allocate efct_t\n");
> +		rc = -ENOMEM;
> +		goto efct_pci_probe_err_efct_device_alloc;
> +	}
> +
> +	efct->pcidev = pdev;
> +
> +	if (efct->enable_numa_support)
> +		efct->numa_node = nid;
> +
> +	/* Map all memory BARs */
> +	for (i = 0, r = 0; i < EFCT_PCI_MAX_REGS; i++) {
> +		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
> +			efct->reg[r] = ioremap(pci_resource_start(pdev, i),
> +						  pci_resource_len(pdev, i));
> +			r++;
> +		}
> +
> +		/*
> +		 * If the 64-bit attribute is set, both this BAR and the
> +		 * next form the complete address. Skip processing the
> +		 * next BAR.
> +		 */
> +		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM_64)
> +			i++;
> +	}
> +
> +	pci_set_drvdata(pdev, efct);
> +
> +	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0 ||
> +	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {
> +		dev_warn(&pdev->dev,
> +			 "trying DMA_BIT_MASK(32)\n");
> +		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0 ||
> +		    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) {
> +			dev_err(&pdev->dev,
> +				"setting DMA_BIT_MASK failed\n");
> +			rc = -1;
> +			goto efct_pci_probe_err_setup_thread;
> +		}
> +	}
> +
> +	num_interrupts = efct_device_interrupts_required(efct);
> +	if (num_interrupts < 0) {
> +		efc_log_err(efct, "efct_device_interrupts_required failed\n");
> +		rc = -1;
> +		goto efct_pci_probe_err_setup_thread;
> +	}
> +
> +	/*
> +	 * Initialize MSIX interrupts, note,
> +	 * efct_setup_msix() enables the interrupt
> +	 */
> +	rc = efct_setup_msix(efct, num_interrupts);
> +	if (rc) {
> +		dev_err(&pdev->dev, "Can't setup msix\n");
> +		goto efct_pci_probe_err_setup_msix;
> +	}
> +	/* Disable interrupt for now */
> +	for (i = 0; i < efct->n_msix_vec; i++) {
> +		efc_log_debug(efct, "irq %d disabled\n",
> +			       efct->msix_vec[i].vector);
> +		disable_irq(efct->msix_vec[i].vector);
> +	}
> +
> +	rc = efct_device_attach((struct efct *)efct);
> +	if (rc)
> +		goto efct_pci_probe_err_setup_msix;
> +
> +	return 0;
> +
> +efct_pci_probe_err_setup_msix:
> +	for (i = 0; i < (u32)num_interrupts; i++) {
> +		thread = efct->intr_context[i].thread;
> +		if (!thread)
> +			continue;
> +
> +		/* Call stop */
> +		kthread_stop(thread);
> +	}
> +
> +efct_pci_probe_err_setup_thread:
> +	pci_set_drvdata(pdev, NULL);
> +
> +	for (i = 0; i < EFCT_PCI_MAX_REGS; i++) {
> +		if (efct->reg[i])
> +			iounmap(efct->reg[i]);
> +	}
> +	efct_device_free(efct);
> +efct_pci_probe_err_efct_device_alloc:
> +	pci_release_regions(pdev);
> +efct_pci_probe_err_request_regions:
> +	pci_clear_mwi(pdev);
> +efct_pci_probe_err_set_mwi:
> +	pci_disable_device(pdev);
> +efct_pci_probe_err_enable:
> +	return rc;
> +}
> +
> +static void
> +efct_pci_remove(struct pci_dev *pdev)
> +{
> +	struct efct *efct = pci_get_drvdata(pdev);
> +	u32	i;
> +
> +	if (!efct)
> +		return;
> +
> +	efct_device_detach(efct);
> +
> +	efct_teardown_msix(efct);
> +
> +	for (i = 0; i < EFCT_PCI_MAX_REGS; i++) {
> +		if (efct->reg[i])
> +			iounmap(efct->reg[i]);
> +	}
> +
> +	pci_set_drvdata(pdev, NULL);
> +
> +	efct_devices[efct->instance_index] = NULL;
> +
> +	efct_device_free(efct);
> +
> +	pci_release_regions(pdev);
> +
> +	pci_disable_device(pdev);
> +}
> +
> +static void
> +efct_device_prep_for_reset(struct efct *efct, struct pci_dev *pdev)
> +{
> +	if (efct) {
> +		efc_log_debug(efct,
> +			       "PCI channel disable preparing for reset\n");
> +		efct_device_detach(efct);
> +		/* Disable interrupt and pci device */
> +		efct_teardown_msix(efct);
> +	}
> +	pci_disable_device(pdev);
> +}
> +
> +static void
> +efct_device_prep_for_recover(struct efct *efct)
> +{
> +	if (efct) {
> +		efc_log_debug(efct, "PCI channel preparing for recovery\n");
> +		efct_hw_io_abort_all(&efct->hw);
> +	}
> +}
> +
> +/**
> + * efct_pci_io_error_detected - method for handling PCI I/O error
> + * @pdev: pointer to PCI device.
> + * @state: the current PCI connection state.
> + *
> + * This routine is registered to the PCI subsystem for error handling. This
> + * function is called by the PCI subsystem after a PCI bus error affecting
> + * this device has been detected. When this routine is invoked, it dispatches
> + * device error detected handling routine, which will perform the proper
> + * error detected operation.
> + *
> + * Return codes
> + * PCI_ERS_RESULT_NEED_RESET - need to reset before recovery
> + * PCI_ERS_RESULT_DISCONNECT - device could not be recovered
> + */
> +static pci_ers_result_t
> +efct_pci_io_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
> +{
> +	struct efct *efct = pci_get_drvdata(pdev);
> +	pci_ers_result_t rc;
> +
> +	switch (state) {
> +	case pci_channel_io_normal:
> +		efct_device_prep_for_recover(efct);
> +		rc = PCI_ERS_RESULT_CAN_RECOVER;
> +		break;
> +	case pci_channel_io_frozen:
> +		efct_device_prep_for_reset(efct, pdev);
> +		rc = PCI_ERS_RESULT_NEED_RESET;
> +		break;
> +	case pci_channel_io_perm_failure:
> +		efct_device_detach(efct);
> +		rc = PCI_ERS_RESULT_DISCONNECT;
> +		break;
> +	default:
> +		efc_log_debug(efct, "Unknown PCI error state:0x%x\n",
> +			       state);
> +		efct_device_prep_for_reset(efct, pdev);
> +		rc = PCI_ERS_RESULT_NEED_RESET;
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +static pci_ers_result_t
> +efct_pci_io_slot_reset(struct pci_dev *pdev)
> +{
> +	int rc;
> +	struct efct *efct = pci_get_drvdata(pdev);
> +
> +	rc = pci_enable_device_mem(pdev);
> +	if (rc) {
> +		efc_log_err(efct,
> +			     "failed to re-enable PCI device after reset.\n");
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +
> +	/*
> +	 * As the new kernel behavior of pci_restore_state() API call clears
> +	 * device saved_state flag, need to save the restored state again.
> +	 */
> +
> +	pci_save_state(pdev);
> +
> +	pci_set_master(pdev);
> +
> +	rc = efct_setup_msix(efct, efct->n_msix_vec);
> +	if (rc)
> +		efc_log_err(efct, "rc %d returned, IRQ allocation failed\n",
> +			    rc);
> +
> +	/* Perform device reset */
> +	efct_device_detach(efct);
> +	/* Bring device to online*/
> +	efct_device_attach(efct);
> +
> +	return PCI_ERS_RESULT_RECOVERED;
> +}
> +
> +static void
> +efct_pci_io_resume(struct pci_dev *pdev)
> +{
> +	struct efct *efct = pci_get_drvdata(pdev);
> +
> +	/* Perform device reset */
> +	efct_device_detach(efct);
> +	/* Bring device to online*/
> +	efct_device_attach(efct);
> +}
> +
> +MODULE_DEVICE_TABLE(pci, efct_pci_table);
> +
> +static struct pci_error_handlers efct_pci_err_handler = {
> +	.error_detected = efct_pci_io_error_detected,
> +	.slot_reset = efct_pci_io_slot_reset,
> +	.resume = efct_pci_io_resume,
> +};
> +
> +static struct pci_driver efct_pci_driver = {
> +	.name		= EFCT_DRIVER_NAME,
> +	.id_table	= efct_pci_table,
> +	.probe		= efct_pci_probe,
> +	.remove		= efct_pci_remove,
> +	.err_handler	= &efct_pci_err_handler,
> +};
> +
> +static int efct_proc_get(struct seq_file *m, void *v)
> +{
> +	u32 i;
> +	u32 j;
> +	u32 device_count = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(efct_devices); i++) {
> +		if (efct_devices[i])
> +			device_count++;
> +	}
> +
> +	seq_printf(m, "%d\n", device_count);
> +
> +	for (i = 0; i < ARRAY_SIZE(efct_devices); i++) {
> +		if (efct_devices[i]) {
> +			struct efct *efct = efct_devices[i];
> +
> +			for (j = 0; j < efct->n_msix_vec; j++) {
> +				seq_printf(m, "%d,%d,%d\n", i,
> +					   efct->msix_vec[j].vector,
> +					-1);
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int efct_proc_open(struct inode *indoe, struct file *file)
> +{
> +	return single_open(file, efct_proc_get, NULL);
> +}
> +
> +static const struct file_operations efct_proc_fops = {
> +	.owner = THIS_MODULE,
> +	.open = efct_proc_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};
> +

Proc interface? Seriously?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
