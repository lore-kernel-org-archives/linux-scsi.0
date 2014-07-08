From: Jens Axboe <axboe@kernel.dk>
Subject: Re: uas: kernel BUG at block/blk-tag.c:89 is back again :|
Date: Tue, 08 Jul 2014 11:54:14 +0200
Message-ID: <53BBBFC6.2030205@kernel.dk>
References: <53B2B4B2.8050100@redhat.com> <20140703060135.GA5292@infradead.org> <53B93FE3.8050607@redhat.com> <20140707101015.GB3544@infradead.org> <53BA95C0.3020607@redhat.com> <20140708095317.GA4306@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:62241 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaGHJyS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2014 05:54:18 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so5681046wes.4
        for <linux-scsi@vger.kernel.org>; Tue, 08 Jul 2014 02:54:17 -0700 (PDT)
In-Reply-To: <20140708095317.GA4306@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hans de Goede <hdegoede@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-scsi@vger.kernel.org

On 2014-07-08 11:53, Christoph Hellwig wrote:
> On Mon, Jul 07, 2014 at 02:42:40PM +0200, Hans de Goede wrote:
>>> I can't see any sensible way to "fix" the issue.  Struct gendisk keeps a
>>> reference to the requeue_queue, and a struct gendisk reference is held
>>> as long as the block device is open.  So whenever you surprise remove a
>>> device that is open (usually by having a filesystem mounted on it),
>>> the request_queue and it's reference to the tag structure will vastly
>>> outlive the Scsi_Host.
>>
>> Ok, so can we then please move forward with getting your patch merged ?
>
> I've posted the patch in reply to another report and added Jens to the
> Cc list.  As the block maintainer he need to review and merge it.

Which patch is this?


-- 
Jens Axboe

