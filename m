Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A56156458;
	Wed, 12 Jun 2024 06:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718173899; cv=none; b=Dywp9s1CrmEG3lgOGrXy4y1NpX11aghYA/JT0hTBjGE/IVN2Bklr6VBKBSxq8t+PY5LnuDCq0+8byffGopTXXX7YDRK4PilW+/5Jd0wlJuM16lRIsze4LNCSYmZnE7+Kr/dlrKVrVh0fa+2aiDZvpuyJ/APmdofEdPENuB4sRQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718173899; c=relaxed/simple;
	bh=V3CqJ/KyuznXctdYKuOadKon1HEHs3gauUZwCj48N8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bbeljdtMXA73vwWdUSxuqHqQQ/fJUjJLB2gY2lfr9Q6tKICNVQTkLg2tz9efDUo5X5WiOh0K55RfX6DesrfISNDYbfQd42GDvXpjuTdXzK3oCL4HAMI5jQ1lPJsitRTEGLXQ8Byte4BKekZlyvuyoiptZ259n8lLWvRidEOk7n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vdCTvsss; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=STTz564A; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vdCTvsss; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=STTz564A; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vdCTvsss";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="STTz564A";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vdCTvsss";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="STTz564A"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4CAEF33F74;
	Wed, 12 Jun 2024 06:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718173895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZKjY++PBedWHU3LwpM1DK3ZDLeMyIOdYGrU0gAFA+w=;
	b=vdCTvsssEZsH5zvck4QuENbjZifR8q/DL2/52jZJN1W81wHBAekYcfBOpYHdktgUFiuMK5
	73fOdD3KGrI4Ee9bE8PGF1QcwSAQwXJ/shAcNZ80TXZgHzb/eO1HBbOMpuxJ1Gy1ALTlAd
	37dmnJsvegXtUBu2cyduHtNSk1BI4oU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718173895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZKjY++PBedWHU3LwpM1DK3ZDLeMyIOdYGrU0gAFA+w=;
	b=STTz564AzPMA/JNV7V6NPX/psXfsRUQScnbmtb1XM1XJ/nIR6nS/l23BG9WaPSaAnJH+sL
	awW1lOJzm+0D1SAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vdCTvsss;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=STTz564A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718173895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZKjY++PBedWHU3LwpM1DK3ZDLeMyIOdYGrU0gAFA+w=;
	b=vdCTvsssEZsH5zvck4QuENbjZifR8q/DL2/52jZJN1W81wHBAekYcfBOpYHdktgUFiuMK5
	73fOdD3KGrI4Ee9bE8PGF1QcwSAQwXJ/shAcNZ80TXZgHzb/eO1HBbOMpuxJ1Gy1ALTlAd
	37dmnJsvegXtUBu2cyduHtNSk1BI4oU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718173895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZKjY++PBedWHU3LwpM1DK3ZDLeMyIOdYGrU0gAFA+w=;
	b=STTz564AzPMA/JNV7V6NPX/psXfsRUQScnbmtb1XM1XJ/nIR6nS/l23BG9WaPSaAnJH+sL
	awW1lOJzm+0D1SAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0D601372E;
	Wed, 12 Jun 2024 06:31:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ojmKJ8ZAaWbROgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 12 Jun 2024 06:31:34 +0000
Message-ID: <5f1c50f5-5128-4b18-a8e0-e1bfbc3c655c@suse.de>
Date: Wed, 12 Jun 2024 08:31:34 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/14] scsi: fnic: Add support for unsolicited requests
 and responses
Content-Language: en-US
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-6-kartilak@cisco.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240610215100.673158-6-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4CAEF33F74
X-Spam-Flag: NO
X-Spam-Score: -6.50
X-Spam-Level: 

