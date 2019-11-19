Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D336DC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 23:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B64AF2245B
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 23:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfKSXNE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 18:13:04 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34902 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfKSXNE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 18:13:04 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 4A77D285D9;
        Tue, 19 Nov 2019 18:12:58 -0500 (EST)
Date:   Wed, 20 Nov 2019 10:12:21 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Kars de Jong <jongk@linux-m68k.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] esp_scsi: Clear Transfer Count registers before PIO
 transfers
In-Reply-To: <alpine.LNX.2.21.1.1911190923120.8@nippy.intranet>
Message-ID: <alpine.LNX.2.21.1.1911201006520.10@nippy.intranet>
References: <2bbb6359d542f5882be67c415ecc25ad2d9eeb5e.1573875417.git.fthain@telegraphics.com.au> <CACz-3rjHAyi6kMQ6j9YALLm1ApYrsqKiTnGNPUhxqqEuRJ9TjQ@mail.gmail.com> <alpine.LNX.2.21.1.1911180947020.8@nippy.intranet> <CACz-3rhr_R+_mJpg+Rvgoj=1GC5AO3YKxYxS_0ShAfQ-NiFDtg@mail.gmail.com>
 <alpine.LNX.2.21.1.1911190923120.8@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Nov 2019, I wrote:

> 
> But this is a theoretical problem so far. You may need to use sg_utils 
> to generate a SCSI command like that.
> 
> (For a DMA controller subject to, say, 24-bit boundaries, there are 
> additional ways to end up with short transfers.)
> 

On reflection these probably can't happen in practice. I was being 
over-cautious. So I'll leave this patch out-of-tree until there's a need 
for it (i.e. some driver that uses both DMA and PIO in data phases).

-- 
