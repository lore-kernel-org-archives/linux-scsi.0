Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACC62AE77;
	Tue, 11 Jun 2024 06:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718088840; cv=none; b=NnsNDO0u4fYHbwe5DFAMUCGflOujnR8BDsuM/u8wKFKyBxtqA9RHLyUNR4qeEt/tdACk045sc1b2ITPKj/nbhSXsQBmzcNXf3igbijW2XWPoss0rQsoZoGrOfPceQw2ufjOoCUfYJEOZg9BBKMjQPSGJ0O4HQLIVmFiMfYLzYpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718088840; c=relaxed/simple;
	bh=JkvwcNrhDB/dYalLOUccEtcoUeDnDKs9ENaQF9VfKls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JmCoGp+mgz+XQT4o/sOK7/Xf0i1hXO/5FOzCyeaiPeiM0/o7EDZJPTK6Ik+QK4kq1l1U21R8x49wXySo4bGE8z5Mz3QP2QqoySTgwwnDYTwjVTTa8QwvRMvSLdpUShjOKe55gGKVb+PGd30GpOZU3AqNNTPuKwnA80MmtAYtVAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EiqY8rY7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zgx0y5W1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EiqY8rY7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zgx0y5W1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EiqY8rY7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zgx0y5W1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EiqY8rY7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zgx0y5W1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8227C204F4;
	Tue, 11 Jun 2024 06:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718088835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HXzvAg77I+0ET/3IErFdZUN4Ya6VDScXpT0GdgyFb2A=;
	b=EiqY8rY75vX2DPgygNjiiDiKGuEuWNh5lze9x5Dzxf/Dd8RnX3UWygg0cjVAbgnA4j9XQv
	0nCA2GBntAPUYAAFV0P62MYwK4kRYKTGfEpIomZBdI3Dv1PdEkoSfEIScsmvabrhZDvYOF
	tKXhZjhVdP8kkFvx6AhyRsg3MHEsPzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718088835;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HXzvAg77I+0ET/3IErFdZUN4Ya6VDScXpT0GdgyFb2A=;
	b=zgx0y5W17GfwI9RFIjNmqVTme3QSbBQ1GY31vsL+1D9PTeDgruhFq73v8Uki15/xnENpG7
	QSwzPM3Nfd7Df1Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718088835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HXzvAg77I+0ET/3IErFdZUN4Ya6VDScXpT0GdgyFb2A=;
	b=EiqY8rY75vX2DPgygNjiiDiKGuEuWNh5lze9x5Dzxf/Dd8RnX3UWygg0cjVAbgnA4j9XQv
	0nCA2GBntAPUYAAFV0P62MYwK4kRYKTGfEpIomZBdI3Dv1PdEkoSfEIScsmvabrhZDvYOF
	tKXhZjhVdP8kkFvx6AhyRsg3MHEsPzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718088835;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HXzvAg77I+0ET/3IErFdZUN4Ya6VDScXpT0GdgyFb2A=;
	b=zgx0y5W17GfwI9RFIjNmqVTme3QSbBQ1GY31vsL+1D9PTeDgruhFq73v8Uki15/xnENpG7
	QSwzPM3Nfd7Df1Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E9F9137DF;
	Tue, 11 Jun 2024 06:53:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SKOqAIP0Z2ZYQAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 11 Jun 2024 06:53:55 +0000
Message-ID: <fd07ed26-11f7-42d9-be43-0d0f5ff96982@suse.de>
Date: Tue, 11 Jun 2024 08:53:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/14] scsi: fnic: Add headers and definitions for FDLS
Content-Language: en-US
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-3-kartilak@cisco.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240610215100.673158-3-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]

On 6/10/24 23:50, Karan Tilak Kumar wrote:
> Fabric Discovery and Login Services (FDLS) provide
> functionality for fnic to discover the fabric and
> target ports. It logs in to the target ports from
> the initiator and creates target ports (tports).
> This functionality is essential for port channel
> register state change notification (PC-RSCN)
> handling and FC-NVME initiator role.
> 
> This functionality is essential for eCPU hang or panic
> handling. In cases where the eCPU in the UCS VIC (Unified
> Computing Services Virtual Interface Card) hangs,
> a fabric log out is sent to the fabric. Upon successful log
> out from the fabric, the IO path is failed over to a new path.
> 
Didn't you have the paragraph in the patch series description?
Please don't duplicate it.

> Add headers and definitions for FDLS.
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
>   drivers/scsi/fnic/fdls_fc.h   | 548 ++++++++++++++++++++++++++++++++++
>   drivers/scsi/fnic/fnic_fdls.h | 362 ++++++++++++++++++++++
>   2 files changed, 910 insertions(+)
>   create mode 100644 drivers/scsi/fnic/fdls_fc.h
>   create mode 100644 drivers/scsi/fnic/fnic_fdls.h
> 
> diff --git a/drivers/scsi/fnic/fdls_fc.h b/drivers/scsi/fnic/fdls_fc.h
> new file mode 100644
> index 000000000000..ad6a9eebc5d3
> --- /dev/null
> +++ b/drivers/scsi/fnic/fdls_fc.h
> @@ -0,0 +1,548 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
> + * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
> + */
> +
> +#ifndef _FDLS_FC_H_
> +#define _FDLS_FC_H_
> +
> +/* This file contains the declarations for FC fabric services
> + * and target discovery
> + *
> + * Request and Response for
> + * 1. FLOGI
> + * 2. PLOGI to Fabric Controller
> + * 3. GPN_ID, GPN_FT
> + * 4. RSCN
> + * 5. PLOGI to Target
> + * 6. PRLI to Target
> + */
> +
> +#include <scsi/scsi.h>
> +
> +#define MIN(x, y) (x < y ? x : y)
> +
> +#define FNIC_FCP_SP_RD_XRDY_DIS 0x00000002
> +#define FNIC_FCP_SP_TARGET      0x00000010
> +#define FNIC_FCP_SP_INITIATOR   0x00000020
> +#define FNIC_FCP_SP_CONF_CMPL   0x00000080
> +#define FNIC_FCP_SP_RETRY       0x00000100
> +
> +#ifdef _BIG_ENDIAN
> +
> +#define FNIC_FLOGI_OXID        (0x1001)
> +#define FNIC_PLOGI_FABRIC_OXID (0x1002)
> +#define FNIC_RPN_REQ_OXID      (0x1003)
> +#define FNIC_GPN_FT_OXID       (0x1004)
> +#define FNIC_SCR_REQ_OXID      (0x1005)
> +#define FNIC_RSCN_RESP_OXID    (0x1006)
> +#define FNIC_LOGO_REQ_OXID     (0x1007)
> +#define FNIC_LOGO_RESP_OXID    (0x1008)
> +#define FNIC_RFT_REQ_OXID      (0x100a)
> +#define FNIC_RFF_REQ_OXID      (0x100b)
> +#define FNIC_ECHO_RESP_OXID    (0x100c)
> +#define FNIC_ADISC_RESP_OXID   (0x100d)
> +#define FNIC_FDMI_PLOGI_OXID   (0x100e)
> +#define FNIC_FDMI_REG_HBA_OXID (0X100f)
> +#define FNIC_FDMI_RPA_OXID     (0X1010)

