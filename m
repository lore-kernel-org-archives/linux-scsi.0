From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter
 on per device basis
Date: Wed, 18 Jun 2008 10:56:51 -0400
Message-ID: <48592233.6040408@redhat.com>
References: <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com>	<20080616151328Q.fujita.tomonori@lab.ntt.co.jp>	<6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com> <20080618051447L.fujita.tomonori@lab.ntt.co.jp> <48583074.8010909@redhat.com> <48584252.5030901@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYFRO5z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2008 10:57:55 -0400
In-Reply-To: <48584252.5030901@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

Douglas Gilbert wrote:
> Peter Jones wrote:
>> FUJITA Tomonori wrote:
>>
>>> Well, this changes sg behaviour since sg's allow_ops filter has a
>>> access permission different from blk_verify_command filter's.
>>  >
>>> I guess that the first thing you need to do is that figuring out a
>>> proper access permission for each command, which sg maintainer, etc
>>> can agree. It's pretty hard and that's the reason why this patch has
>>> not been merged for years, I think.
>>
>> I don't think this logic is sound.
> 
> That depends on your viewpoint.

My viewpoint is this:

1) Whether you agree with his reasons or not, Linus made it pretty clear 
that he's against removing the command filter (see 
http://marc.info/?l=linux-scsi&m=115419945212450&w=2 )
2) Having different code paths use different filtering code just adds 
more confusion.
3) If we're going to have filtering, it should be configurable on a 
per-device basis from userland.

Which of these do you disagree with?

[...]
> Are per device command filters being proposed?

Yes, that's what the patch implements.  And it allows the userland to 
configure them according to the needs of the hardware.

-- 
   Peter
