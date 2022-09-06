Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7758ECAAA1
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 21:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiIFVlF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 17:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIFVlD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 17:41:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454BA8671E;
        Tue,  6 Sep 2022 14:41:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D56F06132D;
        Tue,  6 Sep 2022 21:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEFCC433C1;
        Tue,  6 Sep 2022 21:41:01 +0000 (UTC)
Date:   Tue, 6 Sep 2022 17:41:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arun Easi <aeasi@marvell.com>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [EXT] build failure of next-20220906 due to 8bfc149ba24c
 ("scsi: qla2xxx: Enhance driver tracing with separate tunable and more")
Message-ID: <20220906174140.41b46a5f@gandalf.local.home>
In-Reply-To: <e9f5eb5e-3830-d19b-dcb0-05f7a36fcb2d@marvell.com>
References: <YxdZ/9XOsWilvVSd@debian>
        <44fe9ca0-e1d7-1e4f-9fd8-0f48a84dca72@marvell.com>
        <CADVatmMsYk+tgJDASx2uoskLzY=b4m7SNo+3R6SXT=0vEnu+vA@mail.gmail.com>
        <20220906170346.52c3f592@gandalf.local.home>
        <e9f5eb5e-3830-d19b-dcb0-05f7a36fcb2d@marvell.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 6 Sep 2022 14:26:31 -0700
Arun Easi <aeasi@marvell.com> wrote:

> Steve, I was thinking both the fixes stay at least for a short 
> term the one in qla2xxx to avoid tree dependencies.
> 
> Since, the qla_def.h change goes as:
> 
> +#ifndef CONFIG_TRACING
> +#ifndef trace_array_get_by_name
> 
> ..it should co-exist when the "#define trace_array_get_by_name" gets 
> merged in include/linux/trace.h. BTW, I will send out the changes to 
> trace.h today.
> 
> Other alternatives/suggestions welcome.

I doubt I'll have anything that conflicts with an update to
include/linux/trace.h, as it is seldom modified.

Just sent a patch out that updates that file and I'll review it, and then
you can push it through your tree.

-- Steve
