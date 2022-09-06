Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E41EECAAD5
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 16:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbiIFQoR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 12:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbiIFQnR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 12:43:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490C262C0;
        Tue,  6 Sep 2022 09:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B5BC614AA;
        Tue,  6 Sep 2022 16:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70F9C433C1;
        Tue,  6 Sep 2022 16:21:14 +0000 (UTC)
Date:   Tue, 6 Sep 2022 12:21:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arun Easi <aeasi@marvell.com>
Cc:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>
Subject: Re: [EXT] build failure of next-20220906 due to 8bfc149ba24c
 ("scsi: qla2xxx: Enhance driver tracing with separate tunable and more")
Message-ID: <20220906122153.2756a601@gandalf.local.home>
In-Reply-To: <44fe9ca0-e1d7-1e4f-9fd8-0f48a84dca72@marvell.com>
References: <YxdZ/9XOsWilvVSd@debian>
        <44fe9ca0-e1d7-1e4f-9fd8-0f48a84dca72@marvell.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 6 Sep 2022 09:05:38 -0700
Arun Easi <aeasi@marvell.com> wrote:

> This looks like is happening due to CONFIG_TRACING not being enabled (same 
> as what kernel test bot reported). Could you try out the fix attached?
> 
> @Steven, please see the patch attached. Do you think the fix belongs 
> better in linux/trace.h ?

Yes, of course. Feel free to send me a patch.

Thanks!

-- Steve
