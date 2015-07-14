From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] fix host max depth checking for the 'queue_depth' sysfs interface
Date: Mon, 13 Jul 2015 21:30:29 -0400
Message-ID: <yq1zj2zseyy.fsf@sermon.lab.mkp.net>
References: <20150713142439.GA14427@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24718 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbbGNBbG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2015 21:31:06 -0400
In-Reply-To: <20150713142439.GA14427@kernel.dk> (Jens Axboe's message of "Mon,
	13 Jul 2015 08:24:39 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

>>>>> "Jens" == Jens Axboe <axboe@fb.com> writes:

Jens> Commit 1e6f2416044c0 changed the scsi sysfs 'queue_depth' code to
Jens> rejects depths higher than the scsi host template setting. But
Jens> lots of hosts set this to 1, and update the settings in the scsi
Jens> host when the controller/devices probing happens.

Yeah. We can't rely on the template for this.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