Please tell me that 'OXID' doesn't mean what I think it does ...
Hardcoded OXIDs for individual command types? Really?

> +#define FNIC_ELS_REQ_FCTL      (0x290000)
> +#define FNIC_ELS_REP_FCTL      (0x990000)
> +
> +#define FNIC_FC_PH_VER         (0x2020)
> +#define FNIC_FC_B2B_CREDIT     (0x000A)
> +#define FNIC_FC_B2B_RDF_SZ     (0x0800)
> +
> +#define FNIC_REQ_ABTS_FCTL     (0x090000)
> +
> +#define FNIC_FC_FEATURES       (0x8000)
> +
> +#define FNIC_FC_CONCUR_SEQS    (0x00FF)
> +
> +#define FNIC_FC_RO_INFO        (0x001F)
> +#define FNIC_E_D_TOV           (0x07D0)
> +
> +#define FC_CT_RPN_CMD          (0x0212)
> +#define FC_CT_GPN_FT_CMD       (0x0172)
> +#define FC_CT_ACC              (0x8002)
> +#define FC_CT_REJ              (0x8001)
> +#define FC_CT_RFT_CMD          (0x1702)
> +#define FC_CT_RFF_CMD          (0x1F02)
> +
> +#define FNIC_FCP_RSP_FCTL      (0x990000)
> +
> +#else /* _LITTLE_ENDIAN */
> +
> +#define FNIC_FLOGI_OXID        (0x0110)
> +#define FNIC_PLOGI_FABRIC_OXID (0x0210)
> +#define FNIC_RPN_REQ_OXID      (0x0310)
> +#define FNIC_GPN_FT_OXID       (0x0410)
> +#define FNIC_SCR_REQ_OXID      (0x0510)
> +#define FNIC_RSCN_RESP_OXID    (0x0610)
> +#define FNIC_TLOGO_REQ_OXID    (0x0710)
> +#define FNIC_FLOGO_REQ_OXID    (0x0711)
> +#define FNIC_LOGO_RESP_OXID    (0x0810)
> +#define FNIC_PLOGI_RESP_OXID   (0x0910)
> +#define FNIC_RFT_REQ_OXID      (0x0a10)
> +#define FNIC_RFF_REQ_OXID      (0x0b10)
> +#define FNIC_ECHO_RESP_OXID    (0x0c10)
> +#define FNIC_UNSUPPORTED_RESP_OXID   (0xffff)
> +#define FNIC_ADISC_RESP_OXID    (0x0d10)
> +#define FNIC_PLOGI_FDMI_OXID    (0x0e10)
> +#define FNIC_FDMI_REG_HBA_OXID  (0X0f10)
> +#define FNIC_FDMI_RPA_OXID      (0X1010)
> +#define FNIC_ELS_REQ_FCTL      (0x000029)
> +#define FNIC_ELS_REP_FCTL      (0x000099)
> +
> +#define FNIC_FCP_RSP_FCTL      (0x000099)
> +#define FNIC_REQ_ABTS_FCTL     (0x000009)
> +
> +#define FNIC_FC_PH_VER         (0x2020)
> +#define FNIC_FC_B2B_CREDIT     (0x0A00)
> +#define FNIC_FC_B2B_RDF_SZ     (0x0008)
> +
> +#define FNIC_FC_FEATURES       (0x0080)
> +
> +#define FNIC_FC_CONCUR_SEQS    (0xFF00)
> +#define FNIC_FC_RO_INFO        (0x1F00)
> +#define FNIC_E_D_TOV           (0xD0070000)
> +
> +#define FC_CT_RPN_CMD          (0x1202)
> +#define FC_CT_GPN_FT_CMD       (0x7201)
> +#define FC_CT_ACC              (0x0280)
> +#define FC_CT_REJ              (0x0180)
> +#define FC_CT_RFT_CMD          (0x1702)
> +#define FC_CT_RFF_CMD          (0x1F02)
> +
> +#endif

Duplicate macros for endian differences is quite error-prone,
as you have to remember to always change both sides.
I would prefer to have just one copy and use macros
to access the values (eg always use get_unaligned_le16).

> +
> +#define ETH_TYPE_FCOE			0x8906
> +#define ETH_TYPE_FIP			0x8914
> +
> +#define FC_DIR_SERVER          0xFFFFFC
> +#define FC_FABRIC_CONTROLLER   0xFFFFFD
> +#define FC_DOMAIN_CONTR        0xFFFFFE
> +
> +#define FNIC_FC_GPN_LAST_ENTRY (0x80)
> +
> +#define FC_ELS_FLOGI_REQ        0x04
> +#define FC_LS_REJ               0x01
> +#define FC_LS_ACC               0x02
> +#define FC_ELS_PLOGI_REQ        0x03
> +#define FC_ELS_ECHO_REQ         0x10
> +#define FC_ELS_PRLI_REQ         0x20
> +#define FC_ELS_SCR              0x62
> +#define FC_ELS_RLS_REQ          0x0F
> +#define FC_ELS_RRQ_REQ          0x12
> +#define FC_ELS_LOGO             0x05
> +#define FC_ELS_RSCN             0x61
> +#define FNIC_BA_ACC_RCTL        0x84
> +#define FNIC_BA_RJT_RCTL        0x85
> +#define FC_ABTS_RCTL            0x81
> +#define FNIC_ELS_ADISC_REQ      0x52
> +#define FC_ELS_RJT_LOGICAL_BUSY 0x05
> +#define FC_ELS_RJT_BUSY         0x09
> +#define FC_ELS_RTV_REQ          0x0E
> +

