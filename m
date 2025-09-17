Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3F6284888;
	Wed, 17 Sep 2025 13:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114419; cv=none; b=cukG5K6pIWra0oaVkDV0qjHOietzzl4UejhoWPS5I81i1rwG7tm2hJPJjXThKUUKE7Cs0l60I+rfZo//pumhuLDcIL5G46Zb/VpBsEaIonfh9Jct5H10Ha4BPZ9HosQy/YuIUi+g2Tnl9MWu0poimFix+FgIIKCMbx6PmgPEdYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114419; c=relaxed/simple;
	bh=MwBWGa2S0P3kRJgvfUWuRk0Yj0zrZCwIBy9hAoe3f4k=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=enrrlsZj9dtNpfkaUn6+bmlltm0/9igVIF7v4xKwVwm43MVZLX1IPIutP0znccFoyjq8eWaxNbT9rRPg6/9lAaH5R8Zwii2S89lMDT+KKINZiSPkelDsASm6sbYp6WVvKpUgUlJ+fOIVfAE5LlKge/hqITbT/jOCDNIw2FkxaYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=tJzO2aJ9; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=vyP0Gn5D; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="tJzO2aJ9";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="vyP0Gn5D"
Received: from mta-03.yadro.com (localhost [127.0.0.1])
	by mta-03.yadro.com (Postfix) with ESMTP id A7710E0004;
	Wed, 17 Sep 2025 16:06:47 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com A7710E0004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1758114407; bh=33oRIV5FYzbMz66ojkQmUacWCbkqDEAECMBSMTov/l4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=tJzO2aJ9YKjYwFrndumE9AW+urX3Xb7ddZlN/d0ecpsvGSF1c6OWcSwQg0jgHoYqG
	 wo6MRncl5nHsfh78O/4X3Mm2Fij+rkZVnWHNtddhfxbQ5EMAhlyySbkYpMv1mbyCCH
	 ycNJSJE3RRZl3wXb9zhocUOUH+pLrdg7+YYU7rN3KPGq9pZtZvcrMVWS/n6ROTyonC
	 ndkOrCbOWy6X28wZq95ohnKFJqxnKmohjER1RgUxcoBP1BTNjg5VzeA7ZoqmljMBy/
	 CADIBKZAOPIDWgA3JiX61WueW8NyUG+mfgxes3i9ncm23b6fUqdUUd6e5htyXNjXqS
	 40VhWsSThTy/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1758114407; bh=33oRIV5FYzbMz66ojkQmUacWCbkqDEAECMBSMTov/l4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=vyP0Gn5D2itO35kMggc3Vn9XP6iP6KQ11BkLUicXY8SI8Ru3yxnKK7MLn6+V13A9k
	 IFLusWZw6kpXC0Gs3FUZOFw5v/67nvqDZYIeAmaJA/SlM/lTC19SP9NIg9gusSp5aJ
	 aH53xk7/bjTdtQ6vjKJiyqnp2Bkn4eCIl/mRU2ydlCq9KcrYNMrmIC98nx2pOrNapM
	 lApGgUykreJSYJj0RYUkWxoEmBTT/8xEhUKSUkIzwBOoN28H/1jhY1/aNgvddS6XXm
	 H/TnbTblcuNiwQX4ManHafvwH6KCE7iqXZc6C8EYcyn6g3A31lSHMhMgDkIzX7fyba
	 DjfIkFf5/kSPg==
