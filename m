From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for multimedia
 devices
Date: Fri, 25 Jan 2013 18:16:04 +0100
Message-ID: <5102BDD4.2020501@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com> <1359039649-17734-7-git-send-email-pbonzini@redhat.com> <20130124225555.GC2373@mtj.dyndns.org> <51024FB1.3000206@redhat.com> <20130125170434.GC3081@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130125170434.GC3081@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Il 25/01/2013 18:04, Tejun Heo ha scritto:
>> > 
>> > I think it's the other way round.  What's the justification for leaving
>> > them out, if they are in the standard?  Since we're touching the
>> > commands for other standards, it's better to be complete for MMC as well.
> Maybe my experience with ATA left me bitter with the standards, but
> opening gate to everything described in standard sounds like a pretty
> bad idea to me.  If there are users and devices which make use of them
> in sane way, sure.  If not, what's the point of risking it?

Well, you can find broken devices for pretty much every command in the
list.  Anyhow, the other two commands are obsolete so I'm okay with
leaving them out, if only for the sake of avoiding useless email threads.

Paolo

>> > At least one of them (MECHANISM STATUS) is implemented in both QEMU and
>> > Bochs, so someone is using it.  If that someone were run virtualized,
>> > with the host /dev/sr0 passed directly to the guest rather than
>> > emulated, it would break.
> Sure, then, enable MECHANISM_STATUS.
