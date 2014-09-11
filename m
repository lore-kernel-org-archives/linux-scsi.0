From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Block/SCSI data integrity update v3
Date: Wed, 10 Sep 2014 20:23:06 -0400
Message-ID: <yq1tx4f80ph.fsf@sermon.lab.mkp.net>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
	<53FF8CC9.9030206@fb.com> <20140907162957.GA17353@infradead.org>
	<540DD05B.7030908@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22362 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaIKAXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 20:23:41 -0400
In-Reply-To: <540DD05B.7030908@fb.com> (Jens Axboe's message of "Mon, 8 Sep
	2014 09:50:51 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, hch@lst.de, sagig@mellanox.com

>>>>> "Jens" == Jens Axboe <axboe@fb.com> writes:

Jens> Thanks, I'll do that once Martin respins the previous series (was
Jens> pulled due to multiple issues).

I bumped bi_rw to u64 as discussed. Will get that into -next to see if
there's any fallout.

-- 
Martin K. Petersen	Oracle Linux Engineering
