From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Wed, 12 Sep 2012 00:10:19 +0200
Message-ID: <504FB6CB.6020607@redhat.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <20120911165953.GK7677@google.com> <504F7B65.9090603@redhat.com> <20120911182904.GS7677@google.com> <504F88CB.6030105@redhat.com> <20120911191325.GU7677@google.com> <504F8FF0.3000408@redhat.com> <20120911200150.GV7677@google.com> <504FB22E.4090707@redhat.com> <20120911220218.GH7677@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120911220218.GH7677@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

Il 12/09/2012 00:02, Tejun Heo ha scritto:
> SG_IO itself is a bypassing interface.  It bypasses most of block
> layer and the kernel doesn't have any idea (apart from the adhoc
> filtering) about what's going on.

That's very much the point.  The guest must have free reins.

You asked "Could being able to bypass the filters for this "you own this
LUN" be a solution?", I said yes and outlined how.  Do you agree with
the proposed solution?

> The problem can be approached from
> both directions (make use of OS IO layer improving it as needed or add
> more intelligence to the bypass thing)

Or remove intelligence if it gets in the way.  Of course the removal
must be done by an appropriately-privileged program.

> and I'm not sure at all adding
> more capability to the adhoc filtering is the better direction.

Sure, I'm fine with leaving the current ad hoc filtering aside.  Again,
I was hoping to get most of the job done by loosening the filter a bit,
but discussion is inversely proportional to patch length sometimes.

Paolo
