From: Christoph Hellwig <hch@lst.de>
Subject: Re: I/O path cleanup
Date: Mon, 8 Sep 2014 17:13:01 +0200
Message-ID: <20140908151301.GA2551@lst.de>
References: <1410107469-896-1-git-send-email-hch@lst.de> <540D5940.8070900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44202 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaIHPNH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2014 11:13:07 -0400
Content-Disposition: inline
In-Reply-To: <540D5940.8070900@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Sep 08, 2014 at 09:22:40AM +0200, Bart Van Assche wrote:
> On 09/07/14 18:31, Christoph Hellwig wrote:
>> This series cleans up a couple of lose ends I noticed during the scsi-mq
>> work, but which weren't important enough to address during the last cycle.
>
> Hello Christoph,
>
> Is there perhaps a public git tree available with this patch series ? I 
> have tried to apply these patches on top of v3.17-rc4 but unfortunately 
> without success:

I've pushed a scsi-io-path-cleanups tree to my scsi-queue.git tree.

I think you were missing the patches from mthe core-for-3.18 branch which
overlap a bit.

I will also rebase the core-for-3.18 and drivers-for-18 branches soon
as -rc1 which they are currently based on has the percpu issues the
scsi + blk-mq can trigger easily.
