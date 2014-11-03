From: Meelis Roos <meelis.roos@ut.ee>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Mon, 03 Nov 2014 15:05:15 +0200
Message-ID: <c1b17e67aac4b5c507f6bff2049773a3@pohl.ut.ee>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee>
 <20141103100816.GA16752@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vmail.ut.ee ([193.40.5.83]:54780 "EHLO vmail.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaKCNNn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2014 08:13:43 -0500
In-Reply-To: <20141103100816.GA16752@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

03-11-2014 12:08 kirjutas Christoph Hellwig:

> Meelis,
> 
> can you give the patch below a try? This only tries to locked the door
> on devices that actually were reset. Given that on a reset device we
> fail all commands before resuming operations it should work fine there
> as all tags should be released.

Works fine on both DL380G3 and the other server with MPT and IDE CD.

-- 
Meelis Roos
