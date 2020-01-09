Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9ABC3F68F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 07:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 179C2206ED
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 07:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgAIHQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 02:16:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:60432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbgAIHQt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 02:16:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AE552ACE3;
        Thu,  9 Jan 2020 07:16:46 +0000 (UTC)
Subject: Re: [PATCH v2 09/32] elx: libefc: Emulex FC discovery library APIs
 and definitions
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-10-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <6e83124d-a328-fa9f-a615-3f13b6bd34bd@suse.de>
Date:   Thu, 9 Jan 2020 08:16:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-10-jsmart2021@gmail.com>
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
> - SLI/Local FC port objects
> - efc_domain_s: FC domain (aka fabric) objects
> - efc_node_s: FC node (aka remote ports) objects
> - A sparse vector interface that manages lookup tables
>   for the objects.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/libefc/efc.h     |  99 ++++++
>  drivers/scsi/elx/libefc/efc_lib.c | 131 ++++++++
>  drivers/scsi/elx/libefc/efclib.h  | 637 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 867 insertions(+)
>  create mode 100644 drivers/scsi/elx/libefc/efc.h
>  create mode 100644 drivers/scsi/elx/libefc/efc_lib.c
>  create mode 100644 drivers/scsi/elx/libefc/efclib.h
> 
> diff --git a/drivers/scsi/elx/libefc/efc.h b/drivers/scsi/elx/libefc/efc.h
> new file mode 100644
> index 000000000000..ef7c83e44167
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc.h
> @@ -0,0 +1,99 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#ifndef __EFC_H__
> +#define __EFC_H__
> +
> +#include "../include/efc_common.h"
> +#include "efclib.h"
> +#include "efc_sm.h"
> +#include "efc_domain.h"
> +#include "efc_sport.h"
> +#include "efc_node.h"
> +#include "efc_fabric.h"
> +#include "efc_device.h"
> +
> +#define EFC_MAX_REMOTE_NODES			2048
> +
> +enum efc_hw_rtn {
> +	EFC_HW_RTN_SUCCESS = 0,
> +	EFC_HW_RTN_SUCCESS_SYNC = 1,
> +	EFC_HW_RTN_ERROR = -1,
> +	EFC_HW_RTN_NO_RESOURCES = -2,
> +	EFC_HW_RTN_NO_MEMORY = -3,
> +	EFC_HW_RTN_IO_NOT_ACTIVE = -4,
> +	EFC_HW_RTN_IO_ABORT_IN_PROGRESS = -5,
> +	EFC_HW_RTN_IO_PORT_OWNED_ALREADY_ABORTED = -6,
> +	EFC_HW_RTN_INVALID_ARG = -7,
> +};
> +

(Silent applause for the named enum :-)

