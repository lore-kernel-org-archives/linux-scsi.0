From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Wed, 14 Feb 2007 06:07:44 -0800
Message-ID: <45D317B0.7020100@torque.net>
References: <20070213095318G.fujita.tomonori@lab.ntt.co.jp> <20070213180033.GB6798@havoc.gtf.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58994 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbXBNOIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2007 09:08:25 -0500
In-Reply-To: <20070213180033.GB6798@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Smart@Emulex.Com, hch@infradead.org

Jeff Garzik wrote:
> On Wed, Feb 14, 2007 at 02:53:31AM +0900, FUJITA Tomonori wrote:
>> It seems that it would be better to bind bsg devices to request_queue
>> instead of gendisk. This enables any objects to define own
>> request_handler and create own bsg device (under sysfs).
>>
>> Possible enhancements:
>>
>> - I removed gendisk but it would be better for objects having gendisk
>> to keep it for nice features like disk stats.
>>
>> - Objects that wants to use bsg need to setup a request_queue. Maybe
>> wrapper functions to setup a request_queue for them would be useful.
>>
>> This patch was tested only with disk drivers.
>>
>>
>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> ---
>>  block/bsg.c            |   37 +++++++++++++++++--------------------
> 
> What is this patch against?  scsi-misc?
> 
> I certainly like the bsg solution, but block/bsg.c does not exist in my
> vanilla linux-2.6.git tree :)

www.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git

branch: bsg