There is already a copy of FC-LS definitions in
include/uapi/scsi/fc/fc_els.h.

Please ensure that you don't introduce duplicates.

> +/* FNIC FDMI Register HBA Macros */
> +#define FNIC_FDMI_TYPE_NODE_NAME	0X100
> +#define FNIC_FDMI_TYPE_MANUFACTURER	0X200
> +#define FNIC_FDMI_MANUFACTURER		"Cisco Systems"
> +#define FNIC_FDMI_TYPE_SERIAL_NUMBER	0X300
> +#define FNIC_FDMI_TYPE_MODEL		0X400
> +#define FNIC_FDMI_TYPE_MODEL_DES	0X500
> +#define FNIC_FDMI_MODEL_DESCRIPTION	"Cisco Virtual Interface Card"
> +#define FNIC_FDMI_TYPE_HARDWARE_VERSION	0X600
> +#define FNIC_FDMI_TYPE_DRIVER_VERSION	0X700
> +#define FNIC_FDMI_TYPE_ROM_VERSION	0X800
> +#define FNIC_FDMI_TYPE_FIRMWARE_VERSION	0X900
> +
> +/* FNIC FDMI Register PA Macros */
> +#define FNIC_FDMI_TYPE_FC4_TYPES	0X100
> +#define FNIC_FDMI_TYPE_SUPPORTED_SPEEDS 0X200
> +#define FNIC_FDMI_TYPE_CURRENT_SPEED	0X300
> +#define FNIC_FDMI_TYPE_MAX_FRAME_SIZE	0X400
> +#define FNIC_FDMI_TYPE_OS_NAME		0X500
> +#define FNIC_FDMI_TYPE_HOST_NAME	0X600
> +
> +#define FNIC_SET_S_ID(_fchdr, _sid)        memcpy(_fchdr->sid, _sid, 3)
> +#define FNIC_SET_NPORT_NAME(_req, _pName)  (_req.nport_name = htonll(_pName))
> +#define FNIC_SET_NODE_NAME(_req, _pName)   (_req.node_name = htonll(_pName))
> +#define FNIC_SET_RDF_SIZE(_req, _rdf_size)	\
> +	(_req.b2b_rdf_size = htons(_rdf_size))
> +#define FNIC_SET_R_A_TOV(_req, _r_a_tov)   (_req.r_a_tov = htonl(_r_a_tov))
> +#define FNIC_SET_E_D_TOV(_req, _e_d_tov)   (_req.e_d_tov = htonl(_e_d_tov))
> +#define FNIC_SET_D_ID(_fchdr, _did)        memcpy(_fchdr->did, _did, 3)
> +#define FNIC_SET_OX_ID(_fchdr, _oxid)      (_fchdr->ox_id = _oxid)
> +#define FNIC_SET_RX_ID(_fchdr, _rxid)      (_fchdr->rx_id = _rxid)
> +
htonll() macros are typically used in the network stack; please use
get_unaligned_be64().

> +#define FNIC_SET_PORT_ID(__req, __portid) \
> +	memcpy(__req->port_id, __portid, 3)
> +#define FNIC_SET_RPN_PORT_ID(__req, __portid) \
> +	memcpy(__req->port_id, __portid, 3)
> +#define FNIC_SET_RPN_PORT_NAME(_req, _pName) \
> +	(_req->port_name = htonll(_pName))
> +
> +#define FNIC_GET_S_ID(_fchdr)        (_fchdr->sid)
> +#define FNIC_GET_D_ID(_fchdr)        (_fchdr->did)
> +#define FNIC_GET_OX_ID(_fchdr)       (_fchdr->ox_id)
> +
> +#define FNIC_GET_FC_CT_CMD(__fcct_hdr)  (__fcct_hdr->command)
> +
> +#define FNIC_FCOE_SOF         (0x2E)
> +#define FNIC_FCOE_EOF         (0x42)
> +
> +#define FNIC_GET_FC_TYPE(_fchdr)        (_fchdr->type)
> +#define FNIC_GET_FC_RCTL(_fchdr)        (_fchdr->r_ctl)
> +
> +#define FNIC_FC_TYPE_ELS        (0x01)
> +#define FNIC_FC_R_ELS_REQ       (0x22)
> +#define FNIC_FC_R_ELS_RSP       (0x23)
> +
> +#define FNIC_FCOE_MAX_FRAME_SZ  (2048)
> +#define FNIC_FCOE_MIN_FRAME_SZ  (280)
> +#define FNIC_FC_MAX_PAYLOAD_LEN (2048)
> +#define FNIC_MIN_DATA_FIELD_SIZE  (256)
> +#define FNIC_R_A_TOV_DEF        (10 * 1000) /* msec */
> +#define FNIC_E_D_TOV_DEF        (2 * 1000)  /* msec */
> +
> +#define FNIC_FC_EDTOV_NSEC    (0x400)
> +#define FNIC_NSEC_TO_MSEC     (0x1000000)
> +#define FCP_PRLI_FUNC_TARGET	(0x0010)
> +#define FC_CT_RJT_LOGICAL_BUSY 0x5
> +#define FC_CT_RJT_BUSY         0x9
> +
> +#define FNIC_FC_FRAME_UNSOLICITED(_fchdr)  (_fchdr->r_ctl == 0x22)
> +#define FNIC_FC_FRAME_SOLICITED_DATA(_fchdr)    (_fchdr->r_ctl == 0x21)
> +#define FNIC_FC_FRAME_SOLICITED_CTRL_REPLY(_fchdr)    (_fchdr->r_ctl == 0x23)
> +#define FNIC_FC_FRAME_FCTL_LAST_END_SEQ(_fchdr)    (_fchdr->f_ctl == 0x98)
> +#define FNIC_FC_FRAME_FCTL_LAST_END_SEQ_INT(_fchdr)    (_fchdr->f_ctl == 0x99)
> +#define FNIC_FC_FRAME_FCTL_FIRST_LAST_SEQINIT(_fchdr)  (_fchdr->f_ctl == 0x29)
> +#define FNIC_FC_FRAME_FC4_SCTL(_fchdr)    (_fchdr->r_ctl == 0x03)
> +#define FNIC_FC_FRAME_TYPE_BLS(_fchdr) (_fchdr->type == 0x00)
> +#define FNIC_FC_FRAME_TYPE_ELS(_fchdr) (_fchdr->type == 0x01)
> +#define FNIC_FC_FRAME_TYPE_FC_GS(_fchdr) (_fchdr->type == 0x20)
> +#define FNIC_FC_FRAME_CS_CTL(_fchdr) (_fchdr->cs_ctl == 0x00)

