Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B974DC32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 09:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D2582077B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 09:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgAIJr5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 04:47:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:34166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbgAIJr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 04:47:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BF409C11A;
        Thu,  9 Jan 2020 09:47:49 +0000 (UTC)
Subject: Re: [PATCH v2 12/32] elx: libefc: Remote node state machine
 interfaces
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-13-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <8b0c5225-a3bd-66e3-a39d-b44c9c06bba8@suse.de>
Date:   Thu, 9 Jan 2020 09:31:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-13-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 11:37 PM, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> - Remote node (aka remote port) allocation, initializaion and
>   destroy routines.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/libefc/efc_node.c | 1343 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/libefc/efc_node.h |  188 +++++
>  2 files changed, 1531 insertions(+)
>  create mode 100644 drivers/scsi/elx/libefc/efc_node.c
>  create mode 100644 drivers/scsi/elx/libefc/efc_node.h
> 
> diff --git a/drivers/scsi/elx/libefc/efc_node.c b/drivers/scsi/elx/libefc/efc_node.c
> new file mode 100644
> index 000000000000..57bf25a5d76a
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_node.c
> @@ -0,0 +1,1343 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#include "efc.h"
> +
> +/* HW node callback events from the user driver */
> +int
> +efc_remote_node_cb(void *arg, int event,
> +		   void *data)
> +{
> +	struct efc *efc = arg;
> +	enum efc_sm_event sm_event = EFC_EVT_LAST;
> +	struct efc_remote_node *rnode = data;
> +	struct efc_node *node = rnode->node;
> +	unsigned long flags = 0;
> +
> +	switch (event) {
> +	case EFC_HW_NODE_ATTACH_OK:
> +		sm_event = EFC_EVT_NODE_ATTACH_OK;
> +		break;
> +
> +	case EFC_HW_NODE_ATTACH_FAIL:
> +		sm_event = EFC_EVT_NODE_ATTACH_FAIL;
> +		break;
> +
> +	case EFC_HW_NODE_FREE_OK:
> +		sm_event = EFC_EVT_NODE_FREE_OK;
> +		break;
> +
> +	case EFC_HW_NODE_FREE_FAIL:
> +		sm_event = EFC_EVT_NOD> +	default:
> +		efc_log_test(efc, "unhandled event %#x\n", event);
> +		return -1;
> +	}
> +
> +	spin_lock_irqsave(&efc->lock, flags);
> +	efc_node_post_event(node, sm_event, NULL);
> +	spin_unlock_irqrestore(&efc->lock, flags);
> +
> +	return 0;
> +}
> +
> +/* Find an FC node structure given the FC port ID */
> +struct efc_node *
> +efc_node_find(struct efc_sli_port *sport, u32 port_id)
> +{
> +	struct efc_node *node;
> +
> +	node = efc_spv_get(sport->lookup, port_id);
> +	return node;
> +}
> +
> +int
> +efc_node_create_pool(struct efc *efc, u32 node_count)
> +{
> +	u32 i;
> +	struct efc_node *node;
> +	u64 max_xfer_size;
> +	struct efc_dma *dma;
> +
> +	efc->nodes_count = node_count;
> +
> +	efc->nodes = kmalloc_array(node_count, sizeof(struct efc_node *),
> +				   GFP_ATOMIC);
> +	if (!efc->nodes)
> +		return -1;
> +
> +	memset(efc->nodes, 0, node_count * sizeof(struct efc_node *));
> +
> +	if (efc->max_xfer_size)
> +		max_xfer_size = efc->max_xfer_size;
> +	else
> +		max_xfer_size = 65536;
> +
> +	INIT_LIST_HEAD(&efc->nodes_free_list);
> +
> +	for (i = 0; i < node_count; i++) {
> +		dma = NULL;
> +		node = kzalloc(sizeof(*node), GFP_ATOMIC);
> +		if (!node) {
> +			efc_log_err(efc, "node allocation failed");
> +			goto error;
> +		}
> +		/* Assign any persistent field values */
> +		node->instance_index = i;
> +		node->max_wr_xfer_size = max_xfer_size;
> +		node->rnode.indicator = U32_MAX;
> +
> +		dma = &node->sparm_dma_buf;
> +		dma->size = 256;
> +		dma->virt = dma_alloc_coherent(&efc->pcidev->dev, dma->size,
> +					       &dma->phys, GFP_DMA);
> +		if (!dma->virt) {
> +			kfree(node);
> +			efc_log_err(efc, "efc_dma_alloc failed");
> +			goto error;
> +		}
> +
> +		efc->nodes[i] = node;
> +		INIT_LIST_HEAD(&node->list_entry);
> +		list_add_tail(&node->list_entry, &efc->nodes_free_list);
> +	}
> +	return 0;
> +
> +error:
> +	efc_node_free_pool(efc);
> +	return -1;
> +}
> +

Can't you use a normal mempool here, and allocate the dma region when
required? I guess the node pool is used only infrequently, so
performance shouldn't be impacted ...
But it would reduce the pressure on the IOMMU, no?

[ .. ]
> +void efc_node_post_els_resp(struct efc_node *node,
> +			    enum efc_hw_node_els_event evt, void *arg)
> +{
> +	enum efc_sm_event sm_event = EFC_EVT_LAST;
> +	struct efc *efc = node->efc;
> +	unsigned long flags = 0;
> +
> +	switch (evt) {
> +	case EFC_HW_SRRS_ELS_REQ_OK:
> +		sm_event = EFC_EVT_SRRS_ELS_REQ_OK;
> +		break;
> +	case EFC_HW_SRRS_ELS_CMPL_OK:
> +		sm_event = EFC_EVT_SRRS_ELS_CMPL_OK;
> +		break;
> +	case EFC_HW_SRRS_ELS_REQ_FAIL:
> +		sm_event = EFC_EVT_SRRS_ELS_REQ_FAIL;
> +		break;
> +	case EFC_HW_SRRS_ELS_CMPL_FAIL:
> +		sm_event = EFC_EVT_SRRS_ELS_CMPL_FAIL;
> +		break;
> +	case EFC_HW_SRRS_ELS_REQ_RJT:
> +		sm_event = EFC_EVT_SRRS_ELS_REQ_RJT;
> +		break;
> +	case EFC_HW_ELS_REQ_ABORTED:
> +		sm_event = EFC_EVT_ELS_REQ_ABORTED;
> +		break;

Please collapse.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
