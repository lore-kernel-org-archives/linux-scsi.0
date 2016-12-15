From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 14/22] qla2xxx: Add interrupt polling mechanism
Date: Thu, 15 Dec 2016 10:27:05 +0100
Message-ID: <0ae46bd0-a5f1-c962-2b86-5b95d815095f@acm.org>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-15-git-send-email-himanshu.madhani@cavium.com>
 <20161214210635.GC1011@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20161214210635.GC1011@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/14/2016 10:06 PM, Christoph Hellwig wrote:
> On Tue, Dec 06, 2016 at 12:30:43PM -0800, Himanshu Madhani wrote:
>> From: Quinn Tran <quinn.tran@cavium.com>
>>
>> This patch adds capability to poll for an interrupt, If hardware
>> does not generate any interrupt for 2 seconds.
> 
> This description sounds like the hardware might be buggy and not
> generate interrupts, in which case 2 seconds is a very long time.
> 
> Can you explain the intention a bit better?

In addition to Christoph's question: is this a workaround for a hardware
bug or for a firmware bug? If it is a workaround for a firmware bug,
since the qla2xxx firmware can be upgraded, why is an interrupt polling
mechanism added to the kernel driver instead of fixing the firmware?

Bart.
