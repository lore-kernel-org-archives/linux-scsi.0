From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] virtio_scsi: remove ACCESS_ONCE() and smp_read_barrier_depends()
Date: Thu, 8 May 2014 00:29:14 +0800
Message-ID: <CACVXFVPQ7WoxcTSP3Q-wpbHgK5eJr5W+OF_RCVje755MPTtEDg@mail.gmail.com>
References: <1399473279-24871-1-git-send-email-tom.leiming@gmail.com>
	<536A564F.3060605@redhat.com>
	<CACVXFVO_hg52+5U_njExbX1GtY1456HS_wsK0uyB-9fj+BFDpw@mail.gmail.com>
	<536A5B67.8030502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:33994 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbaEGQ3P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 12:29:15 -0400
Received: by mail-ve0-f181.google.com with SMTP id pa12so1582853veb.26
        for <linux-scsi@vger.kernel.org>; Wed, 07 May 2014 09:29:14 -0700 (PDT)
In-Reply-To: <536A5B67.8030502@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>

On Thu, May 8, 2014 at 12:12 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 07/05/2014 18:03, Ming Lei ha scritto:
>>>
>>>  *
>>>
>>>  * - likewise, decrements of reqs only occur when reqs != 0.  If the
>>> decremented
>>>  *   value is zero, the first CPU that enters virtscsi_queuecommand_multi
>>> will
>>>  *   modify req_vq and the others will spin on tgt_lock.
>>
>>
>> The fact should be obvious too,
>
>
> Perhaps, but in your patch you're leaving a "Similarly" that doesn't apply
> anymore.

OK, I will remove the 'Similarly', ;-)

Thanks,
-- 
Ming Lei
