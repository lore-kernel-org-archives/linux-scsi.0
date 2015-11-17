From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/9] move blk_iopoll to limit and make it generally
 available
Date: Tue, 17 Nov 2015 09:27:16 -0800
Message-ID: <564B6374.1050201@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-2-git-send-email-hch@lst.de> <564637BC.7080604@sandisk.com>
 <20151114070248.GB27738@lst.de> <564B60EC.3050106@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0080.outbound.protection.outlook.com ([157.56.111.80]:34496
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754281AbbKQR1U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 12:27:20 -0500
In-Reply-To: <564B60EC.3050106@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sagig@dev.mellanox.co.il" <sagig@dev.mellanox.co.il>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 11/17/2015 09:16 AM, Bart Van Assche wrote:
> On 11/13/2015 11:02 PM, Christoph Hellwig wrote:
>> On Fri, Nov 13, 2015 at 11:19:24AM -0800, Bart Van Assche wrote:
>>> On 11/13/2015 05:46 AM, Christoph Hellwig wrote:
>>>> The new name is irq_poll as iopoll is already taken.  Better suggestions
>>>> welcome.
>>>
>>> Would it be possible to provide more background information about this ?
>>> Which other kernel subsystem is using the name iopoll ?
>>
>> Take a look at include/linux/iopoll.h  - I can't reaplly make much sense
>> of it to be honest, but it's used in a quite a few places.
>
> How about renaming blk_iopoll into blk_poll ? That way the name still
> refers to the block layer. And although the current implementation
> performs polling from IRQ context future implementations maybe will
> allow polling from thread context.

(replying to my own e-mail)

Please ignore the previous comment - I just noticed that this mechanism 
is not limited to block devices.

Bart.

