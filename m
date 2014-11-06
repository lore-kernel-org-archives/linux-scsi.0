From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 01/11] blk-mq: Add blk_mq_unique_tag()
Date: Thu, 06 Nov 2014 15:22:11 +0100
Message-ID: <545B8413.9060902@acm.org>
References: <545240AE.6060009@acm.org> <545240E7.5030206@acm.org> <20141104141432.GA446@infradead.org> <545A19FA.40706@acm.org> <20141105185400.GA17425@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:57701 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaKFOWN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 09:22:13 -0500
In-Reply-To: <20141105185400.GA17425@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 11/05/14 19:54, Christoph Hellwig wrote:
> On Wed, Nov 05, 2014 at 01:37:14PM +0100, Bart Van Assche wrote:
>> That's strange. I have compared the patches that are already in your tree
>> with the patches I had posted myself with a diff tool. These patches look
>> identical to what I had posted except for one CC tag that has been left out.
>> If I try to apply the three patches that have not yet been included in your
>> tree (9/11..11/11) on top the drivers-for-3.19 branch then these patches
>> apply fine. Anyway, I have rebased my tree on top of your drivers-for-3.19
>> branch, added a few other patches (including one block layer patch that has
>> not yet been posted) and retested the SRP initiator driver against the
>> traditional SCSI core and also against the scsi-mq core. The result can be
>> found here: https://github.com/bvanassche/linux/commits/srp-multiple-hwq-v4.
>> Can you please retry to apply patches 9/11..11/11 apply on top of the
>> drivers-for-3.19 branch ?
>
> I've pulled in the three remaining patches from the series from that
> tree.  If you want me to pull in the remaining trivial srp patch as well
> please give me a Reviewed-by: and I'll also pull it in.

Thanks !

Regarding the remaining SRP patch: Roland has already been asked to pull 
that patch (see also 
http://thread.gmane.org/gmane.linux.drivers.rdma/22018).

Bart.
