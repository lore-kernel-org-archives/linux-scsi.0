Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004B9C00523
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 08:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDB57206F0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 08:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgAHIWX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 03:22:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:53390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgAHIWX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 03:22:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8508FB2EC;
        Wed,  8 Jan 2020 08:22:19 +0000 (UTC)
Subject: Re: [PATCH v2 07/32] elx: libefc_sli: APIs to setup SLI library
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-8-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <8fa86591-9c1f-9b64-3641-b8eddb2a5c62@suse.de>
Date:   Wed, 8 Jan 2020 09:22:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-8-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 11:36 PM, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch adds APIS to initialize the library, initialize
> the SLI Port, reset firmware, terminate the SLI Port, and
> terminate the library.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/libefc_sli/sli4.c | 1222 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/libefc_sli/sli4.h |  552 +++++++++++++++-
>  2 files changed, 1773 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
> index 3cdabb917df6..e2bea34b445a 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.c
> +++ b/drivers/scsi/elx/libefc_sli/sli4.c
> @@ -4524,3 +4524,1225 @@ sli_cqe_async(struct sli4 *sli4, void *buf)
>  
>  	return rc;
>  }
> +
> +/* Determine if the chip FW is in a ready state */
> +int
> +sli_fw_ready(struct sli4 *sli4)
> +{
> +	u32 val;
> +	/*
> +	 * Is firmware ready for operation? Check needed depends on IF_TYPE
> +	 */
> +	val = sli_reg_read_status(sli4);
> +	return (val & SLI4_PORT_STATUS_RDY) ? 1 : 0;
> +}
> +

boolean?

> +static int
> +sli_sliport_reset(struct sli4 *sli4)
> +{
> +	u32 iter, val;
> +	int rc = -1;
> +
> +	val = SLI4_PORT_CTRL_IP;
> +	/* Initialize port, endian */
> +	writel(val, (sli4->reg[0] + SLI4_PORT_CTRL_REG));
> +
> +	for (iter = 0; iter < 3000; iter++) {
> +		mdelay(10);	/* 10 ms */
> +		if (sli_fw_ready(sli4) == 1) {
> +			rc = 0;
> +			break;
> +		}
> +	}
> +
> +	if (rc != 0)
> +		efc_log_crit(sli4, "port failed to become ready after initialization\n");
> +
> +	return rc;
> +}
> +

Same here?

> +static bool
> +sli_wait_for_fw_ready(struct sli4 *sli4, u32 timeout_ms)
> +{
> +	u32 iter = timeout_ms / (SLI4_INIT_PORT_DELAY_US / 1000);
> +	bool ready = false;
> +
> +	do {
> +		iter--;
> +		mdelay(10);	/* 10 ms */
> +		if (sli_fw_ready(sli4) == 1)
> +			ready = true;
> +	} while (!ready && (iter > 0));
> +
> +	return ready;
> +}
> +

See? It doesn't even hurt ...

> +static int
> +sli_fw_init(struct sli4 *sli4)
> +{
> +	bool ready;
> +
> +	/*
> +	 * Is firmware ready for operation?
> +	 */
> +	ready = sli_wait_for_fw_ready(sli4, SLI4_FW_READY_TIMEOUT_MSEC);
> +	if (!ready) {
> +		efc_log_crit(sli4, "FW status is NOT ready\n");
> +		return -1;
> +	}
> +
> +	/*
> +	 * Reset port to a known state
> +	 */
> +	if (sli_sliport_reset(sli4))
> +		return -1;
> +
> +	return 0;
> +}
> +

boolean?

