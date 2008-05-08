From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Thu, 8 May 2008 17:02:50 +0200
Message-ID: <e2e108260805080802r1ad75926idc8654e2acfe014f@mail.gmail.com>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805040830i7d797c53o9757bae7243d6e27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:47359 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764668AbYEHPCw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 11:02:52 -0400
Received: by fg-out-1718.google.com with SMTP id 19so542377fgg.17
        for <linux-scsi@vger.kernel.org>; Thu, 08 May 2008 08:02:50 -0700 (PDT)
In-Reply-To: <e2e108260805040830i7d797c53o9757bae7243d6e27@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

On Sun, May 4, 2008 at 5:30 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On Fri, May 2, 2008 at 5:55 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Fri, May 02, 2008 at 05:53:22PM +0200, Bart Van Assche wrote:
>>> Regarding scsi_execute_async(): I didn't know that this API is on its
>>> way out. What will it be replaced by, and when ?
>>
>> blk_execute_rq/blk_execute_rq_nowait plus the block level helpers built
>> ontop to build requests.
>
> Source reading learned me that the function scsi_execute_async() calls
> blk_execute_rq_nowait() with 1 as fourth argument, which means that
> the request is inserted at the head of the queue. This means that
> requests queued with scsi_execute_async() are executed before other
> queued requests, and that this function has LIFO (last in first out)
> semantics.
>
> All non-SCSI calls to blk_execute_rq() / blk_execute_rq_nowait() add
> requests at the end of the queue (except those calls for terminating
> I/O).
>
> What is the background of this special behavior of the SCSI subsystem ?

Is the linux-scsi mailing list the appropriate mailing list to post
questions like the above ?

Bart.
