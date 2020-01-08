Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862B7C00523
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 07:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DB6320705
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 07:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgAHHY1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 02:24:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:35016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbgAHHY0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 02:24:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C4B34AD20;
        Wed,  8 Jan 2020 07:24:23 +0000 (UTC)
Subject: Re: [PATCH v2 02/32] elx: libefc_sli: SLI Descriptors and Queue
 entries
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-3-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <af4ccd39-dab9-b2bf-f77c-954b1fe3725d@suse.de>
Date:   Wed, 8 Jan 2020 08:24:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-3-jsmart2021@gmail.com>
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
> This patch add SLI-4 Data structures and defines for:
> - Buffer Descriptors (BDEs)
> - Scatter/Gather List elements (SGEs)
> - Queues and their Entry Descriptions for:
>    Event Queues (EQs), Completion Queues (CQs),
>    Receive Queues (RQs), and the Mailbox Queue (MQ).
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/include/efc_common.h |   25 +
>  drivers/scsi/elx/libefc_sli/sli4.h    | 1768 +++++++++++++++++++++++++++++++++
>  2 files changed, 1793 insertions(+)
>  create mode 100644 drivers/scsi/elx/include/efc_common.h
> 
> diff --git a/drivers/scsi/elx/include/efc_common.h b/drivers/scsi/elx/include/efc_common.h
> new file mode 100644
> index 000000000000..3fc48876c531
> --- /dev/null
> +++ b/drivers/scsi/elx/include/efc_common.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#ifndef __EFC_COMMON_H__
> +#define __EFC_COMMON_H__
> +
> +#include <linux/pci.h>
> +
> +#define EFC_SUCCESS 0
> +#define EFC_FAIL 1
> +
> +struct efc_dma {
> +	void		*virt;
> +	void            *alloc;
> +	dma_addr_t	phys;
> +
> +	size_t		size;
> +	size_t          len;
> +	struct pci_dev	*pdev;
> +};
> +
> +#endif /* __EFC_COMMON_H__ */
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
> index 02c671cf57ef..f86a9e72ed43 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.h
> +++ b/drivers/scsi/elx/libefc_sli/sli4.h
> @@ -12,6 +12,8 @@
>  #ifndef _SLI4_H
>  #define _SLI4_H
>  
> +#include "../include/efc_common.h"
> +
>  /*************************************************************************
>   * Common SLI-4 register offsets and field definitions
>   */
> @@ -236,4 +238,1770 @@ struct sli4_reg {
>  	u32	off;
>  };
>  
> +struct sli4_dmaaddr {
> +	__le32 low;
> +	__le32 high;
> +};
> +
> +/* a 3-word BDE with address 1st 2 words, length last word */
> +struct sli4_bufptr {
> +	struct sli4_dmaaddr addr;
> +	__le32 length;
> +};
> +
> +/* a 3-word BDE with length as first word, address last 2 words */
> +struct sli4_bufptr_len1st {
> +	__le32 length0;
> +	struct sli4_dmaaddr addr;
> +};
> +
> +/* Buffer Descriptor Entry (BDE) */
> +enum {
> +	SLI4_BDE_MASK_BUFFER_LEN	= 0x00ffffff,
> +	SLI4_BDE_MASK_BDE_TYPE		= 0xff000000,
> +};
> +
> +struct sli4_bde {
> +	__le32		bde_type_buflen;
> +	union {
> +		struct sli4_dmaaddr data;
> +		struct {
> +			__le32	offset;
> +			__le32	rsvd2;
> +		} imm;
> +		struct sli4_dmaaddr blp;
> +	} u;
> +};
> +
> +/* Buffer Descriptors */
> +enum {
> +	BDE_TYPE_SHIFT		= 24,
> +	BDE_TYPE_BDE_64		= 0x00,	/* Generic 64-bit data */
> +	BDE_TYPE_BDE_IMM	= 0x01,	/* Immediate data */
> +	BDE_TYPE_BLP		= 0x40,	/* Buffer List Pointer */
> +};
> +
> +/* Scatter-Gather Entry (SGE) */
> +#define SLI4_SGE_MAX_RESERVED			3
> +
> +enum {
> +	/* DW2 */
> +	SLI4_SGE_DATA_OFFSET_MASK	= 0x07FFFFFF,
> +	/*DW2W1*/
> +	SLI4_SGE_TYPE_SHIFT		= 27,
> +	SLI4_SGE_TYPE_MASK		= 0xf << SLI4_SGE_TYPE_SHIFT,
> +	/*SGE Types*/
> +	SLI4_SGE_TYPE_DATA		= 0x00,
> +	SLI4_SGE_TYPE_DIF		= 0x04,	/* Data Integrity Field */
> +	SLI4_SGE_TYPE_LSP		= 0x05,	/* List Segment Pointer */
> +	SLI4_SGE_TYPE_PEDIF		= 0x06,	/* Post Encryption Engine DIF */
> +	SLI4_SGE_TYPE_PESEED		= 0x07,	/* Post Encryption DIF Seed */
> +	SLI4_SGE_TYPE_DISEED		= 0x08,	/* DIF Seed */
> +	SLI4_SGE_TYPE_ENC		= 0x09,	/* Encryption */
> +	SLI4_SGE_TYPE_ATM		= 0x0a,	/* DIF Application Tag Mask */
> +	SLI4_SGE_TYPE_SKIP		= 0x0c,	/* SKIP */
> +
> +	SLI4_SGE_LAST			= (1 << 31),
> +};
> +
> +struct sli4_sge {
> +	__le32		buffer_address_high;
> +	__le32		buffer_address_low;
> +	__le32		dw2_flags;
> +	__le32		buffer_length;
> +};
> +
I am really not a big fan of anonymous enums, especially not if they are
scoped for specific structures.
Can you please avoid the use of anonymous enums, and name them according
to the structure where they are indended to be used?
Ideally the structure should reference named enums directly, but I do
agree that this it not always possible or desired.
But we should at least name them accordingly to give the developer a
hint where these values are expected to occur.

