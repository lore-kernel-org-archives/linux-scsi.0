Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6308F279335;
	Thu, 25 Sep 2025 08:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.3.219.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758790384; cv=none; b=Gz+y9fMjPj1ENO5eAPHsmkhe7mfr/sfcPUWZK/UruijKnh9lWa2aADyWbcIFgqhL1zGXLwcyt1Ig15rOZXO4gZcP5J91R2lu1vkFY2vvxBwoeudMJZiNjbOGPKFWIBe9CLoNDD+GN6zvc+Wjw5i1zn/3sHeKxIDoVSF4wkObJ5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758790384; c=relaxed/simple;
	bh=p3JXLkgAN8M27rkKUlEcf1dzuTbajEVNJrjYoMutG14=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rU3eaBvcgpT1qgw/55CfKH4yquqWEM9zwqH0I92nQB5aMr9E9MKyhfAtBmNZpIJeQD2C4+M0qCoLVBPHsoAD1R0C+2w9ju6EPu8p7ucVL6WAhX3cNzCmhIZRoNe1ZTQf5gkfWQIEk2Zjxl5mamRniGgHY82DZ33GRCWREJxCSxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=x3B38m0n; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=FsJy8qza; arc=none smtp.client-ip=195.3.219.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="x3B38m0n";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="FsJy8qza"
