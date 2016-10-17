From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] final round of SCSI updates for the 4.8+ merge window
Date: Mon, 17 Oct 2016 14:18:41 -0400
Message-ID: <yq1shruhm9q.fsf@sermon.lab.mkp.net>
References: <1476426828.22309.34.camel@HansenPartnership.com>
        <alpine.LNX.2.00.1610150938510.27214@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26163 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756892AbcJQSSz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 14:18:55 -0400
In-Reply-To: <alpine.LNX.2.00.1610150938510.27214@nippy.intranet> (Finn
        Thain's message of "Sat, 15 Oct 2016 09:51:58 +1100 (AEDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

>>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:

>> Ondrej Zary (3): scsi: g_NCR5380: Stop using scsi_module.c

Finn> I believe that patch introduces an .init.text section mismatch,
Finn> that I failed to notice when I reviewed it. So you may want Arnd
Finn> Bergmann's fix which is commit 8f087c089dae5 ("scsi: NCR5380: no
Finn> longer mark irq probing as __init") in mkp-scsi/4.10/scsi-queue.

Queued in 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