On 6/10/24 23:50, Karan Tilak Kumar wrote:
> Add support for unsolicited requests and responses.
> Add support to accept and reject frames.
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
>   drivers/scsi/fnic/fdls_disc.c | 566 +++++++++++++++++++++++++++++++++-
>   1 file changed, 563 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> index d920202d413d..ad115de86f15 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -125,6 +125,21 @@ struct fc_scr_s fnic_scr_req = {
>   	.reg_func = 0x03
>   };
>   
> +/*
> + * Variables:
> + * did, ox_id, rx_id
> + */
> +struct fc_els_acc_s fnic_els_acc = {
> +	.fchdr = {.r_ctl = 0x23, .did = {0xFF, 0xFF, 0xFD}, .type = 0x01,
> +			  .f_ctl = FNIC_ELS_REP_FCTL},
> +	.command = FC_LS_ACC,
> +};
> +
> +struct fc_els_reject_s fnic_els_rjt = {
> +	.fchdr = {.r_ctl = 0x23, .type = 0x01, .f_ctl = FNIC_ELS_REP_FCTL},
> +	.command = FC_LS_REJ,
> +};
> +
>   /*
>    * Variables:
>    * did, ox_id, rx_id, fcid, wwpn
> @@ -135,6 +150,13 @@ struct fc_logo_req_s fnic_logo_req = {
>   	.command = FC_ELS_LOGO,
>   };
>   
> +static struct fc_abts_ba_acc_s fnic_ba_acc = {
> +	.fchdr = {.r_ctl = 0x84,
> +			  .f_ctl = FNIC_FCP_RSP_FCTL},
> +	.low_seq_cnt = 0,
> +	.high_seq_cnt = 0xFFFF,
> +};
> +
>   #define RETRIES_EXHAUSTED(iport)      \
>   	(iport->fabric.retry_counter == FABRIC_LOGO_MAX_RETRY)
>   
> @@ -150,7 +172,6 @@ static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
>   static void fdls_target_restart_nexus(struct fnic_tport_s *tport);
>   static void fdls_start_tport_timer(struct fnic_iport_s *iport,
>   					struct fnic_tport_s *tport, int timeout);
> -
>   static void fdls_start_fabric_timer(struct fnic_iport_s *iport,
>   			int timeout);
>   static void fdls_tport_timer_callback(struct timer_list *t);
> @@ -231,6 +252,48 @@ fdls_start_tport_timer(struct fnic_iport_s *iport,
>   	tport->timer_pending = 1;
>   }
>   
> +static void
> +fdls_send_rscn_resp(struct fnic_iport_s *iport,
> +					struct fc_hdr_s *rscn_fchdr)
> +{
> +	struct fc_els_acc_s els_acc;
> +	uint16_t oxid;
> +	uint8_t fcid[3];
> +
> +	memcpy(&els_acc, &fnic_els_acc, sizeof(struct fc_els_acc_s));
> +
> +	hton24(fcid, iport->fcid);
> +	FNIC_SET_S_ID((&els_acc.fchdr), fcid);
> +	FNIC_SET_D_ID((&els_acc.fchdr), rscn_fchdr->sid);
> +
> +	oxid = FNIC_GET_OX_ID(rscn_fchdr);
> +	FNIC_SET_OX_ID((&els_acc.fchdr), oxid);
> +
> +	FNIC_SET_RX_ID((&els_acc.fchdr), FNIC_RSCN_RESP_OXID);
> +
> +	fnic_send_fcoe_frame(iport, &els_acc, sizeof(struct fc_els_acc_s));
> +}
> +
> +static void
> +fdls_send_logo_resp(struct fnic_iport_s *iport, struct fc_hdr_s *req_fchdr)
> +{
> +	struct fc_els_acc_s logo_resp;
> +	uint16_t oxid;
> +	uint8_t fcid[3];
> +
> +	memcpy(&logo_resp, &fnic_els_acc, sizeof(struct fc_els_acc_s));
> +
> +	hton24(fcid, iport->fcid);
> +	FNIC_SET_S_ID((&logo_resp.fchdr), fcid);
> +	FNIC_SET_D_ID((&logo_resp.fchdr), req_fchdr->sid);
> +
> +	oxid = FNIC_GET_OX_ID(req_fchdr);
> +	FNIC_SET_OX_ID((&logo_resp.fchdr), oxid);
> +
> +	FNIC_SET_RX_ID((&logo_resp.fchdr), FNIC_LOGO_RESP_OXID);
> +	fnic_send_fcoe_frame(iport, &logo_resp, sizeof(struct fc_els_acc_s));
> +}
> +
>   void
>   fdls_send_tport_abts(struct fnic_iport_s *iport,
>   					 struct fnic_tport_s *tport)
> @@ -2541,6 +2604,188 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
>   	}
>   }
>   
> +static void
> +fdls_process_abts_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
> +{
> +	struct fc_abts_ba_acc_s ba_acc;
> +	uint32_t nport_id;
> +	uint16_t oxid;
> +	struct fnic_tport_s *tport;
> +	struct fnic *fnic = iport->fnic;
> +
> +	nport_id = ntoh24(fchdr->sid);
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Received abort from SID %8x", nport_id);
> +
> +	tport = fnic_find_tport_by_fcid(iport, nport_id);
> +	if (tport) {
> +		oxid = FNIC_GET_OX_ID(fchdr);
> +		if (tport->oxid_used == oxid) {
> +			tport->flags |= FNIC_FDLS_TGT_ABORT_ISSUED;
> +			fdls_free_tgt_oxid(iport, ntohs(oxid));
> +		}

Hmm. This is an abort, right?
Don't you need to look up the command referred to by 'oxid'?
Just freeing the oxid doesn't abort the command itself...

> +	}
> +
> +	memcpy(&ba_acc, &fnic_ba_acc, sizeof(struct fc_abts_ba_acc_s));
> +	FNIC_SET_S_ID((&ba_acc.fchdr), fchdr->did);
> +	FNIC_SET_D_ID((&ba_acc.fchdr), fchdr->sid);
> +
> +	ba_acc.fchdr.rx_id = fchdr->rx_id;
> +	ba_acc.rx_id = ba_acc.fchdr.rx_id;
> +	ba_acc.fchdr.ox_id = fchdr->ox_id;
> +	ba_acc.ox_id = ba_acc.fchdr.ox_id;
> +
> +	fnic_send_fcoe_frame(iport, &ba_acc, sizeof(struct fc_abts_ba_acc_s));
> +}
> +
> +static void
> +fdls_process_unsupported_els_req(struct fnic_iport_s *iport,
> +								 struct fc_hdr_s *fchdr)
> +{
> +	struct fc_els_reject_s ls_rsp;
> +	uint16_t oxid;
> +	uint32_t d_id = ntoh24(fchdr->did);
> +	struct fnic *fnic = iport->fnic;
> +
> +	memcpy(&ls_rsp, &fnic_els_rjt, sizeof(struct fc_els_reject_s));
> +
> +	if (iport->fcid != d_id) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +			 "Dropping unsupported ELS with illegal frame bits 0x%x\n",
> +			 d_id);
> +		return;
> +	}
> +
> +	if ((iport->state != FNIC_IPORT_STATE_READY)
> +		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +			 "Dropping unsupported ELS request in iport state: %d",
> +			 iport->state);
> +		return;
> +	}
> +
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Process unsupported ELS request from SID: 0x%x",
> +				 ntoh24(fchdr->sid));
> +	/* We don't support this ELS request, send a reject */
> +	ls_rsp.reason_code = 0x0B;
> +	ls_rsp.reason_expl = 0x0;
> +	ls_rsp.vendor_specific = 0x0;
> +
> +	FNIC_SET_S_ID((&ls_rsp.fchdr), fchdr->did);
> +	FNIC_SET_D_ID((&ls_rsp.fchdr), fchdr->sid);
> +	oxid = FNIC_GET_OX_ID(fchdr);
> +	FNIC_SET_OX_ID((&ls_rsp.fchdr), oxid);
> +
> +	FNIC_SET_RX_ID((&ls_rsp.fchdr), FNIC_UNSUPPORTED_RESP_OXID);
> +	fnic_send_fcoe_frame(iport, &ls_rsp, sizeof(struct fc_els_reject_s));
> +}
> +
> +static void
> +fdls_process_rls_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
> +{
> +	struct fc_els_rls_ls_acc_s rls_acc_rsp;
> +	uint16_t oxid;
> +	struct fnic *fnic = iport->fnic;
> +
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Process RLS request %d", iport->fnic->fnic_num);
> +
> +	if ((iport->state != FNIC_IPORT_STATE_READY)
> +		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +			 "Received RLS req in iport state: %d. Dropping the frame.",
> +			 iport->state);
> +		return;
> +	}
> +
> +	memset(&rls_acc_rsp, 0, sizeof(struct fc_els_rls_ls_acc_s));
> +
> +	FNIC_SET_S_ID((&rls_acc_rsp.fchdr), fchdr->did);
> +	FNIC_SET_D_ID((&rls_acc_rsp.fchdr), fchdr->sid);
> +	oxid = FNIC_GET_OX_ID(fchdr);
> +	FNIC_SET_OX_ID((&rls_acc_rsp.fchdr), oxid);
> +	FNIC_SET_RX_ID((&rls_acc_rsp.fchdr), 0xffff);
> +	rls_acc_rsp.fchdr.f_ctl = FNIC_ELS_REP_FCTL;
> +	rls_acc_rsp.fchdr.r_ctl = 0x23;
> +	rls_acc_rsp.fchdr.type = 0x01;
> +	rls_acc_rsp.command = FC_LS_ACC;
> +	rls_acc_rsp.link_fail_count = htonl(iport->fnic->link_down_cnt);
> +
> +	fnic_send_fcoe_frame(iport, &rls_acc_rsp,
> +						 sizeof(struct fc_els_rls_ls_acc_s));