> +#define EFC_HW_RTN_IS_ERROR(e) ((e) < 0)
> +
> +enum efc_scsi_del_initiator_reason {
> +	EFC_SCSI_INITIATOR_DELETED,
> +	EFC_SCSI_INITIATOR_MISSING,
> +};
> +
> +enum efc_scsi_del_target_reason {
> +	EFC_SCSI_TARGET_DELETED,
> +	EFC_SCSI_TARGET_MISSING,
> +};
> +
> +#define EFC_SCSI_CALL_COMPLETE			0
> +#define EFC_SCSI_CALL_ASYNC			1
> +
> +#define EFC_FC_ELS_DEFAULT_RETRIES		3
> +
> +/* Timeouts */
> +#define EFC_FC_ELS_SEND_DEFAULT_TIMEOUT		0
> +#define EFC_FC_FLOGI_TIMEOUT_SEC		5
> +#define EFC_FC_DOMAIN_SHUTDOWN_TIMEOUT_USEC	30000000
> +
> +#define domain_sm_trace(domain) \
> +	efc_log_debug(domain->efc, "[domain:%s] %-20s %-20s\n", \
> +		      domain->display_name, __func__, efc_sm_event_name(evt)) \
> +
> +#define domain_trace(domain, fmt, ...) \
> +	efc_log_debug(domain->efc, \
> +		      "[%s]" fmt, domain->display_name, ##__VA_ARGS__) \
> +
> +#define node_sm_trace() \
> +	efc_log_debug(node->efc, \
> +		"[%s] %-20s\n", node->display_name, efc_sm_event_name(evt)) \
> +
> +#define sport_sm_trace(sport) \
> +	efc_log_debug(sport->efc, \
> +		"[%s] %-20s\n", sport->display_name, efc_sm_event_name(evt)) \
> +
> +/**
> + * Sparse Vector API
> + *
> + * This is a trimmed down sparse vector implementation tuned to the problem of
> + * 24-bit FC_IDs. In this case, the 24-bit index value is broken down in three
> + * 8-bit values. These values are used to index up to three 256 element arrays.
> + * Arrays are allocated, only when needed. @n @n

@n @n ?

> + * The lookup can complete in constant time (3 indexed array references). @n @n
> + * A typical use case would be that the fabric/directory FC_IDs would cause two
> + * rows to be allocated, and the fabric assigned remote nodes would cause two
> + * rows to be allocated, with the root row always allocated. This gives five
> + * rows of 256 x sizeof(void*), resulting in 10k.
> + */
> +
> +struct sparse_vector {
> +	struct efc *efc;
> +	u32 max_idx;
> +	void **array;
> +};
> +
> +#define SPV_ROWLEN	256
> +#define SPV_DIM		3
> +
Hmm. One wonders if xarrays wouldn't work better (and simpler to implement).

Have you looked at that?

> +void efc_spv_del(struct sparse_vector *spv);
> +struct sparse_vector *efc_spv_new(struct efc *efc);
> +void efc_spv_set(struct sparse_vector *sv, u32 idx, void *value);
> +void *efc_spv_get(struct sparse_vector *sv, u32 idx);
> +
> +#endif /* __EFC_H__ */
> diff --git a/drivers/scsi/elx/libefc/efc_lib.c b/drivers/scsi/elx/libefc/efc_lib.c
> new file mode 100644
> index 000000000000..9ab8538d6e1f
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_lib.c
> @@ -0,0 +1,131 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include "efc.h"
> +
> +int efcport_init(struct efc *efc)
> +{
> +	u32 rc = 0;
> +
> +	spin_lock_init(&efc->lock);
> +	INIT_LIST_HEAD(&efc->vport_list);
> +
> +	/* Create Node pool */
> +	rc = efc_node_create_pool(efc, EFC_MAX_REMOTE_NODES);
> +	if (rc)
> +		efc_log_err(efc, "Can't allocate node pool\n");
> +
> +	return rc;
> +}
> +
> +void efcport_destroy(struct efc *efc)
> +{
> +	efc_node_free_pool(efc);
> +}
> +
> +static void **efc_spv_new_row(u32 rowcount)
> +{
> +	return kzalloc(sizeof(void *) * rowcount, GFP_ATOMIC);
> +}
> +
> +/* Recursively delete the rows in this sparse vector */
> +static void
> +_efc_spv_del(struct efc *efc, void **a, u32 n, u32 depth)
> +{
> +	if (a) {
> +		if (depth) {
> +			u32 i;
> +
> +			for (i = 0; i < n; i++)
> +				_efc_spv_del(efc, a[i], n, depth - 1);
> +
> +			kfree(a);
> +		}
> +	}
> +}
> +
> +void
> +efc_spv_del(struct sparse_vector *spv)
> +{
> +	if (spv) {
> +		_efc_spv_del(spv->efc, spv->array, SPV_ROWLEN, SPV_DIM);
> +		kfree(spv);
> +	}
> +}
> +
> +struct sparse_vector
> +*efc_spv_new(struct efc *efc)
> +{
> +	struct sparse_vector *spv;
> +	u32 i;
> +
> +	spv = kzalloc(sizeof(*spv), GFP_ATOMIC);
> +	if (!spv)
> +		return NULL;
> +
> +	spv->efc = efc;
> +	spv->max_idx = 1;
> +	for (i = 0; i < SPV_DIM; i++)
> +		spv->max_idx *= SPV_ROWLEN;
> +
> +	return spv;
> +}
> +
> +static void
> +*efc_spv_new_cell(struct sparse_vector *sv, u32 idx, bool alloc_new_rows)
> +{
> +	void **p;
> +	u32 a = (idx >> 16) & 0xff;
> +	u32 b = (idx >>  8) & 0xff;
> +	u32 c = (idx >>  0) & 0xff;
> +
> +	if (idx >= sv->max_idx)
> +		return NULL;
> +
> +	if (!sv->array) {
> +		sv->array = (alloc_new_rows ?
> +			     efc_spv_new_row(SPV_ROWLEN) : NULL);
> +		if (!sv->array)
> +			return NULL;
> +	}
> +	p = sv->array;
> +	if (!p[a]) {
> +		p[a] = (alloc_new_rows ? efc_spv_new_row(SPV_ROWLEN) : NULL);
> +		if (!p[a])
> +			return NULL;
> +	}
> +	p = p[a];
> +	if (!p[b]) {
> +		p[b] = (alloc_new_rows ? efc_spv_new_row(SPV_ROWLEN) : NULL);
> +		if (!p[b])
> +			return NULL;
> +	}
> +	p = p[b];
> +
> +	return &p[c];
> +}
> +
> +void
> +efc_spv_set(struct sparse_vector *sv, u32 idx, void *value)
> +{
> +	void **ref = efc_spv_new_cell(sv, idx, true);
> +
> +	if (ref)
> +		*ref = value;
> +}
> +
> +void
> +*efc_spv_get(struct sparse_vector *sv, u32 idx)
> +{
> +	void **ref = efc_spv_new_cell(sv, idx, false);
> +
> +	if (ref)
> +		return *ref;
> +
> +	return NULL;
> +}
What about locking?

But maybe it'll clarify itself with the next patches.
Let's see.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