Received: from T-EXCH-07.corp.yadro.com (T-EXCH-07.corp.yadro.com [10.34.9.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-03.yadro.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 16:06:42 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (10.34.9.214) by
 T-EXCH-07.corp.yadro.com (10.34.9.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 17 Sep 2025 16:06:42 +0300
Received: from yadro.com (172.17.34.51) by T-EXCH-12.corp.yadro.com
 (10.34.9.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 17 Sep
 2025 16:06:41 +0300
Date: Wed, 17 Sep 2025 16:06:41 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Tony Battersby <tonyb@cybernetics.com>
CC: Nilesh Javali <njavali@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <scst-devel@lists.sourceforge.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [DMARC Error]Re: [PATCH 10/15] scsi: qla2xxx: fix TMR failure
 handling
Message-ID: <20250917130641.GD624@yadro.com>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <f7f93110-bd53-4ebc-9aed-abe5de82028d@cybernetics.com>
 <20250912143615.GB624@yadro.com>
 <526d0d1b-79f1-47fd-bc44-6727898f381c@cybernetics.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <526d0d1b-79f1-47fd-bc44-6727898f381c@cybernetics.com>
X-ClientProxiedBy: RTM-EXCH-04.corp.yadro.com (10.34.9.204) To
 T-EXCH-12.corp.yadro.com (10.34.9.214)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/17 09:42:00 #27826690
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Tue, Sep 16, 2025 at 12:04:11PM -0400, Tony Battersby wrote:
> 
> On 9/12/25 10:36, Dmitry Bogdanov wrote:
> > On Mon, Sep 08, 2025 at 03:02:49PM -0400, Tony Battersby wrote:
> >> If handle_tmr() fails (e.g. -ENOMEM):
> >> - qlt_send_busy() makes no sense because it sends a SCSI command
> >>   response instead of a TMR response.
> > There is not only -ENOMEM can be returned by handle_tmr.
> 
> Indeed.  I will remove mention of -ENOMEM since it isn't really relevant.
> 
> >> +               mcmd->fc_tm_rsp = FCP_TMF_REJECTED;
> >>
> > FCP_TMF_REJECTED means that this TMF is not supported, FCP_TMF_FAILED is
> > more appretiate here.
> 
> I will make that change.
> 
> >> - Calling mempool_free() directly can lead to memory-use-after-free.
> > No, it is a API contract between modules. If handle_tmr returned an error,
> > then the caller of handle_tmr is responsible to make a cleanup.
> > Otherwise, target module (tcm_qla2xxx) is responsible. The same rule is
> > for handle_cmd.
> >> +               qlt_xmit_tm_rsp(mcmd);
> > qlt_xmit_tm_rsp does not free mcmd for TMF ABORT. So you introduce a memleak.
> 
> I just tested it, and there is no memleak.  qlt_build_abts_resp_iocb()
> sets req->outstanding_cmds[h] to mcmd, and then
> qlt_handle_abts_completion() calls ->free_mcmd after getting a response
> from the ISP.

ha->tgt.tgt_ops->free_mcmd(mcmd) can be called when mcmd was handled by the
target core, i.e. handle_tmr() returned 0. LIO's tcm_qla2xxx_free_mcmd calls
target core function transport_generic_free_cmd to clear core's command
object. Which in turns calls eventually mempool_free in qla2xxx.
But when handle_tmr returned an error then there is no that core's
command object and LIO will not free the mcmd. That is how a memleak
will happen.

> The original code had a memory-use-after-free by calling
> qlt_build_abts_resp_iocb() and then mempool_free(), and
> then qlt_handle_abts_completion() used the freed mcmd.  I can reword the
> commit message to make this clearer.

BTW, the easyest way to just to fix that use-after-free is to use
qlt_24xx_send_abts_resp instead of qlt_build_abts_resp_iocb like in other
places, where there is no mcmd and there is no need to wait the
completion from FW.

We use this patch:


From: Dmitry Bogdanov <d.bogdanov@yadro.com>
Date: Thu, 27 Apr 2023 15:41:55 +0300
Subject: [PATCH] scsi: qla2xxx: fix use-after-free on ABTS_RESP sending

If an abort was rejected by LIO Core qla2xxx sends ABTS_RESP with rejected
status. But it does not save mcmd pointer which is freed right after sending
the response to FW. It leads to use-after-free at the completion from FW.

Use a correct function to send ABTS_RESP when the abort is rejected by LIO Core.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b9d816b8341e..43eafdc765a3 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2162,7 +2162,9 @@ static void qlt_do_tmr_work(struct work_struct *work)
 		switch (mcmd->tmr_func) {
 		case QLA_TGT_ABTS:
 			mcmd->fc_tm_rsp = FCP_TMF_REJECTED;
-			qlt_build_abts_resp_iocb(mcmd);
+			qlt_24xx_send_abts_resp(mcmd->qpair,
+						&mcmd->orig_iocb.abts,
+						FCP_TMF_REJECTED, false);
 			break;
 		case QLA_TGT_LUN_RESET:
 		case QLA_TGT_CLEAR_TS:
-- 
2.25.1





BR,
 Dmitry


