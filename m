From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/9] move blk_iopoll to limit and make it generally
 available
Date: Tue, 17 Nov 2015 09:16:28 -0800
Message-ID: <564B60EC.3050106@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-2-git-send-email-hch@lst.de> <564637BC.7080604@sandisk.com>
 <20151114070248.GB27738@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0081.outbound.protection.outlook.com ([65.55.169.81]:31710
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751702AbbKQRQe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 12:16:34 -0500
In-Reply-To: <20151114070248.GB27738@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-rdma@vger.kernel.org, sagig@dev.mellanox.co.il, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/13/2015 11:02 PM, Christoph Hellwig wrote:
> On Fri, Nov 13, 2015 at 11:19:24AM -0800, Bart Van Assche wrote:
>> On 11/13/2015 05:46 AM, Christoph Hellwig wrote:
>>> The new name is irq_poll as iopoll is already taken.  Better suggestions
>>> welcome.
>>
>> Would it be possible to provide more background information about this ?
>> Which other kernel subsystem is using the name iopoll ?
>
> Take a look at include/linux/iopoll.h  - I can't reaplly make much sense
> of it to be honest, but it's used in a quite a few places.

How about renaming blk_iopoll into blk_poll ? That way the name still 
refers to the block layer. And although the current implementation 
performs polling from IRQ context future implementations maybe will 
allow polling from thread context.

Bart.
