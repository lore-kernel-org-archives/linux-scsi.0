Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A607C48BDF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 23:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B7B6136E
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 23:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhFMXQ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 19:16:27 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:40072 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbhFMXQZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 19:16:25 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 15DNEKx9008385
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 14 Jun 2021 00:14:21 +0100
From:   Nix <nix@esperi.org.uk>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PING][PATCH v2 0/5] Bring the BusLogic host bus adapter driver
 up to Y2021
References: <alpine.DEB.2.21.2104201934280.44318@angie.orcam.me.uk>
        <alpine.DEB.2.21.2106110102340.1657@angie.orcam.me.uk>
Emacs:  The Awakening
Date:   Mon, 14 Jun 2021 00:14:20 +0100
In-Reply-To: <alpine.DEB.2.21.2106110102340.1657@angie.orcam.me.uk> (Maciej W.
        Rozycki's message of "Fri, 11 Jun 2021 01:25:36 +0200 (CEST)")
Message-ID: <874ke1pdbn.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=7 Fuz1=7 Fuz2=7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11 Jun 2021, Maciej W. Rozycki said:

> On Tue, 20 Apr 2021, Maciej W. Rozycki wrote:
>
>>  Questions, comments, concerns?  Otherwise please apply.
>
>  Ping for: 
>
> <https://patchwork.kernel.org/project/linux-scsi/list/?series=470455&archive=both>.
>
>  Where are we with this patch series?  I can see it's been archived in 
> patchwork in the new state.  With the unexpected serial device fixes which 
> preempted me and which I've just posted, moving them off the table I now 
> have some spare cycles to get back here, but I'm not sure what to do.
>
>  Nix was kind enough to verify and tell me off-list that 5/5 still works 
> correctly with his system that required the earlier change referred there 
> and the need for which was not completely understood back then -- Nix, are 
> you OK with adding a `Tested-by' tag for your verification?

Sure, as long as I don't have to verify it again, because the loft is a
superheated pollen hell right now and I am not going up there unless it
actually catches fire or something :)

If that needs an actual name, like S-o-b, you can use

Tested-by: Nick Alcock <nick.alcock@oracle.com>
