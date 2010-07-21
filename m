From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] convert flush to REQ_TYPE_FS instead of  REQ_TYPE_BLOCK_PC
Date: Tue, 20 Jul 2010 20:19:25 -0600
Message-ID: <4C46592D.5060908@kernel.dk>
References: <1278635906-16400-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20100721111502B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55559 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762002Ab0GUCTc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 22:19:32 -0400
In-Reply-To: <20100721111502B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On 07/20/2010 08:15 PM, FUJITA Tomonori wrote:
> On Fri,  9 Jul 2010 09:38:23 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
>> This is the second version of flush REQ_TYPE_FS conversion:
>>
>> http://marc.info/?l=linux-scsi&m=127730591527424&w=2
>>
>> There is no major changes since the first version. Just minor
>> adjustment for the discard changes.
>>
>> This can be applied to block's for-2.6.36.
>>
>> The git tree is also available:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git fs-flush
>>
>> =
>>  block/blk-barrier.c       |    3 ++-
>>  drivers/scsi/scsi_error.c |   19 ++++---------------
>>  drivers/scsi/sd.c         |    2 --
>>  3 files changed, 6 insertions(+), 18 deletions(-)
> 
> Jens, any reason why this flush conversion isn't included in your
> for-2.6.36 yet? I've just confirmed that this can be still applied
> cleanly.

Applied.

-- 
Jens Axboe

