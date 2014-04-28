From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] random: export add_disk_randomness
Date: Mon, 28 Apr 2014 09:17:39 -0600
Message-ID: <535E7113.8000104@kernel.dk>
References: <20140425073610.GA2143@infradead.org> <20140425073637.GB2143@infradead.org> <20140425134951.GF11124@thunk.org> <20140428112908.GB2808@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43968 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbaD1PRk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2014 11:17:40 -0400
Received: by mail-pb0-f53.google.com with SMTP id jt11so4192422pbb.26
        for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2014 08:17:39 -0700 (PDT)
In-Reply-To: <20140428112908.GB2808@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 04/28/2014 05:29 AM, Christoph Hellwig wrote:
> On Fri, Apr 25, 2014 at 09:49:51AM -0400, Theodore Ts'o wrote:
>> On Fri, Apr 25, 2014 at 12:36:37AM -0700, Christoph Hellwig wrote:
>>> This will be needed for pending changes to the scsi midlayer that now calls
>>> lower level block APIs, as well as any blk-mq driver that wants to contribute
>>> to the random pool.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Jens, can you pull this into the block tree for me?

Yep, I'll add it, thanks.

-- 
Jens Axboe

