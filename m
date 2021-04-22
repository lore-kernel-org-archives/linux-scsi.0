Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C14FC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 09:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCDC961422
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 09:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbhDVJhZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 05:37:25 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44202 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhDVJhY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 05:37:24 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 74B552AB7E;
        Thu, 22 Apr 2021 05:36:47 -0400 (EDT)
Date:   Thu, 22 Apr 2021 19:36:48 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Hannes Reinecke <hare@suse.de>
cc:     dgilbert@interlog.com, Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 14/42] scsi: add scsi_result_is_good()
In-Reply-To: <d74a6a9a-6187-8847-7364-0bf7999b3379@suse.de>
Message-ID: <c478119a-2027-f983-9bc-3cefff64896a@nippy.intranet>
References: <20210421174749.11221-1-hare@suse.de> <20210421174749.11221-15-hare@suse.de> <b510135a-3dca-e6e4-bdbb-f1ff3817cc29@acm.org> <51b16b13-d4e3-f0e4-718e-357d04ed958f@interlog.com> <d74a6a9a-6187-8847-7364-0bf7999b3379@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 22 Apr 2021, Hannes Reinecke wrote:

> That would be a change in behaviour. Current code doesn't check for 
> CONDITION_MET, so this change shouldn't do it, neither. Idea was that 
> this patchset shouldn't change the current behaviour.
> 
> While your argument might be valid, it definitely is a different story 
> and would need to be address with a different patchset.
> 

As long as you're avoiding behavioural changes, you may need to drop the 
status_byte() change in patch 15/42 from this particular patch set -- 
unless it can be shown (inferred somehow) that drives never set that bit.
