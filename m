Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0858C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 00:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9808D20781
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 00:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgGAAuA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 20:50:00 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50713 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725805AbgGAAt7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 20:49:59 -0400
Received: (qmail 473515 invoked by uid 1000); 30 Jun 2020 20:49:58 -0400
Date:   Tue, 30 Jun 2020 20:49:58 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200701004958.GA473187@rowland.harvard.edu>
References: <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
 <c19f1938-ae47-2357-669d-5b4021aec154@puri.sm>
 <20200629161536.GA405175@rowland.harvard.edu>
 <5231c57d-3f4e-1853-d4d5-cf7f04a32246@acm.org>
 <20200630180255.GA459638@rowland.harvard.edu>
 <1804723c-4aaf-a820-d3ef-e70125017cad@acm.org>
 <20200630193802.GA463609@rowland.harvard.edu>
 <f17e9ebe-fc75-fb51-cc9b-851fa219f31b@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17e9ebe-fc75-fb51-cc9b-851fa219f31b@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 30, 2020 at 04:31:58PM -0700, Bart Van Assche wrote:
> On 2020-06-30 12:38, Alan Stern wrote:
> > Assume that BLK_MQ_REQ_PREEMPT is set in flags.  Then where exactly 
> > does blk_queue_enter(q, flags) call blk_pm_request_resume(q)?
> 
> Please take a look at how the *current* implementation of runtime power
> management works. Your question is relevant for the old implementation
> of runtime power management but not for the current implementation.

What do you mean by "current"?  I have been looking at the implementation 
in 5.8-rc3 from Linus's tree.  Should I look somewhere else?

Alan Stern
