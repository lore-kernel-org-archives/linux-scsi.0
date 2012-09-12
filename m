From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
Date: Wed, 12 Sep 2012 10:18:22 +0200
Message-ID: <5050454E.5020301@redhat.com>
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>  <20120911165953.GK7677@google.com> <504F7B65.9090603@redhat.com> <1347437141.2793.2.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1347437141.2793.2.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 12/09/2012 10:05, James Bottomley ha scritto:
> This is why the whole filter thing was mutable via sysfs.  That way the
> admin could set this up per device.  It sounds like this is what you
> want to fix, rather than opening up more holes in an already leaky
> security apparatus.

It is, thanks for the useful history lesson!

Paolo
