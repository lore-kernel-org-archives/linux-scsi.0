From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 05/14] block: Deprecate the use of the term sector in the context of block integrity
Date: Wed, 11 Jun 2014 20:26:42 -0400
Message-ID: <yq1lht3q8fx.fsf@sermon.lab.mkp.net>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
	<1401334128-15499-6-git-send-email-martin.petersen@oracle.com>
	<20140611164538.GA9511@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31484 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbaFLA1N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 20:27:13 -0400
In-Reply-To: <20140611164538.GA9511@infradead.org> (Christoph Hellwig's
	message of "Wed, 11 Jun 2014 09:45:38 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Wed, May 28, 2014 at 11:28:39PM -0400, Martin K. Petersen wrote:
>> The protection interval is not necessarily tied to the logical block
>> size of a block device. Stop using the terms sector and sectors.

Christoph> This does more than just renaming symbols, so it needs a
Christoph> better description or even better splitting into separate
Christoph> patches.

The only thing I see that does more than a rename is the interval
calculation tweak. I'll put that in a separate patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
