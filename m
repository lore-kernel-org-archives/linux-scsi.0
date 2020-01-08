Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7EA8C00523
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 07:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6442206DA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 07:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgAHHce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 02:32:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:37084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgAHHce (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 02:32:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DD9EAB162;
        Wed,  8 Jan 2020 07:32:30 +0000 (UTC)
Subject: Re: [PATCH v2 03/32] elx: libefc_sli: Data structures and defines for
 mbox commands
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-4-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <479ac7f4-80ac-babe-7aa6-aa91e257ec8f@suse.de>
Date:   Wed, 8 Jan 2020 08:32:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-4-jsmart2021@gmail.com>
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
> This patch adds definitions for SLI-4 mailbox commands
> and responses.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/libefc_sli/sli4.h | 1728 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 1727 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
> index f86a9e72ed43..c9bd3f71b27b 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.h
> +++ b/drivers/scsi/elx/libefc_sli/sli4.h
> @@ -1995,7 +1995,7 @@ struct sli4_fc_xri_aborted_cqe {
>  #define SLI4_ELS_REQUEST64_DIR_READ		0x1
>  
>  #define SLI4_ELS_REQUEST64_OTHER		0x0
> -#define SLI4_ELS_REQUEST64_LOGO		0x1
> +#define SLI4_ELS_REQUEST64_LOGO			0x1
>  #define SLI4_ELS_REQUEST64_FDISC		0x2
>  #define SLI4_ELS_REQUEST64_FLOGIN		0x3
>  #define SLI4_ELS_REQUEST64_PLOGI		0x4
Shouldn't this rather be merged with the previous patch?

> @@ -2004,4 +2004,1730 @@ struct sli4_fc_xri_aborted_cqe {
>  #define SLI4_ELS_REQUEST64_CMD_NON_FABRIC	0x0c
>  #define SLI4_ELS_REQUEST64_CMD_FABRIC		0x0d
>  
> +#define SLI_PAGE_SIZE				(1 << 12)	/* 4096 */
> +#define SLI_SUB_PAGE_MASK			(SLI_PAGE_SIZE - 1)
> +#define SLI_ROUND_PAGE(b)	(((b) + SLI_SUB_PAGE_MASK) & ~SLI_SUB_PAGE_MASK)
> +
> +#define SLI4_BMBX_TIMEOUT_MSEC			30000
> +#define SLI4_FW_READY_TIMEOUT_MSEC		30000
> +
> +#define SLI4_BMBX_DELAY_US			1000	/* 1 ms */
> +#define SLI4_INIT_PORT_DELAY_US			10000	/* 10 ms */
> +
> +static inline u32
> +sli_page_count(size_t bytes, u32 page_size)
> +{
> +	if (!page_size)
> +		return 0;
> +
> +	return (bytes + (page_size - 1)) >> __ffs(page_size);
> +}
> +
> +/*************************************************************************
> + * SLI-4 mailbox command formats and definitions
> + */
> +
> +struct sli4_mbox_command_header {
> +	u8	resvd0;
> +	u8	command;
> +	__le16	status;	/* Port writes to indicate success/fail */
> +};
> +
> +enum {
> +	MBX_CMD_CONFIG_LINK	= 0x07,
> +	MBX_CMD_DUMP		= 0x17,
> +	MBX_CMD_DOWN_LINK	= 0x06,
> +	MBX_CMD_INIT_LINK	= 0x05,
> +	MBX_CMD_INIT_VFI	= 0xa3,
> +	MBX_CMD_INIT_VPI	= 0xa4,
> +	MBX_CMD_POST_XRI	= 0xa7,
> +	MBX_CMD_RELEASE_XRI	= 0xac,
> +	MBX_CMD_READ_CONFIG	= 0x0b,
> +	MBX_CMD_READ_STATUS	= 0x0e,
> +	MBX_CMD_READ_NVPARMS	= 0x02,
> +	MBX_CMD_READ_REV	= 0x11,
> +	MBX_CMD_READ_LNK_STAT	= 0x12,
> +	MBX_CMD_READ_SPARM64	= 0x8d,
> +	MBX_CMD_READ_TOPOLOGY	= 0x95,
> +	MBX_CMD_REG_FCFI	= 0xa0,
> +	MBX_CMD_REG_FCFI_MRQ	= 0xaf,
> +	MBX_CMD_REG_RPI		= 0x93,
> +	MBX_CMD_REG_RX_RQ	= 0xa6,
> +	MBX_CMD_REG_VFI		= 0x9f,
> +	MBX_CMD_REG_VPI		= 0x96,
> +	MBX_CMD_RQST_FEATURES	= 0x9d,
> +	MBX_CMD_SLI_CONFIG	= 0x9b,
> +	MBX_CMD_UNREG_FCFI	= 0xa2,
> +	MBX_CMD_UNREG_RPI	= 0x14,
> +	MBX_CMD_UNREG_VFI	= 0xa1,
> +	MBX_CMD_UNREG_VPI	= 0x97,
> +	MBX_CMD_WRITE_NVPARMS	= 0x03,
> +	MBX_CMD_CFG_AUTO_XFER_RDY = 0xAD,
> +
> +	MBX_STATUS_SUCCESS	= 0x0000,
> +	MBX_STATUS_FAILURE	= 0x0001,
> +	MBX_STATUS_RPI_NOT_REG	= 0x1400,
> +};
> +
Make this two enums, one 'enum sli4_mbx_cmd' and one 'enum sli4_mbx_status'.

> +/* CONFIG_LINK */
> +enum {
> +	SLI4_CFG_LINK_BBSCN = 0xf00,
> +	SLI4_CFG_LINK_CSCN  = 0x1000,
> +};
> +
> +struct sli4_cmd_config_link {
> +	struct sli4_mbox_command_header	hdr;
> +	u8		maxbbc;
> +	u8		rsvd5;
> +	u8		rsvd6;
> +	u8		rsvd7;
> +	u8		alpa;
> +	__le16		n_port_id;
> +	u8		rsvd11;
> +	__le32		rsvd12;
> +	__le32		e_d_tov;
> +	__le32		lp_tov;
> +	__le32		r_a_tov;
> +	__le32		r_t_tov;
> +	__le32		al_tov;
> +	__le32		rsvd36;
> +	__le32		bbscn_dword;
> +};
> +
> +enum {
> +	SLI4_DUMP4_TYPE = 0xf,
> +};

Single enum should rather be converted into a #define ..

> +
> +#define SLI4_WKI_TAG_SAT_TEM 0x1040
> +
> +struct sli4_cmd_dump4 {
> +	struct sli4_mbox_command_header	hdr;
> +	__le32		type_dword;
> +	__le16		wki_selection;
> +	__le16		rsvd10;
> +	__le32		rsvd12;
> +	__le32		returned_byte_cnt;
> +	__le32		resp_data[59];
> +};
> +
> +/* INIT_LINK - initialize the link for a FC port */
> +#define FC_TOPOLOGY_FCAL	0
> +#define FC_TOPOLOGY_P2P		1
> +
> +#define SLI4_INIT_LINK_F_LOOP_BACK	(1 << 0)
> +#define SLI4_INIT_LINK_F_UNFAIR		(1 << 6)
> +#define SLI4_INIT_LINK_F_NO_LIRP	(1 << 7)
> +#define SLI4_INIT_LINK_F_LOOP_VALID_CHK	(1 << 8)
> +#define SLI4_INIT_LINK_F_NO_LISA	(1 << 9)
> +#define SLI4_INIT_LINK_F_FAIL_OVER	(1 << 10)
> +#define SLI4_INIT_LINK_F_NO_AUTOSPEED	(1 << 11)
> +#define SLI4_INIT_LINK_F_PICK_HI_ALPA	(1 << 15)
> +
> +#define SLI4_INIT_LINK_F_P2P_ONLY	1
> +#define SLI4_INIT_LINK_F_FCAL_ONLY	2
> +
> +#define SLI4_INIT_LINK_F_FCAL_FAIL_OVER	0
> +#define SLI4_INIT_LINK_F_P2P_FAIL_OVER	1
> +
> +enum {
> +	SLI4_INIT_LINK_SEL_RESET_AL_PA		= 0xff,
> +	SLI4_INIT_LINK_FLAG_LOOPBACK		= 0x1,
> +	SLI4_INIT_LINK_FLAG_TOPOLOGY		= 0x6,
> +	SLI4_INIT_LINK_FLAG_UNFAIR		= 0x40,
> +	SLI4_INIT_LINK_FLAG_SKIP_LIRP_LILP	= 0x80,
> +	SLI4_INIT_LINK_FLAG_LOOP_VALIDITY	= 0x100,
> +	SLI4_INIT_LINK_FLAG_SKIP_LISA		= 0x200,
> +	SLI4_INIT_LINK_FLAG_EN_TOPO_FAILOVER	= 0x400,
> +	SLI4_INIT_LINK_FLAG_FIXED_SPEED		= 0x800,
> +	SLI4_INIT_LINK_FLAG_SEL_HIGHTEST_AL_PA	= 0x8000,
> +};
> +
Why is this an enum, and the above SLI4_INIT_LINK_F_XXX value are defines?
Please be consistent.

And this applies throughout the remainder of the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
