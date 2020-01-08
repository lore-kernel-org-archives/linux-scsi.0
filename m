Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4E4C00523
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 07:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C04C92075D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 07:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgAHHLv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 02:11:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:58684 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgAHHLu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 02:11:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CC001B15F;
        Wed,  8 Jan 2020 07:11:47 +0000 (UTC)
Subject: Re: [PATCH v2 01/32] elx: libefc_sli: SLI-4 register offsets and
 field definitions
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-2-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <3d984e91-49f6-dd8f-ed00-82fcfdc9b95e@suse.de>
Date:   Wed, 8 Jan 2020 08:11:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-2-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 11:36 PM, James Smart wrote:
> This is the initial patch for the new Emulex target mode SCSI
> driver sources.
> 
> This patch:
> - Creates the new Emulex source level directory drivers/scsi/elx
>   and adds the directory to the MAINTAINERS file.
> - Creates the first library subdirectory drivers/scsi/elx/libefc_sli.
>   This library is a SLI-4 interface library.
> - Starts the population of the libefc_sli library with definitions
>   of SLI-4 hardware register offsets and definitions.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  MAINTAINERS                        |   8 ++
>  drivers/scsi/elx/libefc_sli/sli4.c |  26 ++++
>  drivers/scsi/elx/libefc_sli/sli4.h | 239 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 273 insertions(+)
>  create mode 100644 drivers/scsi/elx/libefc_sli/sli4.c
>  create mode 100644 drivers/scsi/elx/libefc_sli/sli4.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cc0a4a8ae06a..dd8e5f340991 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6139,6 +6139,14 @@ W:	http://www.broadcom.com
>  S:	Supported
>  F:	drivers/scsi/lpfc/
>  
> +EMULEX/BROADCOM EFCT FC/FCOE SCSI TARGET DRIVER
> +M:	James Smart <james.smart@broadcom.com>
> +M:	Ram Vegesna <ram.vegesna@broadcom.com>
> +L:	linux-scsi@vger.kernel.org
> +W:	http://www.broadcom.com
> +S:	Supported
> +F:	drivers/scsi/elx/
> +
>  ENE CB710 FLASH CARD READER DRIVER
>  M:	Michał Mirosław <mirq-linux@rere.qmqm.pl>
>  S:	Maintained
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
> new file mode 100644
> index 000000000000..29d33becd334
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc_sli/sli4.c
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +/**
> + * All common (i.e. transport-independent) SLI-4 functions are implemented
> + * in this file.
> + */
> +#include "sli4.h"
> +
> +struct sli4_asic_entry_t {
> +	u32 rev_id;
> +	u32 family;
> +};
> +
> +static struct sli4_asic_entry_t sli4_asic_table[] = {
> +	{ SLI4_ASIC_REV_B0, SLI4_ASIC_GEN_5},
> +	{ SLI4_ASIC_REV_D0, SLI4_ASIC_GEN_5},
> +	{ SLI4_ASIC_REV_A3, SLI4_ASIC_GEN_6},
> +	{ SLI4_ASIC_REV_A0, SLI4_ASIC_GEN_6},
> +	{ SLI4_ASIC_REV_A1, SLI4_ASIC_GEN_6},
> +	{ SLI4_ASIC_REV_A3, SLI4_ASIC_GEN_6},
> +	{ SLI4_ASIC_REV_A1, SLI4_ASIC_GEN_7},
> +};
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
> new file mode 100644
> index 000000000000..02c671cf57ef
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc_sli/sli4.h
> @@ -0,0 +1,239 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + *
> + */
> +
> +/*
> + * All common SLI-4 structures and function prototypes.
> + */
> +
> +#ifndef _SLI4_H
> +#define _SLI4_H
> +
> +/*************************************************************************
> + * Common SLI-4 register offsets and field definitions
> + */
> +
> +/* SLI_INTF - SLI Interface Definition Register */
> +#define SLI4_INTF_REG			0x0058
> +enum {
> +	SLI4_INTF_REV_SHIFT		= 4,
> +	SLI4_INTF_REV_MASK		= 0x0F << SLI4_INTF_REV_SHIFT,
> +
> +	SLI4_INTF_REV_S3		= 3 << SLI4_INTF_REV_SHIFT,
> +	SLI4_INTF_REV_S4		= 4 << SLI4_INTF_REV_SHIFT,
> +
> +	SLI4_INTF_FAMILY_SHIFT		= 8,
> +	SLI4_INTF_FAMILY_MASK		= 0x0F << SLI4_INTF_FAMILY_SHIFT,
> +
> +	SLI4_FAMILY_CHECK_ASIC_TYPE	= 0xf << SLI4_INTF_FAMILY_SHIFT,
> +
> +	SLI4_INTF_IF_TYPE_SHIFT		= 12,
> +	SLI4_INTF_IF_TYPE_MASK		= 0x0F << SLI4_INTF_IF_TYPE_SHIFT,
> +
> +	SLI4_INTF_IF_TYPE_2		= 2 << SLI4_INTF_IF_TYPE_SHIFT,
> +	SLI4_INTF_IF_TYPE_6		= 6 << SLI4_INTF_IF_TYPE_SHIFT,
> +
> +	SLI4_INTF_VALID_SHIFT		= 29,
> +	SLI4_INTF_VALID_MASK		= 7 << SLI4_INTF_VALID_SHIFT,
> +
> +	SLI4_INTF_VALID_VALUE		= 6 << SLI4_INTF_VALID_SHIFT,
> +};
> +
> +/* ASIC_ID - SLI ASIC Type and Revision Register */
> +#define SLI4_ASIC_ID_REG	0x009c
> +enum {
> +	SLI4_ASIC_GEN_SHIFT	= 8,
> +	SLI4_ASIC_GEN_MASK	= 0xFF << SLI4_ASIC_GEN_SHIFT,
> +	SLI4_ASIC_GEN_5		= 0x0b << SLI4_ASIC_GEN_SHIFT,
> +	SLI4_ASIC_GEN_6		= 0x0c << SLI4_ASIC_GEN_SHIFT,
> +	SLI4_ASIC_GEN_7		= 0x0d << SLI4_ASIC_GEN_SHIFT,
> +};
> +
> +enum {
> +	SLI4_ASIC_REV_A0 = 0x00,
> +	SLI4_ASIC_REV_A1 = 0x01,
> +	SLI4_ASIC_REV_A2 = 0x02,
> +	SLI4_ASIC_REV_A3 = 0x03,
> +	SLI4_ASIC_REV_B0 = 0x10,
> +	SLI4_ASIC_REV_B1 = 0x11,
> +	SLI4_ASIC_REV_B2 = 0x12,
> +	SLI4_ASIC_REV_C0 = 0x20,
> +	SLI4_ASIC_REV_C1 = 0x21,
> +	SLI4_ASIC_REV_C2 = 0x22,
> +	SLI4_ASIC_REV_D0 = 0x30,
> +};
> +
> +/* BMBX - Bootstrap Mailbox Register */
> +#define SLI4_BMBX_REG		0x0160
> +#define SLI4_BMBX_MASK_HI	0x3
> +#define SLI4_BMBX_MASK_LO	0xf
> +#define SLI4_BMBX_RDY		(1 << 0)
> +#define SLI4_BMBX_HI		(1 << 1)
> +#define SLI4_BMBX_WRITE_HI(r) \
> +	((upper_32_bits(r) & ~SLI4_BMBX_MASK_HI) | SLI4_BMBX_HI)
> +#define SLI4_BMBX_WRITE_LO(r) \
> +	(((upper_32_bits(r) & SLI4_BMBX_MASK_HI) << 30) | \
> +	 (((r) & ~SLI4_BMBX_MASK_LO) >> 2))
> +#define SLI4_BMBX_SIZE				256
> +
> +/* SLIPORT_CONTROL - SLI Port Control Register */
> +#define SLI4_PORT_CTRL_REG	0x0408
> +#define SLI4_PORT_CTRL_IP	(1 << 27)
> +#define SLI4_PORT_CTRL_IDIS	(1 << 22)
> +#define SLI4_PORT_CTRL_FDD	(1 << 31)
> +
> +/* SLI4_SLIPORT_ERROR - SLI Port Error Register */
> +#define SLI4_PORT_ERROR1	0x040c
> +#define SLI4_PORT_ERROR2	0x0410
> +
> +/* EQCQ_DOORBELL - EQ and CQ Doorbell Register */
> +#define SLI4_EQCQ_DB_REG	0x120
> +enum {
> +	SLI4_EQ_ID_LO_MASK	= 0x01FF,
> +
> +	SLI4_CQ_ID_LO_MASK	= 0x03FF,
> +
> +	SLI4_EQCQ_CI_EQ		= 0x0200,
> +
> +	SLI4_EQCQ_QT_EQ		= 0x00000400,
> +	SLI4_EQCQ_QT_CQ		= 0x00000000,
> +
> +	SLI4_EQCQ_ID_HI_SHIFT	= 11,
> +	SLI4_EQCQ_ID_HI_MASK	= 0xF800,
> +
> +	SLI4_EQCQ_NUM_SHIFT	= 16,
> +	SLI4_EQCQ_NUM_MASK	= 0x1FFF0000,
> +
> +	SLI4_EQCQ_ARM		= 0x20000000,
> +	SLI4_EQCQ_UNARM		= 0x00000000,
> +};
> +
Please be consistent here wrt _SHIFT and _MASK statements.
Either have them spelled out (as you do in this case), but then please
change the first hunk to avoid an explicit shift.
Or keep the style in the first hunk, and change the _MASK values here
to use the _SHIFT values
(ie SLI4_EQCQ_ID_HI_MASK = 0x1F << SLI4_EQCQ_ID_HI_SHIFT).
I don't mind either way, but keep it consistent.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
