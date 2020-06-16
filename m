Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F4CC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 09:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 405822074D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 09:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgFPJm1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 05:42:27 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44190 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbgFPJm0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 05:42:26 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id DC1CE274AC;
        Tue, 16 Jun 2020 05:42:21 -0400 (EDT)
Date:   Tue, 16 Jun 2020 19:42:23 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Chris Boot <bootc@boo.tc>
cc:     linuxppc-dev@lists.ozlabs.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Chuhong Yuan <hslester96@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
In-Reply-To: <8da0c285-d707-a3d2-063e-472af5cc560f@boo.tc>
Message-ID: <alpine.LNX.2.22.394.2006161929380.8@nippy.intranet>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com> <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet> <7ad14946-5c25-fc49-1e48-72d37a607832@boo.tc> <alpine.LNX.2.22.394.2006150919110.8@nippy.intranet>
 <8da0c285-d707-a3d2-063e-472af5cc560f@boo.tc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 15 Jun 2020, Chris Boot wrote:

> On 15/06/2020 00:28, Finn Thain wrote:
> > On Sun, 14 Jun 2020, Chris Boot wrote:
> > 
> >> I expect that if someone finds this useful it can stick around (but 
> >> that's not my call).
> > 
> > Who's call is that? If the patch had said "From: Martin K. Petersen" 
> > and "This driver is being removed because it has the following 
> > defects..." that would be some indication of a good-faith willingness 
> > to accept users as developers in the spirit of the GPL, which is what 
> > you seem to be alluding to (?).
> 
> If you're asking me, I'd say it was martin's call:
> 
> > SCSI TARGET SUBSYSTEM                                                          
> > M:      "Martin K. Petersen" <martin.petersen@oracle.com>                      
> [...]
> > F:      drivers/target/                                                        
> > F:      include/target/                                                        
> 

The question I asked you was intended to make you think. I wasn't asking 
you to search MAINTAINERS for "drivers/target" (I had already done so).

Chris, you can find my name in that file too. That's because I see my role 
as custodian of that particular code. That code lives in the kernel.org 
tree because others put it there and because users find it useful -- not 
merely because it happens to please the official glorious MAINTAINER of 
said code.

If you would ask, "who's call is it to delete drivers/nubus? or 
drivers/scsi/NCR5380.c?" my answer is, I have no idea.

> >> I just don't have the time or inclination or hardware to be able to 
> >> maintain it anymore, so someone else would have to pick it up.
> >>
> > 
> > Which is why most drivers get orphaned, right?
> 
> Sure, but that's not what Martin asked me to do, hence this patch.
> 

Martin said, "I'd appreciate a patch to remove it"

And Bart said, "do you want to keep this driver in the kernel tree?"

AFAICT both comments are quite ambiguous. I don't see an actionable 
request, just an expression of interest from people doing their jobs.

Note well: there is no pay check associated with having a MAINTAINERS file 
entry.
