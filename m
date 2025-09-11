Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCC9326D5C;
	Thu, 11 Sep 2025 14:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757600885; cv=none; b=LQmmgt5CPRCEmRGGYDfjzTzHn9Od3K5zUNhhfv1PeqJviW7budOMS4LA9vJSPMJnwrZOohquDd+DIy9dvI0zHGGkOz1ZRlmPhtWrB5/OoB3q2qFIQCFLCPE1sQi0UMmlfV5IxpOAqMxpRLkz6DDkh/4pADHlnBHrJxUwPCJIsPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757600885; c=relaxed/simple;
	bh=/YuSG2s1hC7MzUKU2whXxfTmCULaNkmBnNvdUXiSLZg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYESLoHUY6MgL6o7AYSlYl3Kt/rPfdOMDkIYBPg7UWUqaAsDY4w7cfsDThk0jOQoZA7mF84+pczBoBWKO2Al9yIhzqdXMYADnZYc977q16EfxBbf56h0XdOftRgp3XJ40QrCzmyULL3k0B5fUQ+S+cDLA0GCA/LRIRw6kkF9NPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=InRPP0dU; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=B1fVOxj1; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="InRPP0dU";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="B1fVOxj1"
Received: from mta-03.yadro.com (localhost [127.0.0.1])
	by mta-03.yadro.com (Postfix) with ESMTP id B56CEE001F;
	Thu, 11 Sep 2025 17:21:42 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com B56CEE001F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1757600502; bh=zX0dPaVqRWFaIrl/bp1YLPUG+qpJzDQFCc1ugpDhsgU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=InRPP0dULowkwabqeVXy5WiUbvPYlcC7YEu8RJ4Y3y4/0puer937unIclivJSmje4
	 I4QSlDm2Oq3RAth5HFrh5mmk+BHlYahrqWKWc1NN+3yzjcDVTw65RkT2KDBdX3WKUT
	 I4rKznvpQZ0mg/G0z3TBAFlJlQkkSkprbTdojmhuT5hKPU3ZzHXTbJ7APWCC6uh+I8
	 rDiVRjAnTtggy65pJcjygY20toKKGDxpIVNOJg79p+2U2JyMks94UyZ33ykCgraV33
	 /MzXz0Dmip/fhXdSjTZUQaiCzp+mq8n5L9sFZqflELLVkg4U81OAiZbn99VLvneOa3
	 9+ty6lIkRrpsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1757600502; bh=zX0dPaVqRWFaIrl/bp1YLPUG+qpJzDQFCc1ugpDhsgU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=B1fVOxj1eUVR7FqxNU9WCLO8mWeJwyq5iY/GkToIQfUOdPXspRylkiinTzX1Ut7Rh
	 ryIYsh+yUHYgHk/HlztG2dFrM7XbVmF2xSk56M4CgSLAkBLIkLNEIZhUfwReI+vSYw
	 5srPmM828FDF/3j20AdTzswvpy38lAblQu4O92fajcT9H0ma3iKC3VBdk2vqaZLHqN
	 11GdcEvEsy3vpT1696WzPQdO1KHjNJSA/bIKkD2H7yB6hGiExDjj/scqa2NL/9hrsI
	 uuRxOeacT0E46FBvX6nq0ze3HOnjO1X5YNRPnDIB2RlKlbGHuQKmVYDo7k/lGs3G5H
	 nrkxaxBrXOg6A==