Indentation.

> +}
> +
> +static void
> +fdls_process_els_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
> +					 uint32_t len)
> +{
> +	struct fc_els_acc_s *els_acc;
> +	uint16_t oxid;
> +	uint8_t fcid[3];
> +	uint8_t *fc_payload;
> +	uint8_t *dst_frame;
> +	uint8_t type;
> +	struct fnic *fnic = iport->fnic;
> +
> +	fc_payload = (uint8_t *) fchdr + sizeof(struct fc_hdr_s);
> +	type = *fc_payload;
> +
> +	if ((iport->state != FNIC_IPORT_STATE_READY)
> +		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Dropping ELS frame type :%x in iport state: %d",
> +				 type, iport->state);
> +		return;
> +	}
> +	switch (type) {
> +	case FC_ELS_ECHO_REQ:
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "sending LS_ACC for ECHO request %d\n",
> +					 iport->fnic->fnic_num);
> +		break;
> +
> +	case FC_ELS_RRQ_REQ:
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "sending LS_ACC for RRQ request %d\n",
> +					 iport->fnic->fnic_num);
> +		break;
> +
> +	default:
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "sending LS_ACC for %x ELS frame\n", type);
> +		break;
> +	}
> +	dst_frame = kzalloc(len, GFP_ATOMIC);
> +	if (!dst_frame) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "Failed to allocate ELS response for %x", type);
> +		return;
> +	}
> +	if (type == FC_ELS_ECHO_REQ) {
> +		/* Brocade sends a longer payload, copy all frame back */
> +		memcpy(dst_frame, fchdr, len);
> +	}
> +
> +	els_acc = (struct fc_els_acc_s *) dst_frame;
> +	memcpy(els_acc, &fnic_els_acc, sizeof(struct fc_els_acc_s));
> +
> +	hton24(fcid, iport->fcid);
> +	FNIC_SET_S_ID((&els_acc->fchdr), fcid);
> +	FNIC_SET_D_ID((&els_acc->fchdr), fchdr->sid);
> +
> +	oxid = FNIC_GET_OX_ID(fchdr);
> +	FNIC_SET_OX_ID((&els_acc->fchdr), oxid);
> +	FNIC_SET_RX_ID((&els_acc->fchdr), 0xffff);
> +
> +	if (type == FC_ELS_ECHO_REQ)
> +		fnic_send_fcoe_frame(iport, els_acc, len);
> +	else
> +		fnic_send_fcoe_frame(iport, els_acc, sizeof(struct fc_els_acc_s));
> +
> +	kfree(dst_frame);
> +}
> +
>   static void
>   fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
>   						  struct fc_hdr_s *fchdr)
> @@ -2584,8 +2829,8 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
>   	if ((oxid >= FDLS_ADISC_OXID_BASE) && (oxid < FDLS_TGT_OXID_POOL_END)) {
>   		if (fchdr->r_ctl == FNIC_BA_ACC_RCTL) {
>   			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> -						 "Received tgt ADISC abts response BA_ACC for OX_ID: 0x%x tgt_fcid: 0x%x",
> -						 ba_acc->ox_id, tport->fcid);
> +				 "OX_ID: 0x%x tgt_fcid: 0x%x rcvd tgt adisc abts resp BA_ACC",
> +				 ba_acc->ox_id, tport->fcid);
>   		} else if (fchdr->r_ctl == FNIC_BA_RJT_RCTL) {
>   			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
>   				 "ADISC BA_RJT rcvd tport_fcid: 0x%x tport_state: %d ",
> @@ -2676,6 +2921,296 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
>   				 "Received ABTS response for unknown frame %p", iport);
>   }
>   
> +static void
> +fdls_process_plogi_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
> +{
> +	struct fc_els_reject_s plogi_rsp;
> +	uint16_t oxid;
> +	uint32_t d_id = ntoh24(fchdr->did);
> +	struct fnic *fnic = iport->fnic;
> +
> +	memcpy(&plogi_rsp, &fnic_els_rjt, sizeof(struct fc_els_reject_s));
> +
> +	if (iport->fcid != d_id) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +			 "Received PLOGI with illegal frame bits. Dropping frame %p",
> +			 iport);
> +		return;
> +	}
> +
> +	if (iport->state != FNIC_IPORT_STATE_READY) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +			 "Received PLOGI request in iport state: %d Dropping frame",
> +			 iport->state);
> +		return;
> +	}
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Process PLOGI request from SID: 0x%x",
> +				 ntoh24(fchdr->sid));
> +
> +	/* We don't support PLOGI request, send a reject */
> +	plogi_rsp.reason_code = 0x0B;
> +	plogi_rsp.reason_expl = 0x0;
> +	plogi_rsp.vendor_specific = 0x0;
> +
> +	FNIC_SET_S_ID((&plogi_rsp.fchdr), fchdr->did);
> +	FNIC_SET_D_ID((&plogi_rsp.fchdr), fchdr->sid);
> +
> +	oxid = FNIC_GET_OX_ID(fchdr);
> +	FNIC_SET_OX_ID((&plogi_rsp.fchdr), oxid);
> +
> +	FNIC_SET_RX_ID((&plogi_rsp.fchdr), FNIC_PLOGI_RESP_OXID);
> +	fnic_send_fcoe_frame(iport, &plogi_rsp,
> +						 sizeof(struct fc_els_reject_s));

