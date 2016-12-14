From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 4/6] qla2xxx: Add multiple queue pair functionality.
Date: Tue, 13 Dec 2016 21:07:00 -0500
Message-ID: <yq1a8bze01n.fsf@sermon.lab.mkp.net>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
        <1481051266-32362-5-git-send-email-himanshu.madhani@cavium.com>
        <20161207190502.GB29031@infradead.org>
        <693AAE59-413D-4416-837A-8E60A7C73455@cavium.com>
        <20161209131016.GA15254@infradead.org>
        <E9B6495D-31D5-4A48-BD75-F26C72AA3531@cavium.com>
        <06FF934D-B3F7-49B3-95D9-DA453AC0DD95@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39479 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbcLNCH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 21:07:29 -0500
In-Reply-To: <06FF934D-B3F7-49B3-95D9-DA453AC0DD95@cavium.com> (Himanshu
        Madhani's message of "Fri, 9 Dec 2016 21:42:06 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: Christoph Hellwig <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Himanshu" == Madhani, Himanshu <Himanshu.Madhani@cavium.com> writes:

Himanshu> Would you be pulling changes for this new call into scsi tree
Himanshu> anytime soon

Himanshu> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=irq/for-block

James just sent the first batch of 4.10 to Linus.

Once Linus merges I'll start the 4.10/scsi-fixes branch. We have a few
patches that depend on block layer changes and they'll go in first
thing.

-- 
Martin K. Petersen	Oracle Linux Engineering
