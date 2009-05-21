From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix oops with block tag queueing
Date: Fri, 22 May 2009 08:23:03 +0900
Message-ID: <4A15E257.9010907@gmail.com>
References: <1242839186.2881.57.camel@localhost.localdomain> <4A14B4A1.5050303@gmail.com> <4A15858A.5000906@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:58201 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZEUXVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2009 19:21:49 -0400
Received: by bwz22 with SMTP id 22so1317389bwz.37
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2009 16:21:49 -0700 (PDT)
In-Reply-To: <4A15858A.5000906@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <Jens.Axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> On 05/21/2009 04:55 AM, Tejun Heo wrote:
>> James Bottomley wrote:
>> There are also some drivers which use queuelist for internal purposes
>> after dequeueing, which also screws up blk_queued_rq() test in
>> addition to being questionable practice to begin with.  Maybe we would
>> be better off with a flag?
>>
> 
> What is the REQ_STARTED flag for?

That is used to pin a request which has been peeked by low level
driver at the top of the queue so that the next peek or fetch returns
the same request.  I'm not sure whether that is necessary at this
point tho.

Thanks.

-- 
tejun