Indentaion again.

> +}
> +
> +static void
> +fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
> +{
> +	struct fc_logo_req_s *logo = (struct fc_logo_req_s *) fchdr;
> +	uint32_t nport_id;
> +	uint64_t nport_name;
> +	struct fnic_tport_s *tport;
> +	struct fnic *fnic = iport->fnic;
> +	uint16_t oxid;
> +
> +	nport_id = ntoh24(logo->fcid);
> +	nport_name = logo->wwpn;
> +
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Process LOGO request from fcid: 0x%x", nport_id);
> +
> +	if (iport->state != FNIC_IPORT_STATE_READY) {
> +		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> +			 "Dropping LOGO req from 0x%x in iport state: %d",
> +			 nport_id, iport->state);
> +		return;
> +	}
> +
> +	tport = fnic_find_tport_by_fcid(iport, nport_id);
> +
> +	if (!tport) {
> +		/* We are not logged in with the nport, log and drop... */
> +		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> +					 "Received LOGO from an nport not logged in: 0x%x",
> +					 nport_id);
> +		return;
> +	}
> +	if (tport->fcid != nport_id) {
> +		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> +					 "Received LOGO with invalid target port fcid: 0x%x",
> +					 nport_id);
> +		return;
> +	}
> +	if (tport->timer_pending) {
> +		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> +					 "tport fcid 0x%x: Canceling disc timer\n",
> +					 tport->fcid);
> +		fnic_del_tport_timer_sync();
> +		tport->timer_pending = 0;
> +	}
> +
> +	/* got a logo in response to adisc to a target which has logged out */
> +	if (tport->state == FDLS_TGT_STATE_ADISC) {
> +		tport->retry_counter = 0;
> +		oxid = ntohs(tport->oxid_used);
> +		fdls_free_tgt_oxid(iport, oxid);
> +		fdls_delete_tport(iport, tport);
> +		fdls_send_logo_resp(iport, &logo->fchdr);
> +		if ((iport->state == FNIC_IPORT_STATE_READY)
> +			&& (fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT)
> +			&& (fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
> +			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> +						 "Sending GPNFT in response to LOGO from Target:0x%x",
> +						 nport_id);
> +			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
> +			return;
> +		}
> +	} else {
> +		fdls_delete_tport(iport, tport);
> +	}
> +	if (iport->state == FNIC_IPORT_STATE_READY) {
> +		fdls_send_logo_resp(iport, &logo->fchdr);
> +		if ((fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT) &&
> +			(fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
> +			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> +						 "Sending GPNFT in response to LOGO from Target:0x%x",
> +						 nport_id);
> +			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
> +		}
> +	}
> +}
> +
> +static void
> +fdls_process_rscn(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
> +{
> +	struct fc_rscn_hdr_s *rscn;
> +	struct fc_rscn_port_s *rscn_port = NULL;
> +	int num_ports;
> +	struct fnic_tport_s *tport, *next;
> +	uint32_t nport_id;
> +	uint8_t fcid[3];
> +	int newports = 0;
> +	struct fnic_fdls_fabric_s *fdls = &iport->fabric;
> +	struct fnic *fnic = iport->fnic;
> +
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "FDLS process RSCN %p", iport);
> +
> +	if (iport->state != FNIC_IPORT_STATE_READY) {
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "FDLS RSCN received in state(%d). Dropping",
> +					 fdls_get_state(fdls));
> +		return;
> +	}
> +
> +	rscn = (struct fc_rscn_hdr_s *) fchdr;
> +	/* frame validation */
> +	if ((rscn->payload_len % 4 != 0) || (rscn->payload_len < 8)
> +		|| (rscn->payload_len > 1024) || (rscn->page_len != 4)) {
> +		num_ports = 0;
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "RSCN payload_len: 0x%x page_len: 0x%x",
> +					 rscn->payload_len, rscn->page_len);
> +		/* if this happens then we need to send ADISC to all the tports. */
> +		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
> +			if (tport->state == FDLS_TGT_STATE_READY)
> +				tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
> +			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +						 "RSCN for port id: 0x%x", tport->fcid);
> +		}
> +	} else {
> +		num_ports = (rscn->payload_len - 4) / rscn->page_len;
> +		rscn_port = (struct fc_rscn_port_s *) (rscn + 1);
> +	}
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +			 "RSCN received for num_ports: %d payload_len: %d page_len: %d ",
> +			 num_ports, rscn->payload_len, rscn->page_len);
> +
> +	/*
> +	 * RSCN have at least one Port_ID page , but may not have any port_id
> +	 * in it. If no port_id is specified in the Port_ID page , we send
> +	 * ADISC to all the tports
> +	 */
> +
> +	while (num_ports) {
> +
> +		memcpy(fcid, rscn_port->port_id, 3);
> +
> +		nport_id = ntoh24(fcid);
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "RSCN event: 0x%x for 0x%x", rscn_port->rscn_evt_q,
> +					 nport_id);
> +		rscn_port++;
> +		num_ports--;
> +		/* if this happens then we need to send ADISC to all the tports. */
> +		if (nport_id == 0) {
> +			list_for_each_entry_safe(tport, next, &iport->tport_list,
> +									 links) {
> +				if (tport->state == FDLS_TGT_STATE_READY)
> +					tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
> +
> +				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +							 "RSCN for port id: 0x%x", tport->fcid);
> +			}
> +			break;
> +		}
> +		tport = fnic_find_tport_by_fcid(iport, nport_id);
> +
> +		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +					 "RSCN port id list: 0x%x", nport_id);
> +
> +		if (!tport) {
> +			newports++;
> +			continue;
> +		}
> +		if (tport->state == FDLS_TGT_STATE_READY)
> +			tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
> +	}
> +
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "FDLS process RSCN sending GPN_FT %p", iport);
> +	fdls_send_gpn_ft(iport, FDLS_STATE_RSCN_GPN_FT);
> +	fdls_send_rscn_resp(iport, fchdr);
> +}
> +
> +static void
> +fdls_process_adisc_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
> +{
> +	struct fc_els_adisc_ls_acc_s adisc_acc;
> +	struct fc_els_adisc_s *adisc_req = (struct fc_els_adisc_s *) fchdr;
> +	uint64_t frame_wwnn;
> +	uint64_t frame_wwpn;
> +	uint32_t tgt_fcid;
> +	struct fnic_tport_s *tport;
> +	uint8_t *fcid;
> +	struct fc_els_reject_s rjts_rsp;
> +	uint16_t oxid;
> +	struct fnic *fnic = iport->fnic;
> +
> +	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
> +				 "Process ADISC request %d", iport->fnic->fnic_num);
> +
> +	fcid = FNIC_GET_S_ID(fchdr);
> +	tgt_fcid = ntoh24(fcid);
> +	tport = fnic_find_tport_by_fcid(iport, tgt_fcid);
> +	if (!tport) {
> +		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> +					 "tport for fcid: 0x%x not found. Dropping ADISC req.",
> +					 tgt_fcid);
> +		return;
> +	}
> +	if (iport->state != FNIC_IPORT_STATE_READY) {
> +		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> +			 "Dropping ADISC req from fcid: 0x%x in iport state: %d",
> +			 tgt_fcid, iport->state);
> +		return;
> +	}
> +
> +	frame_wwnn = ntohll(adisc_req->node_name);
> +	frame_wwpn = ntohll(adisc_req->nport_name);
> +
> +	if ((frame_wwnn != tport->wwnn) || (frame_wwpn != tport->wwpn)) {
> +		/* send reject */
> +		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> +			 "ADISC req from fcid: 0x%x mismatch wwpn: 0x%llx wwnn: 0x%llx",
> +			 tgt_fcid, frame_wwpn, frame_wwnn);
> +		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
> +			 "local tport wwpn: 0x%llx wwnn: 0x%llx. Sending RJT",
> +			 tport->wwpn, tport->wwnn);
> +
> +		memcpy(&rjts_rsp, &fnic_els_rjt, sizeof(struct fc_els_reject_s));
> +
> +		rjts_rsp.reason_code = 0x03;	/*  logical error */
> +		rjts_rsp.reason_expl = 0x1E;	/*  N_port login required */
> +		rjts_rsp.vendor_specific = 0x0;
> +		FNIC_SET_S_ID((&rjts_rsp.fchdr), fchdr->did);
> +		FNIC_SET_D_ID((&rjts_rsp.fchdr), fchdr->sid);
> +		oxid = FNIC_GET_OX_ID(fchdr);
> +		FNIC_SET_OX_ID((&rjts_rsp.fchdr), oxid);
> +		FNIC_SET_RX_ID((&rjts_rsp.fchdr), FNIC_ADISC_RESP_OXID);
> +		fnic_send_fcoe_frame(iport, &rjts_rsp,
> +							 sizeof(struct fc_els_reject_s));
> +		return;
> +	}
> +	memset(&adisc_acc.fchdr, 0, sizeof(struct fc_hdr_s));
> +	FNIC_SET_S_ID((&adisc_acc.fchdr), fchdr->did);
> +	FNIC_SET_D_ID((&adisc_acc.fchdr), fchdr->sid);
> +	adisc_acc.fchdr.f_ctl = FNIC_ELS_REP_FCTL;
> +	adisc_acc.fchdr.r_ctl = 0x23;
> +	adisc_acc.fchdr.type = 0x01;
> +	oxid = FNIC_GET_OX_ID(fchdr);
> +	FNIC_SET_OX_ID((&adisc_acc.fchdr), oxid);
> +	FNIC_SET_RX_ID((&adisc_acc.fchdr), FNIC_ADISC_RESP_OXID);
> +	adisc_acc.command = FC_LS_ACC;
> +
> +	FNIC_SET_NPORT_NAME(adisc_acc, iport->wwpn);
> +	FNIC_SET_NODE_NAME(adisc_acc, iport->wwnn);
> +	memcpy(adisc_acc.fcid, fchdr->did, 3);
> +	fnic_send_fcoe_frame(iport, &adisc_acc,
> +						 sizeof(struct fc_els_adisc_ls_acc_s));

