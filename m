From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: status of block-integrity
Date: Mon, 23 Dec 2013 08:35:22 -0500
Message-ID: <yq11u134rmt.fsf@sermon.lab.mkp.net>
References: <20131222192128.GA28532@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mojo.mkp.net ([70.38.64.14]:60901 "EHLO mojo.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab3LWOAH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Dec 2013 09:00:07 -0500
In-Reply-To: <20131222192128.GA28532@infradead.org> (Christoph Hellwig's
	message of "Sun, 22 Dec 2013 11:21:29 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> We have the block integrity code to support DIF/DIX in the
Christoph> the tree for about 5 and a half years, and we still don't
Christoph> have a single consumer of it.  

What do you mean? If you have a DIX-capable HBA (lpfc, qla2xxx, zfcp)
then integrity protection is active from the block layer down. The only
code that's not currently being exercised are the tag interleaving
functions.  I was hoping the FS people would use them for back pointers
but nobody seemed to bite.


Christoph> Given that we'll have a lot of work to do in this area with
Christoph> block multiqueue I think it's time to either kill it off for
Christoph> good or make sure we can actually use and test it.

I don't understand why multiqueue would require a lot of work? It's just
an extra scatterlist per request.

And obviously, if there's anything that needs to be done in this area
I'll be happy to do so...

-- 
Martin K. Petersen	Oracle Linux Engineering

