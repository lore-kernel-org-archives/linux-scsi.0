Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3146C432C0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 23:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF7F920730
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 23:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfKPXC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 18:02:58 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52816 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfKPXC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Nov 2019 18:02:58 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 875D728EDF;
        Sat, 16 Nov 2019 18:02:56 -0500 (EST)
Date:   Sun, 17 Nov 2019 10:02:46 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Michael Schmitz <schmitzmic@gmail.com>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kars de Jong <jongk@linux-m68k.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] esp_scsi: Clear Transfer Count registers before PIO
 transfers
In-Reply-To: <36712461-b94c-4aff-8664-3896c2cf2524@gmail.com>
Message-ID: <alpine.LNX.2.21.1.1911170959440.10@nippy.intranet>
References: <2bbb6359d542f5882be67c415ecc25ad2d9eeb5e.1573875417.git.fthain@telegraphics.com.au> <36712461-b94c-4aff-8664-3896c2cf2524@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Sat, 16 Nov 2019, Michael Schmitz wrote:

> 
> I believe you also need to send a DMA NOP command to the ESP
> 

I believe you're right. I shall add the missing DMA NOP command. Thanks 
for your review!

-- 
