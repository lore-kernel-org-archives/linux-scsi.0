Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334612FD7BB;
	Fri, 12 Sep 2025 14:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757687795; cv=none; b=Nn/jmXC5XAEJPamRRCgNSEuFJIulXCZfWRCzKwIcnbgZYNM2BAStLC2iShyRAkcInyyibfM3q30RjHWG1jq1hOk2Pp1IKtVtNbfAJgVY6n++S9tj/wxFImydL3eRBoYZkOk+CtWWH3Kbyc/4PDn7JHaMdNf9/i7UA1MLUpKbAts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757687795; c=relaxed/simple;
	bh=dTwijpqxPuJ5/+Cv765kEWi1w2X5GAUQShLGuMoHk5U=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PygQrv1gKm6XLf9piqimqGNKvlqRqKBprOeuNc2zQlYKywX30cZJfeON/k3xOTrahG7vhs2GIOgghXcSfxO5Yfe9CaSHbwo4mdSNeRT2rDUT4b6FxcdacARGm8J0La+a4T/gdYRIid9J4ePjYd9GUOiOhVnJKaUmusLwIiIRGxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=mbpxPk1l; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=IkcFcszH; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="mbpxPk1l";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="IkcFcszH"
Received: from mta-03.yadro.com (localhost [127.0.0.1])
	by mta-03.yadro.com (Postfix) with ESMTP id 79B4CE0016;
	Fri, 12 Sep 2025 17:36:23 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 79B4CE0016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1757687783; bh=VaM+fruqw2bqW5awJBxikdRTCIjPIaJ9zrDGbC0YTzs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=mbpxPk1lhCAq1UNMeVap9rQQ96TKJ7E5+/htaO+EIKVNKrBzPx1R4iV2Yf6p0HpeG
	 Szv/V2C4W5MGuYMKnUM29uIYoGIEXeqjkA/fTTmpa/BvKopOinl3I/atQNqfQQGhab
	 kyNRn6Mr0JgYa4GLxnm2/J7jClhKf9+uyheb6tD1RWENvJ2wiic43MsGDNdBtcZqQ1
	 U/ZAgnT9I8CRxXARrM22OZ0zPO34lE4T4eJ/YmVVBYthEcTFroFetPr7A5yBjtugVk
	 LjGrlHw6+Wu3XqtEU0lle7gdxNWsYZ4/yEjMnHYdcnAvkpPnk9HeDJTpUmz326pjpw
	 HAT/sOTyl9iKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1757687783; bh=VaM+fruqw2bqW5awJBxikdRTCIjPIaJ9zrDGbC0YTzs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=IkcFcszHP5S54ZgosxBwdliHnbFW8FDuLXP1r6WwgJUXO/h22Bnv04M+6J5Om4/+j
	 1byPQqr25cqdAYY7ZYFf9WCI79AK5r8f2hnt75lJh/21jdeT1ESC13XLPMWa/ANbsq
	 SBjS+r4WA/mgqNqQQp93QarTLMh+Z1XcpbeDvBRw+lxQV+VM9ASlQJA3QurpRntjOj
	 Quo2TPYhQYSzROLdd6+Tgu2uQIElwpZ4KLSLPCJverlnwDra9BkTQQkWsvAktVoa0m
	 zN5L/OZBauJYBiTAsZ+g54sijinlxio9GqAEqHUZxsbPVbLO8UUC3Y7LRn5vlYMbcR
	 1T6ofL3191RrQ==
