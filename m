From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 10:23:10 -0400
Message-ID: <yq1d4ysv35d.fsf@sermon.lab.mkp.net>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
	<18075.31515.974905.507754@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:12551 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126AbXGPOXT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 10:23:19 -0400
In-Reply-To: <18075.31515.974905.507754@stoffel.org> (John Stoffel's message of "Mon, 16 Jul 2007 10:05:15 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "John" == John Stoffel <john@stoffel.org> writes:

John> Will this help out tape drive performance at all?  I looked
John> through the patches quickly, esp the AIC7xxx stuff since that's
John> what I use, but nothing jumped out at me...

Yes.  Most modern tape drives want a block size of 1MB or higher.
With the old stack we'd be stuck at 512KB because the sg limitations
caused us to come just short of 1MB...

-- 
Martin K. Petersen	Oracle Linux Engineering