[ .. ]
> +int
> +sli_init(struct sli4 *sli4)
> +{
> +	if (sli4->has_extents) {
> +		efc_log_info(sli4, "XXX need to implement extent allocation\n");
> +		return -1;
> +	}
> +
Ho-hum.
Maybe 'extend allocation not implemented' ?

[ .. ]
> +int
> +sli_resource_alloc(struct sli4 *sli4, enum sli4_resource rtype,
> +		   u32 *rid, u32 *index)
> +{
> +	int rc = 0;
> +	u32 size;
> +	u32 extent_idx;
> +	u32 item_idx;
> +	u32 position;
> +
> +	*rid = U32_MAX;
> +	*index = U32_MAX;
> +
> +	switch (rtype) {
> +	case SLI_RSRC_VFI:
> +	case SLI_RSRC_VPI:
> +	case SLI_RSRC_RPI:
> +	case SLI_RSRC_XRI:
> +		position =
> +		find_first_zero_bit(sli4->extent[rtype].use_map,
> +				    sli4->extent[rtype].map_size);
> +		if (position >= sli4->extent[rtype].map_size) {
> +			efc_log_err(sli4, "out of resource %d (alloc=%d)\n",
> +				    rtype, sli4->extent[rtype].n_alloc);
> +			rc = -1;
> +			break;
> +		}
> +		set_bit(position, sli4->extent[rtype].use_map);
> +		*index = position;
> +
> +		size = sli4->extent[rtype].size;
> +
> +		extent_idx = *index / size;
> +		item_idx   = *index % size;
> +
> +		*rid = sli4->extent[rtype].base[extent_idx] + item_idx;
> +
> +		sli4->extent[rtype].n_alloc++;
> +		break;
> +	default:
> +		rc = -1;
> +	}
> +
> +	return rc;
> +}
> +

Didn't you mention extent allocation is not implemented?
So is this a different type of extent?

> +int
> +sli_resource_free(struct sli4 *sli4,
> +		  enum sli4_resource rtype, u32 rid)
> +{
> +	int rc = -1;
> +	u32 x;
> +	u32 size, *base;
> +
> +	switch (rtype) {
> +	case SLI_RSRC_VFI:
> +	case SLI_RSRC_VPI:
> +	case SLI_RSRC_RPI:
> +	case SLI_RSRC_XRI:
> +		/*
> +		 * Figure out which extent contains the resource ID. I.e. find
> +		 * the extent such that
> +		 *   extent->base <= resource ID < extent->base + extent->size
> +		 */
> +		base = sli4->extent[rtype].base;
> +		size = sli4->extent[rtype].size;
> +
> +		/*
> +		 * In the case of FW reset, this may be cleared
> +		 * but the force_free path will still attempt to
> +		 * free the resource. Prevent a NULL pointer access.
> +		 */
> +		if (base) {
> +			for (x = 0; x < sli4->extent[rtype].number;
> +			     x++) {
> +				if (rid >= base[x] &&
> +				    (rid < (base[x] + size))) {
> +					rid -= base[x];
> +					clear_bit((x * size) + rid,
> +						  sli4->extent[rtype].use_map);
> +					rc = 0;
> +					break;
> +				}
> +			}
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +int
> +sli_resource_reset(struct sli4 *sli4, enum sli4_resource rtype)
> +{
> +	int rc = -1;
> +	u32 i;
> +
> +	switch (rtype) {
> +	case SLI_RSRC_VFI:
> +	case SLI_RSRC_VPI:
> +	case SLI_RSRC_RPI:
> +	case SLI_RSRC_XRI:
> +		for (i = 0; i < sli4->extent[rtype].map_size; i++)
> +			clear_bit(i, sli4->extent[rtype].use_map);
> +		rc = 0;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +int sli_raise_ue(struct sli4 *sli4, u8 dump)
> +{
> +	u32 val = 0;
> +#define FDD 2

Oh, come on.
You have defines for everything but the kitchen sink.
So why do you have to define this one inline?

> +	if (dump == FDD) {
> +		val = SLI4_PORT_CTRL_FDD | SLI4_PORT_CTRL_IP;
> +		writel(val, (sli4->reg[0] + SLI4_PORT_CTRL_REG));
> +	} else {
> +		val = SLI4_PHYDEV_CTRL_FRST;
> +
> +		if (dump == 1)
> +			val |= SLI4_PHYDEV_CTRL_DD;
> +		writel(val, (sli4->reg[0] + SLI4_PHYDEV_CTRL_REG));
> +	}
> +
> +	return 0;
> +}
> +
> +int sli_dump_is_ready(struct sli4 *sli4)
> +{
> +	int rc = 0;
> +	u32 port_val;
> +	u32 bmbx_val;
> +
> +	/*
> +	 * Ensure that the port is ready AND the mailbox is
> +	 * ready before signaling that the dump is ready to go.
> +	 */
> +	port_val = sli_reg_read_status(sli4);
> +	bmbx_val = readl(sli4->reg[0] + SLI4_BMBX_REG);
> +
> +	if ((bmbx_val & SLI4_BMBX_RDY) &&
> +	    (port_val & SLI4_PORT_STATUS_RDY)) {
> +		if (port_val & SLI4_PORT_STATUS_DIP)
> +			rc = 1;
> +		else if (port_val & SLI4_PORT_STATUS_FDP)
> +			rc = 2;
> +	}
> +
> +	return rc;
> +}
> +

Please use defines for the return values here.
One has no idea why '1' or '2' is returned here.
At the very least some documentation.

> +int sli_dump_is_present(struct sli4 *sli4)
> +{
> +	u32 val;
> +	bool ready;
> +
> +	/* If the chip is not ready, then there cannot be a dump */
> +	ready = sli_wait_for_fw_ready(sli4, SLI4_INIT_PORT_DELAY_US);
> +	if (!ready)
> +		return 0;
> +
> +	val = sli_reg_read_status(sli4);
> +	if (val == U32_MAX) {
> +		efc_log_err(sli4, "error reading SLIPORT_STATUS\n");
> +		return -1;
> +	} else {
> +		return (val & SLI4_PORT_STATUS_DIP) ? 1 : 0;
> +	}
> +}
> +
> +int sli_reset_required(struct sli4 *sli4)
> +{
> +	u32 val;
> +
> +	val = sli_reg_read_status(sli4);
> +	if (val == U32_MAX) {
> +		efc_log_err(sli4, "error reading SLIPORT_STATUS\n");
> +		return -1;
> +	} else {
> +		return (val & SLI4_PORT_STATUS_RN) ? 1 : 0;
> +	}
> +}
> +
> +int
> +sli_cmd_post_sgl_pages(struct sli4 *sli4, void *buf, size_t size,
> +		       u16 xri,
> +		       u32 xri_count, struct efc_dma *page0[],
> +		       struct efc_dma *page1[], struct efc_dma *dma)
> +{
> +	struct sli4_rqst_post_sgl_pages *post = NULL;
> +	u32 i;
> +	__le32 req_len;
> +
> +	post = sli_config_cmd_init(sli4, buf, size,
> +				   SLI_CONFIG_PYLD_LENGTH(post_sgl_pages),
> +				   dma);
> +	if (!post)
> +		return EFC_FAIL;
> +
> +	/* payload size calculation */
> +	/* 4 = xri_start + xri_count */
> +	/* xri_count = # of XRI's registered */
> +	/* sizeof(uint64_t) = physical address size */
> +	/* 2 = # of physical addresses per page set */
> +	req_len = cpu_to_le32(4 + (xri_count * (sizeof(uint64_t) * 2)));
> +	sli_cmd_fill_hdr(&post->hdr, SLI4_OPC_POST_SGL_PAGES, SLI4_SUBSYSTEM_FC,
> +			 CMD_V0, req_len);
> +	post->xri_start = cpu_to_le16(xri);
> +	post->xri_count = cpu_to_le16(xri_count);
> +
> +	for (i = 0; i < xri_count; i++) {
> +		post->page_set[i].page0_low  =
> +				cpu_to_le32(lower_32_bits(page0[i]->phys));
> +		post->page_set[i].page0_high =
> +				cpu_to_le32(upper_32_bits(page0[i]->phys));
> +	}
> +
> +	if (page1) {
> +		for (i = 0; i < xri_count; i++) {
> +			post->page_set[i].page1_low =
> +				cpu_to_le32(lower_32_bits(page1[i]->phys));
> +			post->page_set[i].page1_high =
> +				cpu_to_le32(upper_32_bits(page1[i]->phys));
> +		}
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +

EFC_SUCCESS is back!
I've already missed them; none of the previous functions in this patch
use them.
Please fix.

[ .. ]
> +extern int
> +sli_cmd_unreg_vfi(struct sli4 *sli4, void *buf, size_t size,
> +		  u16 index, u32 which);
> +extern int
> +sli_cmd_common_nop(struct sli4 *sli4, void *buf, size_t size,
> +		   uint64_t context);
> +extern int
> +sli_cmd_common_get_resource_extent_info(struct sli4 *sli4, void *buf,
> +					size_t size, u16 rtype);
> +extern int
> +sli_cmd_common_get_sli4_parameters(struct sli4 *sli4,
> +				   void *buf, size_t size);
> +extern int
> +sli_cmd_common_write_object(struct sli4 *sli4, void *buf, size_t size,
> +			    u16 noc, u16 eof, u32 desired_write_length,
> +		u32 offset, char *object_name, struct efc_dma *dma);
> +extern int
> +sli_cmd_common_delete_object(struct sli4 *sli4, void *buf, size_t size,
> +			     char *object_name);
> +extern int
> +sli_cmd_common_read_object(struct sli4 *sli4, void *buf, size_t size,
> +			   u32 desired_read_length, u32 offset,
> +			   char *object_name, struct efc_dma *dma);
> +extern int
> +sli_cmd_dmtf_exec_clp_cmd(struct sli4 *sli4, void *buf, size_t size,
> +			  struct efc_dma *cmd, struct efc_dma *resp);
> +extern int
> +sli_cmd_common_set_dump_location(struct sli4 *sli4,
> +				 void *buf, size_t size, bool query,
> +				 bool is_buffer_list,
> +				 struct efc_dma *buffer, u8 fdb);
> +extern int
> +sli_cmd_common_set_features(struct sli4 *sli4, void *buf, size_t size,
> +			    u32 feature, u32 param_len,
> +			    void *parameter);
> +
> +int sli_cqe_mq(struct sli4 *sli4, void *buf);
> +int sli_cqe_async(struct sli4 *sli4, void *buf);
> +
> +extern int
> +sli_setup(struct sli4 *sli4, void *os, struct pci_dev  *pdev,
> +	  void __iomem *reg[]);
> +void sli_calc_max_qentries(struct sli4 *sli4);
> +int sli_init(struct sli4 *sli4);
> +int sli_reset(struct sli4 *sli4);
> +int sli_fw_reset(struct sli4 *sli4);
> +int sli_teardown(struct sli4 *sli4);
> +extern int
> +sli_callback(struct sli4 *sli4, enum sli4_callback which,
> +	     void *func, void *arg);
> +extern int
> +sli_bmbx_command(struct sli4 *sli4);
> +extern int
> +__sli_queue_init(struct sli4 *sli4, struct sli4_queue *q,
> +		 u32 qtype, size_t size, u32 n_entries,
> +		      u32 align);
> +extern int
> +__sli_create_queue(struct sli4 *sli4, struct sli4_queue *q);
> +extern int
> +sli_eq_modify_delay(struct sli4 *sli4, struct sli4_queue *eq,
> +		    u32 num_eq, u32 shift, u32 delay_mult);
> +extern int
> +sli_queue_alloc(struct sli4 *sli4, u32 qtype,
> +		struct sli4_queue *q, u32 n_entries,
> +		     struct sli4_queue *assoc);
> +extern int
> +sli_cq_alloc_set(struct sli4 *sli4, struct sli4_queue *qs[],
> +		 u32 num_cqs, u32 n_entries, struct sli4_queue *eqs[]);
> +extern int
> +sli_get_queue_entry_size(struct sli4 *sli4, u32 qtype);
> +extern int
> +sli_queue_free(struct sli4 *sli4, struct sli4_queue *q,
> +	       u32 destroy_queues, u32 free_memory);
> +extern int
> +sli_queue_eq_arm(struct sli4 *sli4, struct sli4_queue *q, bool arm);
> +extern int
> +sli_queue_arm(struct sli4 *sli4, struct sli4_queue *q, bool arm);
> +
> +extern int
> +sli_wq_write(struct sli4 *sli4, struct sli4_queue *q,
> +	     u8 *entry);
> +extern int
> +sli_mq_write(struct sli4 *sli4, struct sli4_queue *q,
> +	     u8 *entry);
> +extern int
> +sli_rq_write(struct sli4 *sli4, struct sli4_queue *q,
> +	     u8 *entry);
> +extern int
> +sli_eq_read(struct sli4 *sli4, struct sli4_queue *q,
> +	    u8 *entry);
> +extern int
> +sli_cq_read(struct sli4 *sli4, struct sli4_queue *q,
> +	    u8 *entry);
> +extern int
> +sli_mq_read(struct sli4 *sli4, struct sli4_queue *q,
> +	    u8 *entry);
> +extern int
> +sli_queue_index(struct sli4 *sli4, struct sli4_queue *q);
> +extern int
> +_sli_queue_poke(struct sli4 *sli4, struct sli4_queue *q,
> +		u32 index, u8 *entry);
> +extern int
> +sli_queue_poke(struct sli4 *sli4, struct sli4_queue *q, u32 index,
> +	       u8 *entry);
> +extern int
> +sli_resource_alloc(struct sli4 *sli4, enum sli4_resource rtype,
> +		   u32 *rid, u32 *index);
> +extern int
> +sli_resource_free(struct sli4 *sli4, enum sli4_resource rtype,
> +		  u32 rid);
> +extern int
> +sli_resource_reset(struct sli4 *sli4, enum sli4_resource rtype);
> +extern int
> +sli_eq_parse(struct sli4 *sli4, u8 *buf, u16 *cq_id);
> +extern int
> +sli_cq_parse(struct sli4 *sli4, struct sli4_queue *cq, u8 *cqe,
> +	     enum sli4_qentry *etype, u16 *q_id);
> +

I guess you can reformat those; the linux line length is 80 characters,
and one really should use them ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