Eg in the above case

enum sli4_sge_flags {

or similar would make the intended usage clearer.

> +/* T10 DIF Scatter-Gather Entry (SGE) */
> +struct sli4_dif_sge {
> +	__le32		buffer_address_high;
> +	__le32		buffer_address_low;
> +	__le32		dw2_flags;
> +	__le32		rsvd12;
> +};
> +
> +/* Data Integrity Seed (DISEED) SGE */
> +enum {
> +	/* DW2W1 */
> +	DISEED_SGE_HS			= (1 << 2),
> +	DISEED_SGE_WS			= (1 << 3),
> +	DISEED_SGE_IC			= (1 << 4),
> +	DISEED_SGE_ICS			= (1 << 5),
> +	DISEED_SGE_ATRT			= (1 << 6),
> +	DISEED_SGE_AT			= (1 << 7),
> +	DISEED_SGE_FAT			= (1 << 8),
> +	DISEED_SGE_NA			= (1 << 9),
> +	DISEED_SGE_HI			= (1 << 10),
> +
> +	/* DW3W1 */
> +	DISEED_SGE_BS_MASK		= 0x0007,
> +	DISEED_SGE_AI			= (1 << 3),
> +	DISEED_SGE_ME			= (1 << 4),
> +	DISEED_SGE_RE			= (1 << 5),
> +	DISEED_SGE_CE			= (1 << 6),
> +	DISEED_SGE_NR			= (1 << 7),
> +
> +	DISEED_SGE_OP_RX_SHIFT		= 8,
> +	DISEED_SGE_OP_RX_MASK		= (0xf << DISEED_SGE_OP_RX_SHIFT),
> +	DISEED_SGE_OP_TX_SHIFT		= 12,
> +	DISEED_SGE_OP_TX_MASK		= (0xf << DISEED_SGE_OP_TX_SHIFT),
> +
> +	/* Opcode values */
> +	DISEED_SGE_OP_IN_NODIF_OUT_CRC	= 0x00,
> +	DISEED_SGE_OP_IN_CRC_OUT_NODIF	= 0x01,
> +	DISEED_SGE_OP_IN_NODIF_OUT_CSUM	= 0x02,
> +	DISEED_SGE_OP_IN_CSUM_OUT_NODIF	= 0x03,
> +	DISEED_SGE_OP_IN_CRC_OUT_CRC	= 0x04,
> +	DISEED_SGE_OP_IN_CSUM_OUT_CSUM	= 0x05,
> +	DISEED_SGE_OP_IN_CRC_OUT_CSUM	= 0x06,
> +	DISEED_SGE_OP_IN_CSUM_OUT_CRC	= 0x07,
> +	DISEED_SGE_OP_IN_RAW_OUT_RAW	= 0x08,
> +
> +};
> +
Similar here: please use individual named enums, not one giant anonymous
enum containing different value for different use-cases.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
