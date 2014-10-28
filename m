From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lib/scatterlist: fix memory leak with scsi-mq
Date: Mon, 27 Oct 2014 20:07:55 -0400
Message-ID: <yq11tptqco4.fsf@sermon.lab.mkp.net>
References: <5449529D.5070804@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21563 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaJ1AIP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 20:08:15 -0400
In-Reply-To: <5449529D.5070804@cybernetics.com> (Tony Battersby's message of
	"Thu, 23 Oct 2014 15:10:21 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

>>>>> "Tony" == Tony Battersby <tonyb@cybernetics.com> writes:

Tony> Fix a memory leak with scsi-mq triggered by commands with large
Tony> data transfer length.

Tony> Fixes: c53c6d6a68b1 ("scatterlist: allow chaining to preallocated
Tony> chunks") 

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