Please use macro names instead of raw values here.

> +
> +#define FNIC_FC_C3_RDF         (0xfff)
> +#define FNIC_FC_PLOGI_RSP_RDF(_plogi_rsp) \
> +	(MIN(_plogi_rsp->u.csp_plogi.b2b_rdf_size, \
> +	(_plogi_rsp->spc3[4] & FNIC_FC_C3_RDF)))
> +#define FNIC_FC_PLOGI_RSP_CONCUR_SEQ(_plogi_rsp) \
> +	(MIN(_plogi_rsp->u.csp_plogi.total_concur_seqs, \
> +	(uint8_t)(_plogi_rsp->spc3[10] & 0xff)))
> +
> +/* Frame header */
> +
> +struct fnic_eth_hdr_s {
> +	uint8_t		dst_mac[6];
> +	uint8_t		src_mac[6];
> +	uint16_t	ether_type;
> +}  __packed;
> +
> +struct	fnic_fcoe_hdr_s	{
> +	uint8_t		ver;
> +	uint8_t		rsvd[12];
> +	uint8_t		sof;
> +} __packed;
> +
> +/*	Big	endian	*/
> +struct	fc_hdr_s	{
> +	uint8_t		r_ctl;
> +	uint8_t		did[3];
> +	uint8_t		cs_ctl:8;
> +	uint8_t		sid[3];
> +	uint32_t	type:8;
> +	uint32_t	f_ctl:24;
> +	uint8_t		seq_id;
> +	uint8_t		df_ctl;
> +	uint16_t	seq_cnt;
> +	uint16_t	ox_id;
> +	uint16_t	rx_id;
> +	uint32_t	param;
> +} __packed;
> +
> +struct	fc_csp_flogi_s	{
> +	uint16_t	fc_ph_ver;
> +	uint16_t	b2b_credits;
> +	uint16_t	features;
> +	uint16_t	b2b_rdf_size;
> +	uint32_t	r_a_tov;
> +	uint32_t	e_d_tov;
> +} __packed;
> +
> +struct	fc_csp_plogi_s	{
> +	uint16_t	fc_ph_ver;
> +	uint16_t	b2b_credits;
> +	uint16_t	features;
> +	uint16_t	b2b_rdf_size;
> +	uint16_t	total_concur_seqs;
> +	uint16_t	ro_info;
> +	uint32_t	e_d_tov;
> +} __packed;
> +
> +struct	fc_els_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint8_t		command;
> +	uint8_t		rsvd[3];
> +	union	{
> +	struct	fc_csp_flogi_s	csp_flogi;
> +	struct	fc_csp_plogi_s	csp_plogi;
> +	}	u;
> +	uint64_t	nport_name;
> +	uint64_t	node_name;
> +	uint8_t		spc1[16];
> +	uint8_t		spc2[16];
> +	uint8_t		spc3[16];
> +	uint8_t		spc4[16];
> +	uint8_t		vendor_ver_level[16];
> +}	 __packed;
> +
> +struct	fc_els_acc_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint8_t		command;
> +	uint8_t		rsvd[3];
> +}	 __packed;
> +
> +struct	fc_els_reject_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint32_t	command;
> +	uint8_t		reserved;
> +	uint8_t		reason_code;
> +	uint8_t		reason_expl;
> +	uint8_t		vendor_specific;
> +}	 __packed;
> +
> +struct	fc_els_adisc_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint8_t		command;
> +	uint8_t		zeros[3];
> +	uint32_t	unused;
> +	uint64_t	nport_name;
> +	uint64_t	node_name;
> +	uint8_t		reserved;
> +	uint8_t		fcid[3];
> +} __packed;
> +
> +struct	fc_els_rls_ls_acc_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint8_t		command;
> +	uint8_t		reserved[3];
> +	uint32_t	link_fail_count;	/*	link	failure	count	*/
> +	uint32_t	sync_loss_count;	/*	loss	of	synchronization	count	*/
> +	uint32_t	sig_loss_count;	/*	loss	of	signal	count	*/
> +	uint32_t	prim_err_count;	/*	primitive	sequence	error	count	*/
> +	uint32_t	inv_word_count;	/*	invalid	transmission	word	count	*/
> +	uint32_t	inv_crc_count;	/*	invalid	CRC	count	*/
> +} __packed;
> +
> +struct	fc_els_adisc_ls_acc_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint8_t		command;
> +	uint8_t		zeros[3];
> +	uint32_t	unused;
> +	uint64_t	nport_name;
> +	uint64_t	node_name;
> +	uint8_t		reserved;
> +	uint8_t		fcid[3];
> +} __packed;
> +
> +struct	fc_abts_ba_acc_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint8_t		seq_id_validity;
> +	uint8_t		seq_id;
> +	uint16_t	reserved;
> +	uint16_t	ox_id;
> +	uint16_t	rx_id;
> +	uint16_t	low_seq_cnt;
> +	uint16_t	high_seq_cnt;
> +} __packed;
> +
> +struct	fc_abts_ba_rjt_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint8_t		vend_uniq;
> +	uint8_t		reason_explanation;
> +	uint8_t		reason_code;
> +	uint8_t		reserved;
> +} __packed;
> +
> +struct	fc_prli_sp_s	{
> +	uint8_t		type;
> +	uint8_t		type_ext;
> +	uint16_t	flags;
> +
> +	uint32_t	ox_proc_assoc;
> +	uint32_t	rx_proc_assoc;
> +	uint32_t	csp;
> +}	 __packed;
> +
> +struct	fc_els_prli_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint8_t		command;
> +	uint8_t		page_len;
> +	uint16_t	payload_len;
> +	struct	fc_prli_sp_s	sp;
> +}	 __packed;
> +
> +struct	fc_ct_hdr_s	{
> +	uint32_t	rev:	8;
> +	uint32_t	in_id:	24;
> +	uint8_t		fs_type;
> +	uint8_t		fs_subtype;
> +	uint8_t		options;
> +	uint8_t		rsvd;
> +	uint16_t	command;
> +	uint16_t	max_res_size;
> +	uint8_t		rsvd1;
> +	uint8_t		reason_code;
> +	uint8_t		reason_expl;
> +	uint8_t		vendor_specific;
> +}	 __packed;
> +
> +struct	fc_rpn_id_s	{
> +	struct	fc_hdr_s	fchdr;
> +	struct	fc_ct_hdr_s	fc_ct_hdr;
> +	uint8_t		rsvd;
> +	uint8_t		port_id[3];
> +	uint64_t	port_name;
> +}	 __packed;
> +
> +struct	fc_fdmi_rhba_s	{
> +	struct	fc_hdr_s	fchdr;
> +	struct	fc_ct_hdr_s	fc_ct_hdr;
> +	uint64_t	hba_identifier;
> +	uint32_t	num_ports;
> +	uint64_t	port_name;
> +	uint32_t	num_hba_attributes;
> +	uint16_t	type_nn;
> +	uint16_t	length_nn;
> +	uint64_t	node_name;
> +	uint16_t	type_manu;
> +	uint16_t	length_manu;
> +	uint8_t		manufacturer[20];
> +	uint16_t	type_serial;
> +	uint16_t	length_serial;
> +	uint8_t		serial_num[16];
> +	uint16_t	type_model;
> +	uint16_t	length_model;
> +	uint8_t		model[12];
> +	uint16_t	type_model_des;
> +	uint16_t	length_model_des;
> +	uint8_t		model_description[56];
> +	uint16_t	type_hw_ver;
> +	uint16_t	length_hw_ver;
> +	uint8_t		hardware_ver[16];
> +	uint16_t	type_dr_ver;
> +	uint16_t	length_dr_ver;
> +	uint8_t		driver_ver[28];
> +	uint16_t	type_rom_ver;
> +	uint16_t	length_rom_ver;
> +	uint8_t		rom_ver[8];
> +	uint16_t	type_fw_ver;
> +	uint16_t	length_fw_ver;
> +	uint8_t		firmware_ver[16];
> +} __packed;
> +
> +struct	fc_fdmi_rpa_s	{
> +	struct	fc_hdr_s	fchdr;
> +	struct	fc_ct_hdr_s	fc_ct_hdr;
> +	uint64_t	port_name;
> +	uint32_t	num_port_attributes;
> +	uint16_t	type_fc4;
> +	uint16_t	length_fc4;
> +	uint8_t		fc4_type[32];
> +	uint16_t	type_supp_speed;
> +	uint16_t	length_supp_speed;
> +	uint32_t	supported_speed;
> +	uint16_t	type_cur_speed;
> +	uint16_t	length_cur_speed;
> +	uint32_t	current_speed;
> +	uint16_t	type_max_frame_size;
> +	uint16_t	length_max_frame_size;
> +	uint32_t	max_frame_size;
> +	uint16_t	type_os_name;
> +	uint16_t	length_os_name;
> +	uint8_t		os_name[16];
> +	uint16_t	type_host_name;
> +	uint16_t	length_host_name;
> +	uint8_t		host_name[12];
> +}	 __packed;
> +
> +struct	fc_rft_id	{
> +	struct	fc_hdr_s fchdr;
> +	struct	fc_ct_hdr_s	fc_ct_hdr;
> +	uint8_t		rsvd;
> +	uint8_t		port_id[3];
> +	uint8_t		fc4_types[32];
> +} __packed;
> +
> +struct	fc_rff_id	{
> +	struct	fc_hdr_s fchdr;
> +	struct	fc_ct_hdr_s	fc_ct_hdr;
> +	uint8_t		rsvd;
> +	uint8_t		port_id[3];
> +	uint8_t		rsvd1;
> +	uint8_t		rsvd2;
> +	uint8_t		tgt;
> +	uint8_t		fc4_type;
> +} __packed;
> +
> +/*
> + *	Variables:
> + *	sid
> + */
> +struct	fc_gpn_ft_s	{
> +	struct	fc_hdr_s	fchdr;
> +	struct	fc_ct_hdr_s	fc_ct_hdr;
> +	uint8_t		rsvd[3];
> +	uint8_t		fc4_type;
> +} __packed;
> +
> +/* Accept CT_IU	for	GPN_FT	*/
> +struct	fc_gpn_ft_rsp_iu_s	{
> +	uint8_t		ctrl;
> +	uint8_t		fcid[3];
> +	uint32_t	rsvd;
> +	uint64_t	wwpn;
> +} __packed;
> +
> +/*
> + *	Variables:
> + *	sid
> + */
> +struct	fc_scr_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint8_t		command;
> +	uint8_t		rsvd[3];
> +	uint8_t		rsvd1[3];
> +	uint8_t		reg_func;
> +} __packed;
> +
> +struct	fc_rscn_hdr_s	{
> +	struct	fc_hdr_s	fchdr;
> +	uint8_t		command;
> +	uint8_t		page_len;
> +	uint16_t	payload_len;
> +} __packed;
> +
> +
> +struct	fc_rscn_port_s	{
> +	uint8_t		addr_format:2;
> +	uint8_t		rscn_evt_q:4;
> +	uint8_t		reserved:2;
> +	uint8_t		port_id[3];
> +} __packed;
> +
> +struct	fc_logo_req_s	{
> +	struct fc_hdr_s	fchdr;
> +	uint8_t		command;
> +	uint8_t		rsvd[3];
> +	uint8_t		rsvd1;
> +	uint8_t		fcid[3];
> +	uint64_t	wwpn;
> +} __packed;
> +
These seem to be standard FCoE frame definitions, for which we
already have a copy in include/uapi/scsi/fc.
Please use the definitions from there instead of introducing your own.

