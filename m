From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for multimedia
 devices
Date: Fri, 25 Jan 2013 18:57:20 +0100
Message-ID: <5102C780.3090402@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com> <1359039649-17734-7-git-send-email-pbonzini@redhat.com> <20130124225555.GC2373@mtj.dyndns.org> <51024FB1.3000206@redhat.com> <20130125170434.GC3081@htj.dyndns.org> <5102BDD4.2020501@redhat.com> <20130125172805.GG3081@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130125172805.GG3081@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Il 25/01/2013 18:28, Tejun Heo ha scritto:
> On Fri, Jan 25, 2013 at 06:16:04PM +0100, Paolo Bonzini wrote:
>> > Well, you can find broken devices for pretty much every command in the
>> > list.  Anyhow, the other two commands are obsolete so I'm okay with
>> > leaving them out, if only for the sake of avoiding useless email threads.
> Once we open the commands to userland this way, it's difficult to
> throttle it back again.

I think the right place to throttle them back would be with a per-device
quirk, but I understand being conservative since we're talking about two
obsolete commands.

> I just fail to see the point of allowing
> everything possible.  There's a way to override it (is that in yet?)

No, it's not.  I made it patch 13/13 in this series.

> and we can always extend the list later, so please do the minimal set
> with justification

I cannot really give justification for single commands.  What this is
going to be used for is virt, but I cannot know of all OSes and all
proprietary software in the wild.  You have to some extent accept that
if it is in the standard, somebody had the need for it, usually a big
database vendor.

And because someone _will_ use it from my point of view, I can only give
justification to leave stuff _out_.  In general I did so if the command
can disrupt someone else, as would be the case for persistent
reservations.  It was not really always respected for the existing
table, for example I'd have left out LOG SELECT, but the series is
already controversial enough, so one thing at a time.

I put these three commands in because I wanted to include somewhere all
the commands that were in my list, and I had no reason to leave them
out.  Two of them are obsolete, so if you prefer to keep them out I'll
move them, end of the story. :)

> and can you please stop labeling reviews as "useless"?

Reviews are not useless, but championing the inclusion of two obsolete
commands in a list is not a good use of bandwidth.  Because the choice
is arbitrary, the discussion can degenerate too easily into repeatedly
saying the same thing over and over.  All I'm trying to do is avoid it.

Paolo