Indentation again.

> +}
> +
>   /*
>    * Performs a validation for all FCOE frames and return the frame type
>    */
> @@ -2954,6 +3489,31 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
>   		} else
>   			fdls_process_tgt_abts_rsp(iport, fchdr);
>   		break;
> +	case FNIC_BLS_ABTS_REQ:
> +		fdls_process_abts_req(iport, fchdr);
> +		break;
> +	case FNIC_ELS_UNSUPPORTED_REQ:
> +		fdls_process_unsupported_els_req(iport, fchdr);
> +		break;
> +	case FNIC_ELS_PLOGI_REQ:
> +		fdls_process_plogi_req(iport, fchdr);
> +		break;
> +	case FNIC_ELS_RSCN_REQ:
> +		fdls_process_rscn(iport, fchdr);
> +		break;
> +	case FNIC_ELS_LOGO_REQ:
> +		fdls_process_logo_req(iport, fchdr);
> +		break;
> +	case FNIC_ELS_RRQ:
> +	case FNIC_ELS_ECHO_REQ:
> +		fdls_process_els_req(iport, fchdr, len);
> +		break;
> +	case FNIC_ELS_ADISC:
> +		fdls_process_adisc_req(iport, fchdr);
> +		break;
> +	case FNIC_ELS_RLS:
> +		fdls_process_rls_req(iport, fchdr);
> +		break;
>   	default:
>   		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
>   			 "Received unknown FCoE frame of len: %d. Dropping frame", len);

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

