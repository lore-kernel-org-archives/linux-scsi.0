From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Tue, 11 Sep 2012 15:13:53 -0700
Message-ID: <CAOS58YNbzX=FJk6X5zB6iQ6kVVugc_2SegyizpGpVVLLgEj6QQ@mail.gmail.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
	<20120911165953.GK7677@google.com>
	<504F7B65.9090603@redhat.com>
	<20120911182904.GS7677@google.com>
	<504F88CB.6030105@redhat.com>
	<20120911191325.GU7677@google.com>
	<504F8FF0.3000408@redhat.com>
	<20120911200150.GV7677@google.com>
	<504FB22E.4090707@redhat.com>
	<20120911220218.GH7677@google.com>
	<504FB6CB.6020607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <504FB6CB.6020607@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Tue, Sep 11, 2012 at 3:10 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 12/09/2012 00:02, Tejun Heo ha scritto:
>> SG_IO itself is a bypassing interface.  It bypasses most of block
>> layer and the kernel doesn't have any idea (apart from the adhoc
>> filtering) about what's going on.
>
> That's very much the point.  The guest must have free reins.
>
> You asked "Could being able to bypass the filters for this "you own this
> LUN" be a solution?", I said yes and outlined how.  Do you agree with
> the proposed solution?

Ooh, yeah, I like that one. I was still thinking about the bpf one. It
being based on cgroup made me worried even more. :)

> Sure, I'm fine with leaving the current ad hoc filtering aside.  Again,
> I was hoping to get most of the job done by loosening the filter a bit,
> but discussion is inversely proportional to patch length sometimes.

Sorry about dragging it on. The cdb filtering one has always been
controversial and I think it'll continue to be. It's an unfortunate
thing that we had to add.

Thanks.

-- 
tejun
