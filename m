From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: I/O path cleanup
Date: Tue, 30 Sep 2014 15:31:25 +0200
Message-ID: <542AB0AD.1090604@acm.org>
References: <1410107469-896-1-git-send-email-hch@lst.de> <540D5940.8070900@acm.org> <20140908151301.GA2551@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:40631 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaI3Nb1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 09:31:27 -0400
In-Reply-To: <20140908151301.GA2551@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On 09/08/14 17:13, Christoph Hellwig wrote:
> On Mon, Sep 08, 2014 at 09:22:40AM +0200, Bart Van Assche wrote:
>> On 09/07/14 18:31, Christoph Hellwig wrote:
>>> This series cleans up a couple of lose ends I noticed during the scsi-mq
>>> work, but which weren't important enough to address during the last cycle.
>>
>> Is there perhaps a public git tree available with this patch series ? I
>> have tried to apply these patches on top of v3.17-rc4 but unfortunately
>> without success:
>
> I've pushed a scsi-io-path-cleanups tree to my scsi-queue.git tree.
>
> I think you were missing the patches from the core-for-3.18 branch which
> overlap a bit.
>
> I will also rebase the core-for-3.18 and drivers-for-18 branches soon
> as -rc1 which they are currently based on has the percpu issues the
> scsi + blk-mq can trigger easily.

(replying to an e-mail of three weeks ago)

Hello Christoph,

At least in the tests I ran myself these patches are working fine in 
combination with scsi-mq and the SRP initiator. The tree I have been 
testing with has commit ID ec8af1eb08f2 - this is the tree on top of 
v3.17-rc4.

Bart.