Received: from mta-01.yadro.com (localhost [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id 1BEE32000A;
	Thu, 25 Sep 2025 11:43:00 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com 1BEE32000A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1758789780; bh=yGskPw4jc8NcIxvf1AVaZ7YVFk2jPFctLc82/SqLpJs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=x3B38m0n6dGvT1qRljmv2EeFi8qxPkWmLmk35XsXLLbLvn2KSKTNsXgqdkC+yEsWY
	 jFR9Vxdi8xWzU8Dxf9p/hQU2FMX/5qZz01FmVyJsC83wJmorMs5taQ8gRdldUav3TE
	 3vtjJWnOkkIUlgJz5IglSSC2NqQTbcRLB1G0uBLZdbZbMrhJnRf5d0UBZBze26dUQp
	 ngmavUYirR2K1xw3b7lsqcMwjiJGj0pCiR/wjL+M2SAkcvOM9alp42dvNVUEn9C7s/
	 GJOmA2lNtCsFlkGF6t4kxtqpjo7lCr4YHj5G/mCRFdz4x8cQX1/82+VoGc+IceqN+x
	 KnY0GMrz47pbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1758789780; bh=yGskPw4jc8NcIxvf1AVaZ7YVFk2jPFctLc82/SqLpJs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=FsJy8qza1z1GesN/J/OzlA9uovpDUd+wJHPb5X/RvWhz9Xd6KsgXXm6nGgYp5huCN
	 9KWLU8DhtqD3TwqG+7Phhsrc+pWa+epVB/29RJeLWxPQb5Ss8l++h3vUFtOnWDso2l
	 o60hXLPYohV+uWghreymlHqBTouquCdGxkdUp7lPOAwAud1eXhKnuS/KRXvW3qOJk8
	 BchvDJF8MZvMN91kdpzS1ani/Y3xqcYTSnQm6z+H1d+cjsdFY2CpYHZYKQGNMZii9n
	 Y9AP0yfylpZu7jWTUqo5Vc6oAXiprkb47c5TT1HWhynPfKTMIBrA6DJYUBKWPuQgOT
	 LuWN7ov8RE6hg==
Received: from RTM-EXCH-01.corp.yadro.com (unknown [10.34.9.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Thu, 25 Sep 2025 11:42:53 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (10.34.9.214) by
 RTM-EXCH-01.corp.yadro.com (10.34.9.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 25 Sep 2025 11:42:53 +0300
Received: from yadro.com (172.17.34.51) by T-EXCH-12.corp.yadro.com
 (10.34.9.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 25 Sep
 2025 11:42:53 +0300
Date: Thu, 25 Sep 2025 11:42:52 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Tony Battersby <tonyb@cybernetics.com>
CC: Nilesh Javali <njavali@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <scst-devel@lists.sourceforge.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [DMARC Error]Re: [PATCH 08/15] scsi: qla2xxx: fix oops during
 cmd abort
Message-ID: <20250925084252.GA821@yadro.com>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <80974286-f8ac-4eff-9439-c05fe38716b1@cybernetics.com>
 <20250911142135.GA624@yadro.com>
 <e8cc07cf-9bd1-41a4-bd46-44e18179154b@cybernetics.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e8cc07cf-9bd1-41a4-bd46-44e18179154b@cybernetics.com>
X-ClientProxiedBy: RTM-EXCH-03.corp.yadro.com (10.34.9.203) To
 T-EXCH-12.corp.yadro.com (10.34.9.214)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/25 06:22:00 #27853652
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Wed, Sep 24, 2025 at 03:41:32PM -0400, Tony Battersby wrote:
> 
> On 9/11/25 10:21, Dmitry Bogdanov wrote:
> > On Mon, Sep 08, 2025 at 02:58:06PM -0400, Tony Battersby wrote:
> >> (target mode)
> >>
> >> There is a race between the following:
> >>
> >> CPU 1:
> >> scst_hw_pending_work_fn() ->
> >> sqa_on_hw_pending_cmd_timeout() ->
> >> qlt_abort_cmd() ->
> >> qlt_unmap_sg()
> >>
> >> CPU 2:
> >> qla_do_work() ->
> >> qla24xx_process_response_queue() ->
> >> qlt_do_ctio_completion() ->
> >> qlt_unmap_sg()
> >>
> >> Two CPUs calling qlt_unmap_sg() on the same cmd at the same time
> >> results in an oops:
> >>
> >> dma_unmap_sg_attrs()
> >>         BUG_ON(!valid_dma_direction(dir));
> >>
> >> This race is more likely to happen because qlt_abort_cmd() may cause the
> >> hardware to send a CTIO.
> >>
> >> The solution is to lock cmd->qpair->qp_lock_ptr when aborting a command.
> >> This makes it possible to check the cmd state and make decisions about
> >> what to do without racing with the CTIO handler and other code.
> >>
> >> - Lock cmd->qpair->qp_lock_ptr when aborting a cmd.
> >> - Eliminate cmd->cmd_lock and change cmd->aborted back to a bitfield
> >>   since it is now protected by qp_lock_ptr just like all the other
> >>   flags.
> >> - Add another command state QLA_TGT_STATE_DONE to avoid any possible
> >>   races between qlt_abort_cmd() and tgt_ops->free_cmd().
> >> - Add the cmd->sent_term_exchg flag to indicate if
> >>   qlt_send_term_exchange() has already been called.
> >> - For SCST (scst_hw_pending_work_fn()), export qlt_send_term_exchange()
> >>   and qlt_unmap_sg() so that they can be called directly instead of
> >>   trying to make qlt_abort_cmd() work for both HW timeout and TMR abort.
> >> - Add TRC_CTIO_IGNORED for scst_hw_pending_work_fn().
> >>
> >> Fixes: 26f9ce53817a ("scsi: qla2xxx: Fix missed DMA unmap for aborted commands")
> > You are trying to fix that commit using its approach, but actually that
> > approach is the root cause itself. It is not ok to unmap dma while that
> > memory is owned by HW.
> >
> > We use this patch 4 years already instead of 26f9ce53817a and never
> > faced with such crashes.
> >
> >
> > From: Dmitry Bogdanov <d.bogdanov@yadro.com>
> > Date: Wed, 20 Oct 2021 15:57:31 +0300
> > Subject: [PATCH] scsi: qla2xxx: clear cmds after chip reset
> >
> > Commands sent to FW, after chip reset got stuck and never freed as FW is
> > not going to response to them anymore.
> >
> > This patch partially reverts aefed3e5548f at __qla2x00_abort_all_cmds.
> >
> > Fixes: aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling and host reset handling")
> > Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> 
> Hey Dmitry, I want to pick up your patch and add it to my v2 patchset,
> but I have made a few changes to it.  Do I have your permission to add
> your "Co-developed-by" and "Signed-off-by" tags to the patch below?
> (Never did this before, I think I need to ask permission.)

Yes, of course, feel free to use it. Signed-off-by is enough I think.

 
> Compared to your patch, I changed "if (cmd->se_cmd.t_state ==
> TRANSPORT_WRITE_PENDING)" to "if (cmd->state ==
> QLA_TGT_STATE_NEED_DATA)" (which is the way it was originally) to work
> better with SCST and added the revert of 26f9ce53817a.

Yes, that is more correct.
 
> I will reply to this message with the two updated v2 patches that follow
> your suggestions and remove the dangerous code that you objected to.  If
> you approve of them, then I will submit the entire v2 patchset, since
> some of the other patches needed to be rebased.
>


