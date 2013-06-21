From: Jan Vesely <jvesely@redhat.com>
Subject: Re: block: Allow merging of tail pages into the last segment
Date: Fri, 21 Jun 2013 17:31:49 +0200
Message-ID: <51C471E5.900@redhat.com>
References: <1364463509-24975-1-git-send-email-jvesely@redhat.com> <516D0ABF.1000700@redhat.com> <51AC9A7C.90306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423273Ab3FUPcU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jun 2013 11:32:20 -0400
In-Reply-To: <51AC9A7C.90306@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@kernel.dk, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: james.bottomley@hansenpartnership.com, =?UTF-8?B?S2FpIE3DpGtpc2FyYQ==?= <kai.makisara@kolumbus.fi>, fujita.tomonori@lab.ntt.co.jp, Tomas Henzl <thenzl@redhat.com>

On Mon 03 Jun 2013 15:30:36 CEST, Jan Vesely wrote:
> On 16/04/13 10:24, Jan Vesely wrote:
>> On 28/03/13 10:38, Jan Vesely wrote:
>>> Hi
>>>
>>> These patches modify __bio_add_page to accept pages that extent the last bio
>>> segment. some drivers craft their buffers and rely on this behavior (see
>>> message in patch 2 for details)
>>
>> any comments on this version would be appreciated
>>
>> thanks
>>
>>>
>>> jan
>>>
>>> v3: Use code from __blk_recalc_rq_segments to decide whether the page is
>>>     mergeable,
>>>
>>> v2: modify a comment
>>>
>>> Jan Vesely (2):
>>>       block: factor out vector mergeable decision to a helper function
>>>       block: modify __bio_add_page check to accept pages that don't start a new
>>>
>>>  block/blk-merge.c   | 52 +++++++++++++++++++++++++++++++---------------------
>>>  fs/bio.c            | 29 ++++++++++++++++++-----------
>>>  include/linux/bio.h |  3 +++
>>>  3 files changed, 52 insertions(+), 32 deletions(-)
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> ping?
>
>
> Jens, your input on v2 helped a lot, any comments on v3?
>
> thanks

ping

--
Jan Vesely <jvesely@redhat.com>
