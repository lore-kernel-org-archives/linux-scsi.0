From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] target: Pass through I/O topology for block backstores
Date: Wed, 16 Oct 2013 15:29:37 -0700
Message-ID: <525F1351.8020403@redhat.com>
References: <1381513206-8155-1-git-send-email-agrover@redhat.com> <20131011180348.GA21030@infradead.org> <52584905.4080307@redhat.com> <20131012080824.GA12362@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab3JPWaU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Oct 2013 18:30:20 -0400
In-Reply-To: <20131012080824.GA12362@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 10/12/2013 01:08 AM, Christoph Hellwig wrote:
> On Fri, Oct 11, 2013 at 11:52:53AM -0700, Andy Grover wrote:
>> It seemed better to me to keep the munging from queue_limits values
>> to what the target core needed in the block backstore code, and not
>> use a block-specific structure in the backstore<->core interface.
>>
>> It looks like a few includes of blkdev.h slipped into target core,
>> but these can be removed safely -- lio core doesn't depend on the
>> block layer.
>>
>> We could define a new struct to get the 4 values at once, but it
>> didn't seem worth it, esp. since two are only needed by
>> emulate_readcapacity16, and the other two only by emulate_evpd_b0.
>
> I really don't like the influx of methods.  But given thsat you have
> done the work I'd say merge your patch for now and then we can later see
> if we can come up with something more elegant.

Nick, any cleaner ways to implement this come to mind? Happy to respin.

If not, please apply.

Regards -- Andy

