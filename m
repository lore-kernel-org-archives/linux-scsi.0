Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625BEC433E2
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 16:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D06D20702
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 16:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgGFQlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 12:41:36 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36351 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1729550AbgGFQlg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 12:41:36 -0400
Received: (qmail 706817 invoked by uid 1000); 6 Jul 2020 12:41:35 -0400
Date:   Mon, 6 Jul 2020 12:41:35 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200706164135.GE704149@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701004958.GA473187@rowland.harvard.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 30, 2020 at 20:49:58PM -0400, Alan Stern wrote:
> On Tue, Jun 30, 2020 at 04:31:58PM -0700, Bart Van Assche wrote:
> > On 2020-06-30 12:38, Alan Stern wrote:
> > > Assume that BLK_MQ_REQ_PREEMPT is set in flags.  Then where exactly 
> > > does blk_queue_enter(q, flags) call blk_pm_request_resume(q)?
> > 
> > Please take a look at how the *current* implementation of runtime power
> > management works. Your question is relevant for the old implementation
> > of runtime power management but not for the current implementation.
> 
> What do you mean by "current"?  I have been looking at the implementation 
> in 5.8-rc3 from Linus's tree.  Should I look somewhere else?

Any reply to this, or further concerns about the proposed patch?

I'd like to fix up this API, and it appears that you are the only
person to have worked on it significantly in the last two years.

Alan Stern