Received: from T-EXCH-10.corp.yadro.com (T-EXCH-10.corp.yadro.com [10.34.9.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-03.yadro.com (Postfix) with ESMTPS;
	Thu, 11 Sep 2025 17:21:36 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (10.34.9.214) by
 T-EXCH-10.corp.yadro.com (10.34.9.212) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Thu, 11 Sep 2025 17:21:36 +0300
Received: from yadro.com (172.17.34.56) by T-EXCH-12.corp.yadro.com
 (10.34.9.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 11 Sep
 2025 17:21:36 +0300
Date: Thu, 11 Sep 2025 17:21:35 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Tony Battersby <tonyb@cybernetics.com>
CC: Nilesh Javali <njavali@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <scst-devel@lists.sourceforge.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/15] scsi: qla2xxx: fix oops during cmd abort
Message-ID: <20250911142135.GA624@yadro.com>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <80974286-f8ac-4eff-9439-c05fe38716b1@cybernetics.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <80974286-f8ac-4eff-9439-c05fe38716b1@cybernetics.com>
X-ClientProxiedBy: RTM-EXCH-04.corp.yadro.com (10.34.9.204) To
 T-EXCH-12.corp.yadro.com (10.34.9.214)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/11 12:59:00 #27808694
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Mon, Sep 08, 2025 at 02:58:06PM -0400, Tony Battersby wrote:
> 
> (target mode)
> 
> There is a race between the following:
> 
> CPU 1:
> scst_hw_pending_work_fn() ->
> sqa_on_hw_pending_cmd_timeout() ->
> qlt_abort_cmd() ->
> qlt_unmap_sg()
> 
> CPU 2:
> qla_do_work() ->
> qla24xx_process_response_queue() ->
> qlt_do_ctio_completion() ->
> qlt_unmap_sg()
> 
> Two CPUs calling qlt_unmap_sg() on the same cmd at the same time
> results in an oops:
> 
> dma_unmap_sg_attrs()
>         BUG_ON(!valid_dma_direction(dir));
> 
> This race is more likely to happen because qlt_abort_cmd() may cause the
> hardware to send a CTIO.
> 
> The solution is to lock cmd->qpair->qp_lock_ptr when aborting a command.
> This makes it possible to check the cmd state and make decisions about
> what to do without racing with the CTIO handler and other code.
> 
> - Lock cmd->qpair->qp_lock_ptr when aborting a cmd.
> - Eliminate cmd->cmd_lock and change cmd->aborted back to a bitfield
>   since it is now protected by qp_lock_ptr just like all the other
>   flags.
> - Add another command state QLA_TGT_STATE_DONE to avoid any possible
>   races between qlt_abort_cmd() and tgt_ops->free_cmd().
> - Add the cmd->sent_term_exchg flag to indicate if
>   qlt_send_term_exchange() has already been called.
> - For SCST (scst_hw_pending_work_fn()), export qlt_send_term_exchange()
>   and qlt_unmap_sg() so that they can be called directly instead of
>   trying to make qlt_abort_cmd() work for both HW timeout and TMR abort.
> - Add TRC_CTIO_IGNORED for scst_hw_pending_work_fn().
> 
> Fixes: 26f9ce53817a ("scsi: qla2xxx: Fix missed DMA unmap for aborted commands")

You are trying to fix that commit using its approach, but actually that
approach is the root cause itself. It is not ok to unmap dma while that
memory is owned by HW.

We use this patch 4 years already instead of 26f9ce53817a and never
faced with such crashes.


From: Dmitry Bogdanov <d.bogdanov@yadro.com>
Date: Wed, 20 Oct 2021 15:57:31 +0300
Subject: [PATCH] scsi: qla2xxx: clear cmds after chip reset

Commands sent to FW, after chip reset got stuck and never freed as FW is
not going to response to them anymore.

This patch partially reverts aefed3e5548f at __qla2x00_abort_all_cmds.

Fixes: aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling and host reset handling")
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_os.c     | 20 ++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 drivers/scsi/qla2xxx/qla_target.h |  1 +
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 407047e8b42b..04b0d3eb97e7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1809,10 +1809,26 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 					continue;
 				}
 				cmd = (struct qla_tgt_cmd *)sp;
-				cmd->aborted = 1;
+
+				if (cmd->sg_mapped)
+					qlt_unmap_sg(vha, cmd);
+
+				if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING) {
+					cmd->aborted = 1;
+					cmd->write_data_transferred = 0;
+					cmd->state = QLA_TGT_STATE_DATA_IN;
+					ha->tgt.tgt_ops->handle_data(cmd);
+				} else {
+					ha->tgt.tgt_ops->free_cmd(cmd);
+				}
 				break;
 			case TYPE_TGT_TMCMD:
-				/* Skip task management functions. */
+				/*
+				 * Currently, only ABTS response gets on the
+				 * outstanding_cmds[]
+				 */
+				ha->tgt.tgt_ops->free_mcmd(
+					(struct qla_tgt_mgmt_cmd *) sp);
 				break;
 			default:
 				break;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8dfd13af48ea..c3b1a1426253 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2463,7 +2463,7 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 	return -1;
 }
 
-static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
+void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 {
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 10e5e6c8087d..76e80208d731 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1050,6 +1050,7 @@ extern int qlt_abort_cmd(struct qla_tgt_cmd *);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
+extern void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd);
 extern void qlt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *);
 extern void qlt_enable_vha(struct scsi_qla_host *);
 extern void qlt_vport_create(struct scsi_qla_host *, struct qla_hw_data *);
-- 
2.25.1






