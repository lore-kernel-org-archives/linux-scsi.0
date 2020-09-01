Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BB6C433E7
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9306B206FA
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 14:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgIAOue (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:50:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47111 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728657AbgIAOuB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 10:50:01 -0400
Received: (qmail 588034 invoked by uid 1000); 1 Sep 2020 10:50:00 -0400
Date:   Tue, 1 Sep 2020 10:50:00 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH RFC 6/6] block, scsi, ide: Only submit power management
 requests in state RPM_SUSPENDED
Message-ID: <20200901145000.GB587030@rowland.harvard.edu>
References: <20200831025357.32700-1-bvanassche@acm.org>
 <20200831025357.32700-7-bvanassche@acm.org>
 <20200831182526.GA558270@rowland.harvard.edu>
 <e84a8098-0c5f-93fb-9055-292104cb2483@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e84a8098-0c5f-93fb-9055-292104cb2483@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 31, 2020 at 10:00:31PM -0700, Bart Van Assche wrote:
> Hi Alan,
> 
> Thanks for having taken a look at this patch. Do you perhaps plan to
> review the other patches in this series too?

I'll look over them, but I don't know enough about the block and IDE 
subsystems to do a competent review.

Alan Stern
