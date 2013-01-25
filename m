From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for multimedia
 devices
Date: Fri, 25 Jan 2013 10:26:09 +0100
Message-ID: <51024FB1.3000206@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com> <1359039649-17734-7-git-send-email-pbonzini@redhat.com> <20130124225555.GC2373@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130124225555.GC2373@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Il 24/01/2013 23:55, Tejun Heo ha scritto:
> On Thu, Jan 24, 2013 at 04:00:42PM +0100, Paolo Bonzini wrote:
>> Strangely, a couple of MMC commands were never included.  Add them too.
> 
> What are the justifications for adding these commands to the filter?
> Are there users requesting these?

I think it's the other way round.  What's the justification for leaving
them out, if they are in the standard?  Since we're touching the
commands for other standards, it's better to be complete for MMC as well.

At least one of them (MECHANISM STATUS) is implemented in both QEMU and
Bochs, so someone is using it.  If that someone were run virtualized,
with the host /dev/sr0 passed directly to the guest rather than
emulated, it would break.

Paolo