> +#define	FNIC_FCOE_FCHDR_OFFSET	\
> +	(sizeof(struct	fnic_eth_hdr_s)	+	sizeof(struct	fnic_fcoe_hdr_s))
> +
> +#endif	/*	_FDLS_FC_H	*/
> diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
> new file mode 100644
> index 000000000000..fddb9390d022
> --- /dev/null
> +++ b/drivers/scsi/fnic/fnic_fdls.h
> @@ -0,0 +1,362 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
> + * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
> + */
> +
> +#ifndef _FNIC_FDLS_H_
> +#define _FNIC_FDLS_H_
> +
> +#include "fnic_stats.h"
> +#include "fdls_fc.h"
> +
> +/* FDLS - Fabric discovery and login services
> + * -> VLAN discovery
> + *   -> retry every retry delay seconds until it succeeds.
> + *                        <- List of VLANs
> + *
> + * -> Solicitation
> + *                        <- Solicitation response (Advertisement)
> + *
> + * -> FCF selection & FLOGI ( FLOGI timeout - 2 * E_D_TOV)
> + *                        <- FLOGI response
> + *
> + * -> FCF keep alive
> + *                         <- FCF keep alive
> + *
> + * -> PLOGI to FFFFFC (DNS) (PLOGI timeout - 2 * R_A_TOV)
> + *    -> ABTS if timeout (ABTS tomeout - 2 * R_A_TOV)
> + *                        <- PLOGI response
> + *    -> Retry PLOGI to FFFFFC (DNS) - Number of retries from vnic.cfg
> + *
> + * -> SCR to FFFFFC (DNS) (SCR timeout - 2 * R_A_TOV)
> + *    -> ABTS if timeout (ABTS tomeout - 2 * R_A_TOV)
> + *                        <- SCR response
> + *    -> Retry SCR - Number of retries 2
> + *
> + * -> GPN_FT to FFFFFC (GPN_FT timeout - 2 * R_A_TOV)a
> + *    -> Retry on BUSY until it succeeds
> + *    -> Retry on BUSY until it succeeds
> + *    -> 2 retries on timeout
> + *
> + * -> RFT_ID to FFFFFC (DNS)        (RFT_ID timeout - 3 * R_A_TOV)
> + *    -> ABTS if timeout (ABTS tomeout - 2 * R_A_TOV)
> + *    -> Retry RFT_ID to FFFFFC (DNS) (Number of retries 2 )
> + *    -> Ignore if both retires fail.
> + *
> + *        Session establishment with targets
> + * For each PWWN
> + *   -> PLOGI to FCID of that PWWN (PLOGI timeout 2 * R_A_TOV)
> + *    -> ABTS if timeout (ABTS tomeout - 2 * R_A_TOV)
> + *                        <- PLOGI response
> + *    -> Retry PLOGI. Num retries using vnic.cfg
> + *
> + *   -> PRLI to FCID of that PWWN (PRLI timeout 2 * R_A_TOV)
> + *    -> ABTS if timeout (ABTS tomeout - 2 * R_A_TOV)
> + *                        <- PRLI response
> + *    -> Retry PRLI. Num retries using vnic.cfg
> + *
> + */
> +
> +#define FDLS_RETRY_COUNT 2
> +
> +#define FDLS_TGT_OXID_BLOCK_SZ  (0x200)
> +#define FDLS_PLOGI_OXID_BASE    (0x2000)
> +#define FDLS_PRLI_OXID_BASE     (0x2200)
> +#define FDLS_ADISC_OXID_BASE    (0x2400)
> +#define FDLS_TGT_OXID_POOL_END  (FDLS_PLOGI_OXID_BASE + FDLS_TGT_OXID_POOL_SZ)
> +#define FDLS_TGT_OXID_POOL_SZ   (0x800)
> +
> +#define FNIC_FDLS_FABRIC_ABORT_ISSUED     0x1
> +#define FNIC_FDLS_FPMA_LEARNT             0x2
> +
> +/* tport flags */
> +#define FNIC_FDLS_TPORT_IN_GPN_FT_LIST 0x1
> +#define FNIC_FDLS_TGT_ABORT_ISSUED     0x2
> +#define FNIC_FDLS_TPORT_SEND_ADISC     0x4
> +#define FNIC_FDLS_RETRY_FRAME          0x8
> +#define FNIC_FDLS_TPORT_BUSY	       0x10
> +#define FNIC_FDLS_TPORT_TERMINATING      0x20
> +#define FNIC_FDLS_TPORT_DELETED        0x40
> +#define FNIC_FDLS_SCSI_REGISTERED      0x200
> +#define FNIC_TPORT_CAN_BE_FREED        0x400
> +
> +/* Retry supported by rport(returned by prli service parameters) */
> +#define FDLS_FC_RP_FLAGS_RETRY 0x1
> +
> +#define fdls_set_state(_fdls_fabric, _state)  ((_fdls_fabric)->state = _state)
> +#define fdls_get_state(_fdls_fabric)          ((_fdls_fabric)->state)
> +
> +#define FNIC_FDMI_ACTIVE    0x8
> +#define FNIC_FIRST_LINK_UP    0x2
> +
> +#define fdls_set_tport_state(_tport, _state)    (_tport->state = _state)
> +#define fdls_get_tport_state(_tport)            (_tport->state)
> +
> +#define fnic_del_fabric_timer_sync() {							\
> +	iport->fabric.del_timer_inprogress = 1;						\
> +	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);	\
> +	del_timer_sync(&iport->fabric.retry_timer);					\
> +	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);		\
> +	iport->fabric.del_timer_inprogress = 0;						\
> +}
> +
Please, make this an inline function.

