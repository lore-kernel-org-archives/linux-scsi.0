From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter on per device basis
Date: Wed, 18 Jun 2008 09:33:42 +0200
Message-ID: <6cf6b73e0806180033y1fccba1mb772f59695a9fb53@mail.gmail.com>
References: <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com>
	 <20080616151328Q.fujita.tomonori@lab.ntt.co.jp>
	 <6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com>
	 <20080618051447L.fujita.tomonori@lab.ntt.co.jp>
	 <48583074.8010909@redhat.com> <48584252.5030901@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:4003 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYFRHdp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jun 2008 03:33:45 -0400
Received: by wa-out-1112.google.com with SMTP id j37so109344waf.23
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2008 00:33:43 -0700 (PDT)
In-Reply-To: <48584252.5030901@interlog.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Peter Jones <pjones@redhat.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, torvalds@linux-foundation.org

2008/6/18 Douglas Gilbert <dgilbert@interlog.com>:
> Peter Jones wrote:
>>
>> FUJITA Tomonori wrote:
>>
>>> Well, this changes sg behaviour since sg's allow_ops filter has a
>>> access permission different from blk_verify_command filter's.
>>
>>  >
>>>
>>> I guess that the first thing you need to do is that figuring out a
>>> proper access permission for each command, which sg maintainer, etc
>>> can agree. It's pretty hard and that's the reason why this patch has
>>> not been merged for years, I think.
>>
>> I don't think this logic is sound.
>
> That depends on your viewpoint.
>
> IMO all command filtering should be dropped **.

Here is the last discussion to this topic.
http://thread.gmane.org/gmane.linux.scsi/26229/focus=26229
Seems like people wanted to remove the filter back there but Linus was
against it.
So we have to options let people keep running there apps as root or
with sbit or make the filter configurable.
I would prefer the later....

 We now have
> ATA commands tunnelled through SCSI commands (e.g. via SAT)
> and will soon have encrypted SCSI commands. Are per device
> command filters being proposed? If not, why should we have
> the same SCSI command filter for a USB BD drive and a SCSI
> enclosure services (SES) device controlling a FC array, just
> because they are on the same system?

The patch does the filtering per device. So each device can have its
own filtering logic.
