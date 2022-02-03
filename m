Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FE8C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 19:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353832AbiBCTqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiBCTqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 14:46:49 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4191C061714;
        Thu,  3 Feb 2022 11:46:48 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nFi44-00037A-6I; Thu, 03 Feb 2022 20:46:44 +0100
Date:   Thu, 3 Feb 2022 20:46:44 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] scsi: Add scsi_done_direct() for immediate
 completion.
Message-ID: <YfwxJPUFCo5/55yI@flow>
References: <20220201210954.570896-1-sebastian@breakpoint.cc>
 <20220201210954.570896-2-sebastian@breakpoint.cc>
 <c8402f76-7397-77c3-232c-c825c52ea826@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c8402f76-7397-77c3-232c-c825c52ea826@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-02-02 12:49:16 [-0800], Bart Van Assche wrote:
> On 2/1/22 13:09, Sebastian Andrzej Siewior wrote:
> > -void scsi_done(struct scsi_cmnd *cmd)
> > +static bool scsi_done_need_blk_compl(struct scsi_cmnd *cmd)
> 
> I'm not happy about the name of this function. The word "need" in the
> function name suggests that this function does not modify any state.
> However, the body of the function shows that it may complete a SCSI command.
> How about renaming the existing scsi_done() function into
> scsi_done_internal() or so and adding a "bool complete_directly" argument to
> that function?

Let me see what I can do.

> BTW, I only received patch 1/2 but not patch 2/2. Please Cc the linux-scsi
> mailing list for the entire patch series when reposting the patch series.

I did and based on lore's archive it made it to the list:
	https://lore.kernel.org/linux-scsi/20220201210954.570896-1-sebastian@breakpoint.cc/

> Thanks,
> 
> Bart.

Sebastian