> +#define fnic_del_tport_timer_sync() {							\
> +	tport->del_timer_inprogress = 1;							\
> +	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);	\
> +	del_timer_sync(&tport->retry_timer);						\
> +	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);		\
> +	tport->del_timer_inprogress = 0;							\
> +}
> +
Same here.

> +#define FNIC_PORTSPEED_10GBIT   1
> +#define FNIC_FRAME_HT_ROOM     (2148)
> +#define FNIC_FCOE_FRAME_MAXSZ   (2112)
> +
> +struct fnic_fip_fcf_s {
> +	uint16_t vlan_id;
> +	uint8_t fcf_mac[6];
> +	uint8_t fcf_priority;
> +	uint32_t fka_adv_period;
> +	uint8_t ka_disabled;
> +};
> +
> +enum fnic_fdls_state_e {
> +	FDLS_STATE_INIT = 0,
> +	FDLS_STATE_LINKDOWN,
> +	FDLS_STATE_FABRIC_LOGO,
> +	FDLS_STATE_FLOGO_DONE,
> +	FDLS_STATE_FABRIC_FLOGI,
> +	FDLS_STATE_FABRIC_PLOGI,
> +	FDLS_STATE_RPN_ID,
> +	FDLS_STATE_REGISTER_FC4_TYPES,
> +	FDLS_STATE_REGISTER_FC4_FEATURES,
> +	FDLS_STATE_SCR,
> +	FDLS_STATE_GPN_FT,
> +	FDLS_STATE_TGT_DISCOVERY,
> +	FDLS_STATE_RSCN_GPN_FT,
> +	FDLS_STATE_SEND_GPNFT
> +};
> +
> +struct fnic_fdls_fabric_s {
> +	enum fnic_fdls_state_e state;
> +	uint32_t flags;
> +	struct list_head tport_list; /* List of discovered tports */
> +	struct timer_list retry_timer;
> +	int del_timer_inprogress;
> +	int del_fdmi_timer_inprogress;
> +	int retry_counter;
> +	int timer_pending;
> +	int fdmi_retry;
> +	struct timer_list fdmi_timer;
> +	int fdmi_pending;
> +};
> +
> +struct fnic_fdls_fip_s {
> +	uint32_t state;
> +	uint32_t flogi_retry;
> +};
> +
> +/* Message to tport_event_handler */
> +enum fnic_tgt_msg_id {
> +	TGT_EV_NONE = 0,
> +	TGT_EV_RPORT_ADD,
> +	TGT_EV_RPORT_DEL,
> +	TGT_EV_TPORT_DELETE,
> +	TGT_EV_REMOVE
> +};
> +
> +struct fnic_tport_event_s {
> +	struct list_head links;
> +	enum fnic_tgt_msg_id event;
> +	void *arg1;
> +};
> +
> +enum fdls_tgt_state_e {
> +	FDLS_TGT_STATE_INIT = 0,
> +	FDLS_TGT_STATE_PLOGI,
> +	FDLS_TGT_STATE_PRLI,
> +	FDLS_TGT_STATE_READY,
> +	FDLS_TGT_STATE_LOGO_RECEIVED,
> +	FDLS_TGT_STATE_ADISC,
> +	FDL_TGT_STATE_PLOGO,
> +	FDLS_TGT_STATE_OFFLINING,
> +	FDLS_TGT_STATE_OFFLINE
> +};
> +
> +struct fnic_tport_s {
> +	struct list_head links; /* To link the tports */
> +	enum fdls_tgt_state_e state;
> +	uint32_t flags;
> +	uint32_t fcid;
> +	uint64_t wwpn;
> +	uint64_t wwnn;
> +	uint16_t oxid_used;
> +	uint16_t tgt_flags;
> +	atomic_t in_flight; /* io counter */
> +	uint16_t max_payload_size;
> +	uint16_t r_a_tov;
> +	uint16_t e_d_tov;
> +	uint16_t lun0_delay;
> +	int max_concur_seqs;
> +	uint32_t fcp_csp;
> +	struct timer_list retry_timer;
> +	int del_timer_inprogress;
> +	int retry_counter;
> +	int timer_pending;
> +	unsigned int num_pending_cmds;
> +	int nexus_restart_count;
> +	int exch_reset_in_progress;
> +	void *iport;
> +	struct work_struct tport_del_work;
> +	struct completion *tport_del_done;
> +	struct delayed_work tport_scan_work;
> +	struct fc_rport *rport;
> +	char str_wwpn[20];
> +	char str_wwnn[20];
> +};
> +
> +/* iport */
> +enum fnic_iport_state_e {
> +	FNIC_IPORT_STATE_INIT = 0,
> +	FNIC_IPORT_STATE_LINK_WAIT,
> +	FNIC_IPORT_STATE_FIP,
> +	FNIC_IPORT_STATE_FABRIC_DISC,
> +	FNIC_IPORT_STATE_READY
> +};
> +
> +struct fnic_iport_s {
> +	enum fnic_iport_state_e state;
> +	struct fnic *fnic;
> +	uint64_t boot_time;
> +	uint32_t flags;
> +	int usefip;
> +	uint8_t hwmac[6]; /* HW MAC Addr */
> +	uint8_t fpma[6]; /* Fabric Provided MA */
> +	uint8_t fcfmac[6]; /* MAC addr of Fabric */
> +	uint16_t vlan_id;
> +	uint32_t fcid;
> +	uint8_t tgt_oxid_pool[FDLS_TGT_OXID_POOL_SZ];
> +	struct fnic_fip_fcf_s selected_fcf;
> +	struct fnic_fdls_fip_s fip;
> +	struct fnic_fdls_fabric_s fabric;
> +	struct list_head tport_list;
> +	struct list_head tport_list_pending_del;
> +	/* list of tports for which we are yet to send PLOGO */
> +	struct list_head inprocess_tport_list;
> +	struct list_head deleted_tport_list;
> +	struct work_struct tport_event_work;
> +	uint32_t e_d_tov; /* msec */
> +	uint32_t r_a_tov; /* msec */
> +	uint32_t link_supported_speeds;
> +	uint32_t max_flogi_retries;
> +	uint32_t max_plogi_retries;
> +	uint32_t plogi_timeout;
> +	uint32_t service_params;
> +	uint64_t wwpn;
> +	uint64_t wwnn;
> +	uint16_t max_payload_size;
> +	spinlock_t deleted_tport_lst_lock;
> +	struct completion *flogi_reg_done;
> +	char str_wwpn[20];
> +	char str_wwnn[20];
> +	};
> +	struct rport_dd_data_s {
> +	struct fnic_tport_s *tport;
> +	struct fnic_iport_s *iport;
> +};
> +
> +enum fnic_recv_frame_type_e {
> +	FNIC_FABRIC_FLOGI_RSP = 0,
> +	FNIC_FABRIC_PLOGI_RSP,
> +	FNIC_FDMI_PLOGI_RSP,
> +	FNIC_FABRIC_RPN_RSP,
> +	FNIC_FABRIC_RFT_RSP,
> +	FNIC_FABRIC_RFF_RSP,
> +	FNIC_FABRIC_SCR_RSP,
> +	FNIC_FABRIC_GPN_FT_RSP,
> +	FNIC_TPORT_PLOGI_RSP,
> +	FNIC_TPORT_PRLI_RSP,
> +	FNIC_TPORT_ADISC_RSP,
> +	FNIC_TPORT_LOGO_RSP,
> +	FNIC_BLS_ABTS_REQ,
> +	FNIC_FABRIC_LOGO_RSP,
> +	FNIC_BLS_ABTS_RSP,
> +	FNIC_ELS_PLOGI_REQ,
> +	FNIC_ELS_RSCN_REQ,
> +	FNIC_ELS_LOGO_REQ,
> +	FNIC_ELS_ECHO_REQ,
> +	FNIC_ELS_ADISC,
> +	FNIC_ELS_RLS,
> +	FNIC_ELS_UNSUPPORTED_REQ,
> +	FNIC_ELS_RRQ,
> +	FNIC_FDMI_RSP,
> +};
> +
> +enum fnic_port_speeds {
> +	DCEM_PORTSPEED_NONE = 0,
> +	DCEM_PORTSPEED_1G = 1000,
> +	DCEM_PORTSPEED_2G = 2000,
> +	DCEM_PORTSPEED_4G = 4000,
> +	DCEM_PORTSPEED_8G = 8000,
> +	DCEM_PORTSPEED_10G = 10000,
> +	DCEM_PORTSPEED_16G = 16000,
> +	DCEM_PORTSPEED_20G = 20000,
> +	DCEM_PORTSPEED_25G = 25000,
> +	DCEM_PORTSPEED_32G = 32000,
> +	DCEM_PORTSPEED_40G = 40000,
> +	DCEM_PORTSPEED_4x10G = 41000,
> +	DCEM_PORTSPEED_50G = 50000,
> +	DCEM_PORTSPEED_64G = 64000,
> +	DCEM_PORTSPEED_100G = 100000,
> +	DCEM_PORTSPEED_128G = 128000,
> +};
> +
> +/* Function Declarations */
> +/* fdls_disc.c */
> +void fnic_fdls_disc_init(struct fnic_iport_s *iport);
> +void fnic_fdls_disc_start(struct fnic_iport_s *iport);
> +void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame, int len,
> +	int fchdr_offset);
> +void fnic_fdls_link_down(struct fnic_iport_s *iport);
> +void fdls_init_tgt_oxid_pool(struct fnic_iport_s *iport);
> +void fdls_tgt_logout(struct fnic_iport_s *iport, struct fnic_tport_s *tport);
> +
> +/* fnic_fcs.c */
> +void fnic_fdls_init(struct fnic *fnic, int usefip);
> +int fnic_send_fcoe_frame(struct fnic_iport_s *iport, void *payload,
> +	int payload_sz);
> +
> +int fnic_send_fip_frame(struct fnic_iport_s *iport,
> +	void *payload, int payload_sz);
> +void fnic_fdls_learn_fcoe_macs(struct fnic_iport_s *iport, void *rx_frame,
> +	uint8_t *fcid);
> +
> +void fnic_fdls_add_tport(struct fnic_iport_s *iport,
> +		struct fnic_tport_s *tport, unsigned long flags);
> +void fnic_fdls_remove_tport(struct fnic_iport_s *iport,
> +		struct fnic_tport_s *tport, unsigned long flags);
> +
> +/* fip.c */
> +void fnic_fcoe_send_vlan_req(struct fnic *fnic);
> +void fnic_common_fip_cleanup(struct fnic *fnic);
> +int fdls_fip_recv_frame(struct fnic *fnic, void *frame);
> +void fnic_handle_fcs_ka_timer(struct timer_list *t);
> +void fnic_handle_enode_ka_timer(struct timer_list *t);
> +void fnic_handle_vn_ka_timer(struct timer_list *t);
> +void fnic_handle_fip_timer(struct timer_list *t);
> +extern void fdls_fabric_timer_callback(struct timer_list *t);
> +
> +/* fnic_scsi.c */
> +void fnic_scsi_fcpio_reset(struct fnic *fnic);
> +extern void fdls_fabric_timer_callback(struct timer_list *t);
> +void fnic_rport_exch_reset(struct fnic *fnic, u32 fcid);
> +int fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
> +		void *fp);
> +struct fnic_tport_s *fnic_find_tport_by_fcid(struct fnic_iport_s *iport,
> +		uint32_t fcid);
> +struct fnic_tport_s *fnic_find_tport_by_wwpn(struct fnic_iport_s *iport,
> +		uint64_t  wwpn);
> +
> +#endif /* _FNIC_FDLS_H_ */
> +

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

