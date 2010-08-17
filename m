From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/11] block: rename barrier/ordered to flush
Date: Tue, 17 Aug 2010 18:23:55 +0200
Message-ID: <4C6AB79B.2040303@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-9-git-send-email-tj@kernel.org> <20100817132646.GA3577@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:53360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab0HQQ1b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2010 12:27:31 -0400
In-Reply-To: <20100817132646.GA3577@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, Christoph Hellwig <hch@infradead.org>

Hello,

On 08/17/2010 03:26 PM, Christoph Hellwig wrote:
>> -#define blk_queue_flushing(q)	((q)->ordseq)
>> +#define blk_queue_flushing(q)	((q)->flush_seq)
> 
> Btw, I think this one should just go away.  It's only used by
> ide in an attempt to make ordered sequences atomic, which isn't
> needed for the new design.

Yeap, agreed.  I couldn't really understand why the the sequence
needed to be atomic for ide in the first place so just left it alone.
Do you understand why it tried to be atomic?

Thanks.

-- 
tejun
