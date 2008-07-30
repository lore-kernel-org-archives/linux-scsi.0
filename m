From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: Re: [PATCH 0/3] cmd_filter fixes
Date: Wed, 30 Jul 2008 21:59:41 +0200
Message-ID: <6cf6b73e0807301259s309f6332wef74d2ac5bafe691@mail.gmail.com>
References: <1217063005-25083-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <6cf6b73e0807271259y2fb9c565jc6981438feeb571f@mail.gmail.com>
	 <6cf6b73e0807271302o77700222r321102ef7be0333b@mail.gmail.com>
	 <20080728111915N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:7843 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbYG3T7m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 15:59:42 -0400
Received: by fk-out-0910.google.com with SMTP id 18so135879fkq.5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2008 12:59:41 -0700 (PDT)
In-Reply-To: <20080728111915N.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net, matthew@wil.cx

2008/7/28 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
>> > Thanks for the fixes, wanted to test them but they don't apply cleanly
>> > here (tried against Jens and Linus tree).
>
> Hmm, I can cleanly apply them against Linus's latest tree:
>
> commit c9272c4f9fbe2087beb3392f526dc5b19efaa56b
> Merge: fb4284b... 744d18d...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Jul 27 16:47:55 2008 -0700
>
>    Merge branch 'hotfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6
>
> For your convenience, I also put them to a git tree:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git cmdfilter
>

Odd, got them to build now from quick testing there seem to work fine.

>> > Anyway the look fine to me from just reading it ... have you tested if
>> > changing the filter actually works?
>> >
>> Should be "Anyway the look fine to me from just reading them ... have
>> you tested if
>> changing the filter (via sysfs) actually works?"
>
> Yes though not much.

OK, thanks. Will do more detailed testing this weekend.

> BTW, I think that we need a document about how to control command
> filters via sysfs (and IMO, there might be a better interface to
> change the filter).

Yeah agreed, will add some docs this weekend.
As for "better interface" ... I am open for suggestions ;)
This was the one used in Peter's original patch and it looks straight forward.
