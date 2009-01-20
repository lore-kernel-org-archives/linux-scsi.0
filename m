From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] bsg: Error print if device is not bidi capable when refusing
 a bidi command
Date: Tue, 20 Jan 2009 16:41:13 +0200
Message-ID: <4975E289.1050407@panasas.com>
References: <4975DC00.2090005@panasas.com> <20090120141517.GM30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:6808 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756957AbZATOlQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 09:41:16 -0500
In-Reply-To: <20090120141517.GM30821@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Jens Axboe wrote:
> On Tue, Jan 20 2009, Boaz Harrosh wrote:
>> If a bidi command was issued to a request_queue not mark as
>> QUEUE_FLAG_BIDI. Issue an error report. This is a misconfiguration
>> an administrator would like to know about, which is otherwise
>> hard to detect.
> 
> At the very least, put rate limit on that printk.
> 

Thanks, good catch it could be a DOS other wise. I did not know
of this facility. Please check if done right?

>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  block/bsg.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>

Boaz
