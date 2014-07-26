From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Block/SCSI data integrity update v2
Date: Sat, 26 Jul 2014 12:33:03 -0400
Message-ID: <yq1silodqrk.fsf@sermon.lab.mkp.net>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
	<20140726162307.GA19441@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46535 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaGZQde (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2014 12:33:34 -0400
In-Reply-To: <20140726162307.GA19441@infradead.org> (Christoph Hellwig's
	message of "Sat, 26 Jul 2014 09:23:07 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> How should we pull it in?  Normally block stuff should go
Christoph> through Jens, but the sd changes won't apply without the
Christoph> various patches in the scsi tree.

Typically Jens and James stagger their merges when we do this. But it
would definitely be easier to just pull everything through SCSI. Except
for the tweak in blk-merge.c I don't touch anything that would interfere
with block code outside of the data integrity files.

Jens, what do you think?

-- 
Martin K. Petersen	Oracle Linux Engineering
