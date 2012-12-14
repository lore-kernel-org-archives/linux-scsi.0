From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch,v3,repost 00/10] make I/O path allocations more numa-friendly
Date: Fri, 14 Dec 2012 11:05:04 -0500
Message-ID: <x49pq2czkjz.fsf@segfault.boston.devel.redhat.com>
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
	<x49zk1l6b5p.fsf@segfault.boston.devel.redhat.com>
	<1355220811.2400.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1355220811.2400.5.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Tue, 11 Dec 2012 10:13:31 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Mon, 2012-12-10 at 12:59 -0500, Jeff Moyer wrote:
>> Jeff Moyer <jmoyer@redhat.com> writes:
>> 
>> > Hi,
>> >
>> > This patch set makes memory allocations for data structures used in
>> > the I/O path more numa friendly by allocating them from the same numa
>> > node as the storage device.  I've only converted a handful of drivers
>> > at this point.  My testing is limited by the hardware I have on hand.
>> > Using these patches, I was able to max out the bandwidth of the storage
>> > controller when issuing I/O from any node on my 4 node system.  Without
>> > the patch, I/O from nodes remote to the storage device would suffer a
>> > penalty ranging from 6-12%.  Given my relatively low-end setup[1], I
>> > wouldn't be surprised if others could show a more significant performance
>> > advantage.
>> >
>> > This is a repost of the last posting.  The only changes are additional
>> > reviewed-by/acked-by tags.  I think this version is ready for inclusion.
>> > James, would you mind taking a look?
>> 
>> James?  Do you have any objections to including this for 3.8?
>
> Probably for 3.9 since the 3.8 merge window is upon us.

OK.

> Do we actually have any performance numbers from the big system people?
> That's really a must for this type of work.

I'm working on getting some numbers.

> It's missing acks from the affected drivers; that's not a show stopper
> but it would be better to have them.

Well, we could trim the driver list to those that have ACKs, but the
driver changes are trivial.

Thanks,
Jeff
