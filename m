From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 12:23:56 +0200
Message-ID: <519C9CBC.3050003@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org> <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130522100212.GE3466@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 22/05/2013 12:02, Tejun Heo ha scritto:
> On Wed, May 22, 2013 at 11:53:30AM +0200, Paolo Bonzini wrote:
>> Il 22/05/2013 11:32, Tejun Heo ha scritto:
>>> On Wed, May 22, 2013 at 08:35:54AM +0200, Paolo Bonzini wrote:
>>>> I'm not sure what is more ridiculous, whether the seven pings or the
>>>> lack of review...
>>>
>>> So, ummm, I don't know what Jens is thinking but at this point I'm
>>> basically waiting for someone else to pick it up as review to return
>>> ratio is too low to continue.  It doesn't seem like I can get the
>>> series into a shape I can ack with reasonable amount of effort.
>>
>> Then please say so.  I didn't find any comment in your review that I missed.
> 
> Well, I've tried that multiple times and didn't get the results that I
> was expecting each time, so doing it all over again felt pointless.
> Even now, you just repeat what you've been saying and I'd have to
> fight through each and every point.

Yes, because I have no idea what _your_ point is.

Let's look at the first submission.

Patch 1 - acked by you.

Patch 2 - discussions on the formatting.  Every comment of yours has
been accounted for, except for one.  I wrote:

     > If you want opcodes visible, you can make them the comments, right?

     Yes, like "/* 0x00 */ CONSTANT, MASK".  I still have a slight
preference
     for the opcodes because if the constant ends up wrong, the
     head-scratching would be higher than if the opcode is wrong (the opcode
     is what you see in the dumps).

You didn't answer; v2 was posted 15 days after the end of the v1 thread,
so you had enough time to post more comments and have them addressed in
v2.  Yo me that means "fair enough".

Patch 3-5 - no comment.

Patch 6 - long discussion, ending with "The vast majority of the
          commands are added because Linux itself is using them", and
          with me removing some commands from the list according to
          your request.

Patch 7-13 - no comment.

Cover letter has no comment either.


So you haven't commented on most patches or on the cover letter, and now
you ask about clarification generically rather than about specific
points of the commit messages or the cover letter.

There is only sensible conclusion I can make.  Namely, that you haven't
even read those commit messages.  So, I'm sorry if you did, but I don't
have a crystal ball to understand what you found wrong, and there's
nothing I can do about it.

> It just doesn't feel worth the
> effort.  It'd be far less effort to just slurp the patches and
> regurgitate them myself.

If there is a fundamental misunderstanding, that wouldn't help anyway.
We would have the same discussion in reverse when I review your patches.

> I don't care that much about the changes
> right now, so I'm just waiting for either someone else picking it up
> or my yield with you somehow magically improving and the next refresh
> addressing most of the issues.

Well, so far there was just one pass, and not even a full one.

Paolo
