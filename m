From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer crash due to active timer for
 ABTS
Date: Wed, 14 Feb 2018 09:27:32 +0100
Message-ID: <1518596852.24629.2.camel@suse.de>
References: <20180212182814.4541-1-himanshu.madhani@cavium.com>
         <1518518327.3592.6.camel@suse.de>
         <8AA80006-774D-4189-9BDF-7410E705D26F@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46855 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754556AbeBNI1e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Feb 2018 03:27:34 -0500
In-Reply-To: <8AA80006-774D-4189-9BDF-7410E705D26F@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2018-02-13 at 18:13 +0000, Madhani, Himanshu wrote:
> Thanks for asking (I did not add fixes commit ID because it was pre
> 4.x kernel) 
> 
> Here’s commit id 4440e46d5db7b445a961a84444849b2a31fa7fd1 which is
> fixed by this patch.

Thanks for the info. In general having a 
Fixes: 4440e46d5db7 ("[SCSI] qla2xxx: Add IOCB Abort command
asynchronous handling.")
line is extremly valuable as many distributions have automation in
place to check whether a fix for a backport arrived upstream.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthu
mshirn@suse.de                                +49 911 74053 689
SUSE
LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane
Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38
9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