Received: from T-EXCH-10.corp.yadro.com (T-EXCH-10.corp.yadro.com [10.34.9.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-03.yadro.com (Postfix) with ESMTPS;
	Fri, 12 Sep 2025 17:36:18 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (10.34.9.214) by
 T-EXCH-10.corp.yadro.com (10.34.9.212) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Fri, 12 Sep 2025 17:36:17 +0300
Received: from yadro.com (172.17.34.55) by T-EXCH-12.corp.yadro.com
 (10.34.9.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Fri, 12 Sep
 2025 17:36:17 +0300
Date: Fri, 12 Sep 2025 17:36:15 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Tony Battersby <tonyb@cybernetics.com>
CC: Nilesh Javali <njavali@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <scst-devel@lists.sourceforge.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/15] scsi: qla2xxx: fix TMR failure handling
Message-ID: <20250912143615.GB624@yadro.com>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <f7f93110-bd53-4ebc-9aed-abe5de82028d@cybernetics.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f7f93110-bd53-4ebc-9aed-abe5de82028d@cybernetics.com>
X-ClientProxiedBy: RTM-EXCH-02.corp.yadro.com (10.34.9.202) To
 T-EXCH-12.corp.yadro.com (10.34.9.214)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/12 13:48:00 #27812074
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Mon, Sep 08, 2025 at 03:02:49PM -0400, Tony Battersby wrote:
> 
> (target mode)
> 
> If handle_tmr() fails (e.g. -ENOMEM):
> - qlt_send_busy() makes no sense because it sends a SCSI command
>   response instead of a TMR response.

There is not only -ENOMEM can be returned by handle_tmr.

> - Calling mempool_free() directly can lead to memory-use-after-free.

No, it is a API contract between modules. If handle_tmr returned an error,
then the caller of handle_tmr is responsible to make a cleanup.
Otherwise, target module (tcm_qla2xxx) is responsible. The same rule is
for handle_cmd.

> 
> Instead just reject the TMR and send the TMR response since that code
> path is well-tested.  But be sure to set SCF_SCSI_TMR_CDB in case
> core_tmr_alloc_req() returns -ENOMEM; otherwise the wrong function will
> be called to free the mcmd.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 33 +++++++------------------------
>  1 file changed, 7 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index da010de9ba8a..7c278f92ff3b 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -2005,7 +2005,6 @@ static void qlt_do_tmr_work(struct work_struct *work)
>         struct qla_hw_data *ha = mcmd->vha->hw;
>         int rc;
>         uint32_t tag;
> -       unsigned long flags;
> 
>         switch (mcmd->tmr_func) {
>         case QLA_TGT_ABTS:
> @@ -2020,34 +2019,16 @@ static void qlt_do_tmr_work(struct work_struct *work)
>             mcmd->tmr_func, tag);
> 
>         if (rc != 0) {
> -               spin_lock_irqsave(mcmd->qpair->qp_lock_ptr, flags);
> -               switch (mcmd->tmr_func) {
> -               case QLA_TGT_ABTS:
> -                       mcmd->fc_tm_rsp = FCP_TMF_REJECTED;
> -                       qlt_build_abts_resp_iocb(mcmd);
> -                       break;
> -               case QLA_TGT_LUN_RESET:
> -               case QLA_TGT_CLEAR_TS:
> -               case QLA_TGT_ABORT_TS:
> -               case QLA_TGT_CLEAR_ACA:
> -               case QLA_TGT_TARGET_RESET:
> -                       qlt_send_busy(mcmd->qpair, &mcmd->orig_iocb.atio,
> -                           qla_sam_status);

Sending SCSI status(other octets in FCP_RSP frame) in response to TMF is
against the standard. So, that is the real subject to fix.

> -                       break;
> -
> -               case QLA_TGT_ABORT_ALL:
> -               case QLA_TGT_NEXUS_LOSS_SESS:
> -               case QLA_TGT_NEXUS_LOSS:
> -                       qlt_send_notify_ack(mcmd->qpair,
> -                           &mcmd->orig_iocb.imm_ntfy, 0, 0, 0, 0, 0, 0);
> -                       break;
> -               }
> -               spin_unlock_irqrestore(mcmd->qpair->qp_lock_ptr, flags);
> -
>                 ql_dbg(ql_dbg_tgt_mgt, mcmd->vha, 0xf052,
>                     "qla_target(%d):  tgt_ops->handle_tmr() failed: %d\n",
>                     mcmd->vha->vp_idx, rc);
> -               mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
> +               /*
> +                * SCF_SCSI_TMR_CDB might not have been set on error, but it
> +                * must be set for the mcmd to be freed properly.
> +                */
> +               mcmd->se_cmd.se_cmd_flags |= SCF_SCSI_TMR_CDB;
> +               mcmd->fc_tm_rsp = FCP_TMF_REJECTED;

FCP_TMF_REJECTED means that this TMF is not supported, FCP_TMF_FAILED is
more appretiate here.

> +               qlt_xmit_tm_rsp(mcmd);

qlt_xmit_tm_rsp does not free mcmd for TMF ABORT. So you introduce a memleak.

>         }
>  }
> 
> --
> 2.43.0
> 
> 
> 
