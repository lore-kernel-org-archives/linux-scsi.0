Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5004C32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 07:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A227F20673
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 07:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgAIHet (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 02:34:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:36938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbgAIHes (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 02:34:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 434F1AE17;
        Thu,  9 Jan 2020 07:34:44 +0000 (UTC)
Subject: Re: [PATCH v2 11/32] elx: libefc: SLI and FC PORT state machine
 interfaces
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-12-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <aee9880a-81d4-7e31-bb9d-d33e7ca375d8@suse.de>
Date:   Thu, 9 Jan 2020 08:34:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-12-jsmart2021@gmail.com>
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
> - SLI and FC port (aka n_port_id) registration, allocation and
>   deallocation.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/libefc/efc_sport.c | 843 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/libefc/efc_sport.h |  52 +++
>  2 files changed, 895 insertions(+)
>  create mode 100644 drivers/scsi/elx/libefc/efc_sport.c
>  create mode 100644 drivers/scsi/elx/libefc/efc_sport.h
> 
> diff --git a/drivers/scsi/elx/libefc/efc_sport.c b/drivers/scsi/elx/libefc/efc_sport.c
> new file mode 100644
> index 000000000000..11f3ba73ec6e
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_sport.c
> @@ -0,0 +1,843 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +/*
> + * Details SLI port (sport) functions.
> + */
> +
> +#include "efc.h"
> +
> +/* HW sport callback events from the user driver */
> +int
> +efc_lport_cb(void *arg, int event, void *data)
> +{
> +	struct efc *efc = arg;
> +	struct efc_sli_port *sport = data;
> +
> +	switch (event) {
> +	case EFC_HW_PORT_ALLOC_OK:
> +		efc_log_debug(efc, "EFC_HW_PORT_ALLOC_OK\n");
> +		efc_sm_post_event(&sport->sm, EFC_EVT_SPORT_ALLOC_OK, NULL);
> +		break;
> +	case EFC_HW_PORT_ALLOC_FAIL:
> +		efc_log_debug(efc, "EFC_HW_PORT_ALLOC_FAIL\n");
> +		efc_sm_post_event(&sport->sm, EFC_EVT_SPORT_ALLOC_FAIL, NULL);
> +		break;
> +	case EFC_HW_PORT_ATTACH_OK:
> +		efc_log_debug(efc, "EFC_HW_PORT_ATTACH_OK\n");
> +		efc_sm_post_event(&sport->sm, EFC_EVT_SPORT_ATTACH_OK, NULL);
> +		break;
> +	case EFC_HW_PORT_ATTACH_FAIL:
> +		efc_log_debug(efc, "EFC_HW_PORT_ATTACH_FAIL\n");
> +		efc_sm_post_event(&sport->sm,
> +				  EFC_EVT_SPORT_ATTACH_FAIL, NULL);
> +		break;
> +	case EFC_HW_PORT_FREE_OK:
> +		efc_log_debug(efc, "EFC_HW_PORT_FREE_OK\n");
> +		efc_sm_post_event(&sport->sm, EFC_EVT_SPORT_FREE_OK, NULL);
> +		break;
> +	case EFC_HW_PORT_FREE_FAIL:
> +		efc_log_debug(efc, "EFC_HW_PORT_FREE_FAIL\n");
> +		efc_sm_post_event(&sport->sm, EFC_EVT_SPORT_FREE_FAIL, NULL);
> +		break;
> +	default:
> +		efc_log_test(efc, "unknown event %#x\n", event);
> +	}
> +
> +	return 0;
> +}
> +

Same here; please use the name mapping function and collapse the cases.

> +struct efc_sli_port *
> +efc_sport_alloc(struct efc_domain *domain, uint64_t wwpn, uint64_t wwnn,
> +		u32 fc_id, bool enable_ini, bool enable_tgt)
> +{
> +	struct efc_sli_port *sport;
> +
> +	if (domain->efc->enable_ini)
> +		enable_ini = 0;
> +
> +	/* Return a failure if this sport has already been allocated */
> +	if (wwpn != 0) {
> +		sport = efc_sport_find_wwn(domain, wwnn, wwpn);
> +		if (sport) {
> +			efc_log_err(domain->efc,
> +				    "Failed: SPORT %016llX %016llX already allocated\n",
> +				    wwnn, wwpn);
> +			return NULL;
> +		}
> +	}
> +
> +	sport = kzalloc(sizeof(*sport), GFP_ATOMIC);
> +	if (!sport)
> +		return sport;
> +
> +	sport->efc = domain->efc;
> +	snprintf(sport->display_name, sizeof(sport->display_name), "------");
> +	sport->domain = domain;
> +	sport->lookup = efc_spv_new(domain->efc);
> +	sport->instance_index = domain->sport_instance_count++;
> +	INIT_LIST_HEAD(&sport->node_list);
> +	sport->sm.app = sport;
> +	sport->enable_ini = enable_ini;
> +	sport->enable_tgt = enable_tgt;
> +	sport->enable_rscn = (sport->enable_ini ||
> +			(sport->enable_tgt && enable_target_rscn(sport->efc)));
> +
> +	/* Copy service parameters from domain */
> +	memcpy(sport->service_params, domain->service_params,
> +		sizeof(struct fc_els_flogi));
> +
> +	/* Update requested fc_id */
> +	sport->fc_id = fc_id;
> +
> +	/* Update the sport's service parameters for the new wwn's */
> +	sport->wwpn = wwpn;
> +	sport->wwnn = wwnn;
> +	snprintf(sport->wwnn_str, sizeof(sport->wwnn_str), "%016llX", wwnn);
> +
> +	/*
> +	 * if this is the "first" sport of the domain,
> +	 * then make it the "phys" sport
> +	 */
> +	if (list_empty(&domain->sport_list))
> +		domain->sport = sport;
> +
> +	INIT_LIST_HEAD(&sport->list_entry);
> +	list_add_tail(&sport->list_entry, &domain->sport_list);
> +
> +	efc_log_debug(domain->efc, "[%s] allocate sport\n",
> +		      sport->display_name);
> +
> +	return sport;
> +}

And this is what I meant with missing locking; if this function is
called concurrently with the same wwnn you might end up with two
identical entries in the sport list.
At the very lease explain why this is safe; but still I would prefer
locking here.

> +
> +void
> +efc_sport_free(struct efc_sli_port *sport)
> +{
> +	struct efc_domain *domain;
> +
> +	if (!sport)
> +		return;
> +
> +	domain = sport->domain;
> +	efc_log_debug(domain->efc, "[%s] free sport\n", sport->display_name);
> +	list_del(&sport->list_entry);
> +	/*
> +	 * if this is the physical sport,
> +	 * then clear it out of the domain
> +	 */
> +	if (sport == domain->sport)
> +		domain->sport = NULL;
> +
> +	efc_spv_del(sport->lookup);
> +	sport->lookup = NULL;
> +
> +	efc_spv_set(domain->lookup, sport->fc_id, NULL);
> +
> +	if (list_empty(&domain->sport_list))
> +		efc_domain_post_event(domain, EFC_EVT_ALL_CHILD_NODES_FREE,
> +				      NULL);
> +
> +	kfree(sport);
> +}
> +
> +void
> +efc_sport_force_free(struct efc_sli_port *sport)
> +{
> +	struct efc_node *node;
> +	struct efc_node *next;
> +
> +	/* shutdown sm processing */
> +	efc_sm_disable(&sport->sm);
> +
> +	list_for_each_entry_safe(node, next, &sport->node_list, list_entry) {
> +		efc_node_force_free(node);
> +	}
> +
> +	efc_sport_free(sport);
> +}
> +
> +/* Find a SLI port object, given an FC_ID */
> +struct efc_sli_port *
> +efc_sport_find(struct efc_domain *domain, u32 d_id)
> +{
> +	struct efc_sli_port *sport;
> +
> +	if (!domain->lookup) {
> +		efc_log_test(domain->efc,
> +			     "assertion failed: domain->lookup is not valid\n");
> +		return NULL;
> +	}
> +
> +	sport = efc_spv_get(domain->lookup, d_id);
> +	return sport;
> +}
> +
> +/* Find a SLI port, given the WWNN and WWPN */
> +struct efc_sli_port *
> +efc_sport_find_wwn(struct efc_domain *domain, uint64_t wwnn, uint64_t wwpn)
> +{
> +	struct efc_sli_port *sport = NULL;
> +
> +	list_for_each_entry(sport, &domain->sport_list, list_entry) {
> +		if (sport->wwnn == wwnn && sport->wwpn == wwpn)
> +			return sport;
> +	}
> +	return NULL;
> +}
> +
> +/* External call to request an attach for a sport, given an FC_ID */
> +int
> +efc_sport_attach(struct efc_sli_port *sport, u32 fc_id)
> +{
> +	int rc;
> +	struct efc_node *node;
> +	struct efc *efc = sport->efc;
> +
> +	/* Set our lookup */
> +	efc_spv_set(sport->domain->lookup, fc_id, sport);
> +
> +	/* Update our display_name */
> +	efc_node_fcid_display(fc_id, sport->display_name,
> +			      sizeof(sport->display_name));
> +
> +	list_for_each_entry(node, &sport->node_list, list_entry) {
> +		efc_node_update_display_name(node);
> +	}
> +
> +	efc_log_debug(sport->efc, "[%s] attach sport: fc_id x%06x\n",
> +		      sport->display_name, fc_id);
> +
> +	rc = efc->tt.hw_port_attach(efc, sport, fc_id);
> +	if (rc != EFC_HW_RTN_SUCCESS) {
> +		efc_log_err(sport->efc,
> +			    "efc_hw_port_attach failed: %d\n", rc);
> +		return -1;
> +	}
> +	return 0;
> +}
> +
> +static void
> +efc_sport_shutdown(struct efc_sli_port *sport)
> +{
> +	struct efc *efc = sport->efc;
> +	struct efc_node *node;
> +	struct efc_node *node_next;
> +
> +	list_for_each_entry_safe(node, node_next,
> +				 &sport->node_list, list_entry) {
> +		if (node->rnode.fc_id != FC_FID_FLOGI ||
> +		    !sport->is_vport) {
> +			efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
> +			continue;
> +		}
> +
> +		/*
> +		 * If this is a vport, logout of the fabric
> +		 * controller so that it deletes the vport
> +		 * on the switch.
> +		 */
> +		/* if link is down, don't send logo */
> +		if (efc->link_status == EFC_LINK_STATUS_DOWN) {
> +			efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
> +		} else {
> +			efc_log_debug(efc,
> +				      "[%s] sport shutdown vport, sending logo to node\n",
> +				      node->display_name);
> +
> +			if (efc->tt.els_send(efc, node, ELS_LOGO,
> +					     EFC_FC_FLOGI_TIMEOUT_SEC,
> +					EFC_FC_ELS_DEFAULT_RETRIES)) {
> +				/* sent LOGO, wait for response */
> +				efc_node_transition(node,
> +						    __efc_d_wait_logo_rsp,
> +						     NULL);
> +				continue;
> +			}
> +
> +			/*
> +			 * failed to send LOGO,
> +			 * go ahead and cleanup node anyways
> +			 */
> +			node_printf(node, "Failed to send LOGO\n");
> +			efc_node_post_event(node,
> +					    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
> +					    NULL);
> +		}
> +	}
> +}
> +
> +/* Clear the sport reference in the vport specification */
> +static void
> +efc_vport_link_down(struct efc_sli_port *sport)
> +{
> +	struct efc *efc = sport->efc;
> +	struct efc_vport_spec *vport;
> +
> +	list_for_each_entry(vport, &efc->vport_list, list_entry) {
> +		if (vport->sport == sport) {
> +			vport->sport = NULL;
> +			break;
> +		}
> +	}
> +}
> +

Similar here: Why is there no locking?
Or RCU lists?

> +static void *
> +__efc_sport_common(const char *funcname, struct efc_sm_ctx *ctx,
> +		   enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_sli_port *sport = ctx->app;
> +	struct efc_domain *domain = sport->domain;
> +	struct efc *efc = sport->efc;
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +	case EFC_EVT_REENTER:
> +	case EFC_EVT_EXIT:
> +	case EFC_EVT_ALL_CHILD_NODES_FREE:
> +		break;
> +	case EFC_EVT_SPORT_ATTACH_OK:
> +			efc_sm_transition(ctx, __efc_sport_attached, NULL);
> +		break;
> +	case EFC_EVT_SHUTDOWN: {
> +		int node_list_empty;
> +
> +		/* Flag this sport as shutting down */
> +		sport->shutting_down = true;
> +
> +		if (sport->is_vport)
> +			efc_vport_link_down(sport);
> +
> +		node_list_empty = list_empty(&sport->node_list);
> +
> +		if (node_list_empty) {
> +			/* sm: node list is empty / efc_hw_port_free */
> +			/*
> +			 * Remove the sport from the domain's
> +			 * sparse vector lookup table
> +			 */
> +			efc_spv_set(domain->lookup, sport->fc_id, NULL);
> +			efc_sm_transition(ctx, __efc_sport_wait_port_free,
> +					  NULL);
> +			if (efc->tt.hw_port_free(efc, sport)) {
> +				efc_log_test(sport->efc,
> +					     "efc_hw_port_free failed\n");
> +				/* Not much we can do, free the sport anyways */
> +				efc_sport_free(sport);
> +			}
> +		} else {
> +			/* sm: node list is not empty / shutdown nodes */
> +			efc_sm_transition(ctx,
> +					  __efc_sport_wait_shutdown, NULL);
> +			efc_sport_shutdown(sport);
> +		}
> +		break;
> +	}
> +	default:
> +		efc_log_test(sport->efc, "[%s] %-20s %-20s not handled\n",
> +			     sport->display_name, funcname,
> +			     efc_sm_event_name(evt));
> +		break;
> +	}
> +
> +	return NULL;
> +}
> +
> +/* SLI port state machine: Physical sport allocated */
> +void *
> +__efc_sport_allocated(struct efc_sm_ctx *ctx,
> +		      enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_sli_port *sport = ctx->app;
> +	struct efc_domain *domain = sport->domain;
> +
> +	sport_sm_trace(sport);
> +
> +	switch (evt) {
> +	/* the physical sport is attached */
> +	case EFC_EVT_SPORT_ATTACH_OK:
> +		efc_assert(sport == domain->sport, NULL);
> +		efc_sm_transition(ctx, __efc_sport_attached, NULL);
> +		break;
> +
> +	case EFC_EVT_SPORT_ALLOC_OK:
> +		/* ignore */
> +		break;
> +	default:
> +		__efc_sport_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +/* SLI port state machine: Handle initial virtual port events */
> +void *
> +__efc_sport_vport_init(struct efc_sm_ctx *ctx,
> +		       enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_sli_port *sport = ctx->app;
> +	struct efc *efc = sport->efc;
> +
> +	sport_sm_trace(sport);
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER: {
> +		__be64 be_wwpn = cpu_to_be64(sport->wwpn);
> +
> +		if (sport->wwpn == 0)
> +			efc_log_debug(efc, "vport: letting f/w select WWN\n");
> +
> +		if (sport->fc_id != U32_MAX) {
> +			efc_log_debug(efc, "vport: hard coding port id: %x\n",
> +				      sport->fc_id);
> +		}
> +
> +		efc_sm_transition(ctx, __efc_sport_vport_wait_alloc, NULL);
> +		/* If wwpn is zero, then we'll let the f/w */
> +		if (efc->tt.hw_port_alloc(efc, sport, sport->domain,
> +					  sport->wwpn == 0 ? NULL :
> +					  (uint8_t *)&be_wwpn)) {
> +			efc_log_err(efc, "Can't allocate port\n");
> +			break;
> +		}
> +
> +		break;
> +	}
> +	default:
> +		__efc_sport_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +/**
> + * SLI port state machine:
> + * Wait for the HW SLI port allocation to complete
> + */
> +void *
> +__efc_sport_vport_wait_alloc(struct efc_sm_ctx *ctx,
> +			     enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_sli_port *sport = ctx->app;
> +	struct efc *efc = sport->efc;
> +
> +	sport_sm_trace(sport);
> +
> +	switch (evt) {
> +	case EFC_EVT_SPORT_ALLOC_OK: {
> +		struct fc_els_flogi *sp;
> +		struct efc_node *fabric;
> +
> +		sp = (struct fc_els_flogi *)sport->service_params;
> +		/*
> +		 * If we let f/w assign wwn's,
> +		 * then sport wwn's with those returned by hw
> +		 */
> +		if (sport->wwnn == 0) {
> +			sport->wwnn = be64_to_cpu(sport->sli_wwnn);
> +			sport->wwpn = be64_to_cpu(sport->sli_wwpn);
> +			snprintf(sport->wwnn_str, sizeof(sport->wwnn_str),
> +				 "%016llX", sport->wwpn);
> +		}
> +
> +		/* Update the sport's service parameters */
> +		sp->fl_wwpn = cpu_to_be64(sport->wwpn);
> +		sp->fl_wwnn = cpu_to_be64(sport->wwnn);
> +
> +		/*
> +		 * if sport->fc_id is uninitialized,
> +		 * then request that the fabric node use FDISC
> +		 * to find an fc_id.
> +		 * Otherwise we're restoring vports, or we're in
> +		 * fabric emulation mode, so attach the fc_id
> +		 */
> +		if (sport->fc_id == U32_MAX) {
> +			fabric = efc_node_alloc(sport, FC_FID_FLOGI, false,
> +						false);
> +			if (!fabric) {
> +				efc_log_err(efc, "efc_node_alloc() failed\n");
> +				return NULL;
> +			}
> +			efc_node_transition(fabric, __efc_vport_fabric_init,
> +					    NULL);
> +		} else {
> +			snprintf(sport->wwnn_str, sizeof(sport->wwnn_str),
> +				 "%016llX", sport->wwpn);
> +			efc_sport_attach(sport, sport->fc_id);
> +		}
> +		efc_sm_transition(ctx, __efc_sport_vport_allocated, NULL);
> +		break;
> +	}
> +	default:
> +		__efc_sport_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +/**
> + * SLI port state machine: virtual sport allocated.
> + *
> + * This state is entered after the sport is allocated;
> + * it then waits for a fabric node
> + * FDISC to complete, which requests a sport attach.
> + * The sport attach complete is handled in this state.
> + */
> +
> +void *
> +__efc_sport_vport_allocated(struct efc_sm_ctx *ctx,
> +			    enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_sli_port *sport = ctx->app;
> +	struct efc *efc = sport->efc;
> +
> +	sport_sm_trace(sport);
> +
> +	switch (evt) {
> +	case EFC_EVT_SPORT_ATTACH_OK: {
> +		struct efc_node *node;
> +
> +		/* Find our fabric node, and forward this event */
> +		node = efc_node_find(sport, FC_FID_FLOGI);
> +		if (!node) {
> +			efc_log_test(efc, "can't find node %06x\n",
> +				     FC_FID_FLOGI);
> +			break;
> +		}
> +		/* sm: / forward sport attach to fabric node */
> +		efc_node_post_event(node, evt, NULL);
> +		efc_sm_transition(ctx, __efc_sport_attached, NULL);
> +		break;
> +	}
> +	default:
> +		__efc_sport_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +static void
> +efc_vport_update_spec(struct efc_sli_port *sport)
> +{
> +	struct efc *efc = sport->efc;
> +	struct efc_vport_spec *vport;
> +
> +	list_for_each_entry(vport, &efc->vport_list, list_entry) {
> +		if (vport->sport == sport) {
> +			vport->wwnn = sport->wwnn;
> +			vport->wwpn = sport->wwpn;
> +			vport->tgt_data = sport->tgt_data;
> +			vport->ini_data = sport->ini_data;
> +			break;
> +		}
> +	}
> +}
> +
> +/* State entered after the sport attach has completed */
> +void *
> +__efc_sport_attached(struct efc_sm_ctx *ctx,
> +		     enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_sli_port *sport = ctx->app;
> +	struct efc *efc = sport->efc;
> +
> +	sport_sm_trace(sport);
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER: {
> +		struct efc_node *node;
> +
> +		efc_log_debug(efc,
> +			      "[%s] SPORT attached WWPN %016llX WWNN %016llX\n",
> +			      sport->display_name,
> +			      sport->wwpn, sport->wwnn);
> +
> +		list_for_each_entry(node, &sport->node_list, list_entry) {
> +			efc_node_update_display_name(node);
> +		}
> +
> +		sport->tgt_id = sport->fc_id;
> +
> +		efc->tt.new_sport(efc, sport);
> +
> +		/*
> +		 * Update the vport (if its not the physical sport)
> +		 * parameters
> +		 */
> +		if (sport->is_vport)
> +			efc_vport_update_spec(sport);
> +		break;
> +	}
> +
> +	case EFC_EVT_EXIT:
> +		efc_log_debug(efc,
> +			      "[%s] SPORT deattached WWPN %016llX WWNN %016llX\n",
> +			      sport->display_name,
> +			      sport->wwpn, sport->wwnn);
> +
> +		efc->tt.del_sport(efc, sport);
> +		break;
> +	default:
> +		__efc_sport_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +
> +/* SLI port state machine: Wait for the node shutdowns to complete */
> +void *
> +__efc_sport_wait_shutdown(struct efc_sm_ctx *ctx,
> +			  enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_sli_port *sport = ctx->app;
> +	struct efc_domain *domain = sport->domain;
> +	struct efc *efc = sport->efc;
> +
> +	sport_sm_trace(sport);
> +
> +	switch (evt) {
> +	case EFC_EVT_SPORT_ALLOC_OK:
> +	case EFC_EVT_SPORT_ALLOC_FAIL:
> +	case EFC_EVT_SPORT_ATTACH_OK:
> +	case EFC_EVT_SPORT_ATTACH_FAIL:
> +		/* ignore these events - just wait for the all free event */
> +		break;
> +
> +	case EFC_EVT_ALL_CHILD_NODES_FREE: {
> +		/*
> +		 * Remove the sport from the domain's
> +		 * sparse vector lookup table
> +		 */
> +		efc_spv_set(domain->lookup, sport->fc_id, NULL);
> +		efc_sm_transition(ctx, __efc_sport_wait_port_free, NULL);
> +		if (efc->tt.hw_port_free(efc, sport)) {
> +			efc_log_err(sport->efc, "efc_hw_port_free failed\n");
> +			/* Not much we can do, free the sport anyways */
> +			efc_sport_free(sport);
> +		}
> +		break;
> +	}
> +	default:
> +		__efc_sport_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +/* SLI port state machine: Wait for the HW's port free to complete */
> +void *
> +__efc_sport_wait_port_free(struct efc_sm_ctx *ctx,
> +			   enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_sli_port *sport = ctx->app;
> +
> +	sport_sm_trace(sport);
> +
> +	switch (evt) {
> +	case EFC_EVT_SPORT_ATTACH_OK:
> +		/* Ignore as we are waiting for the free CB */
> +		break;
> +	case EFC_EVT_SPORT_FREE_OK: {
> +		/* All done, free myself */
> +		/* sm: / efc_sport_free */
> +		efc_sport_free(sport);
> +		break;
> +	}
> +	default:
> +		__efc_sport_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +/* Use the vport specification to find the associated vports and start them */
> +int
> +efc_vport_start(struct efc_domain *domain)
> +{
> +	struct efc *efc = domain->efc;
> +	struct efc_vport_spec *vport;
> +	struct efc_vport_spec *next;
> +	struct efc_sli_port *sport;
> +	int rc = 0;
> +	u8 found = false;
> +
> +	list_for_each_entry_safe(vport, next, &efc->vport_list, list_entry) {
> +		if (!vport->sport) {
> +			found = true;
> +			break;
> +		}
> +	}
> +
> +	if (found && vport) {
> +		sport = efc_sport_alloc(domain, vport->wwpn,
> +					vport->wwnn, vport->fc_id,
> +					vport->enable_ini,
> +					vport->enable_tgt);
> +		vport->sport = sport;
> +		if (!sport) {
> +			rc = -1;
> +		} else {
> +			sport->is_vport = true;
> +			sport->tgt_data = vport->tgt_data;
> +			sport->ini_data = vport->ini_data;
> +
> +			efc_sm_transition(&sport->sm, __efc_sport_vport_init,
> +					  NULL);
> +		}
> +	}
> +
> +	return rc;
> +}
> +
> +/* Allocate a new virtual SLI port */
> +int
> +efc_sport_vport_new(struct efc_domain *domain, uint64_t wwpn, uint64_t wwnn,
> +		    u32 fc_id, bool ini, bool tgt, void *tgt_data,
> +		    void *ini_data, bool restore_vport)
> +{
> +	struct efc_sli_port *sport;
> +
> +	if (ini && domain->efc->enable_ini == 0) {
> +		efc_log_test(domain->efc,
> +			     "driver initiator functionality not enabled\n");
> +		return -1;
> +	}
> +
> +	if (tgt && domain->efc->enable_tgt == 0) {
> +		efc_log_test(domain->efc,
> +			     "driver target functionality not enabled\n");
> +		return -1;
> +	}
> +
> +	/*
> +	 * Create a vport spec if we need to recreate
> +	 * this vport after a link up event
> +	 */
> +	if (restore_vport) {
> +		if (efc_vport_create_spec(domain->efc, wwnn, wwpn, fc_id,
> +					  ini, tgt, tgt_data, ini_data)) {
> +			efc_log_test(domain->efc,
> +				     "failed to create vport object entry\n");
> +			return -1;
> +		}
> +		return efc_vport_start(domain);
> +	}
> +
> +	/* Allocate a sport */
> +	sport = efc_sport_alloc(domain, wwpn, wwnn, fc_id, ini, tgt);
> +
> +	if (!sport)
> +		return -1;
> +
> +	sport->is_vport = true;
> +	sport->tgt_data = tgt_data;
> +	sport->ini_data = ini_data;
> +

Isn't there a race condition?
The port is already allocated, but not fully populated.
Can someone access the sport before these three lines are executed?

> +	/* Transition to vport_init */
> +	efc_sm_transition(&sport->sm, __efc_sport_vport_init, NULL);
> +
> +	return 0;
> +}
> +
> +/* Remove a previously-allocated virtual port */
> +int
> +efc_sport_vport_del(struct efc *efc, struct efc_domain *domain,
> +		    u64 wwpn, uint64_t wwnn)
> +{
> +	struct efc_sli_port *sport;
> +	int found = 0;
> +	struct efc_vport_spec *vport;
> +	struct efc_vport_spec *next;
> +
> +	/* walk the efc_vport_list and remove from there */
> +	list_for_each_entry_safe(vport, next, &efc->vport_list, list_entry) {
> +		if (vport->wwpn == wwpn && vport->wwnn == wwnn) {
> +			list_del(&vport->list_entry);
> +			kfree(vport);
> +			break;
> +		}
> +	}
> +

Locking?


Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
