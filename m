From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 30 Jan 2008 18:03:10 +0100
Message-ID: <e2e108260801300903k66e69148w2f5a90c521558ec4@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <e2e108260801300029r1a949353k73b30f1f28db0bc9@mail.gmail.com>
	 <1201710175.3292.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:51865 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYA3RDM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2008 12:03:12 -0500
Received: by rn-out-0910.google.com with SMTP id i24so202292rng.19
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 09:03:11 -0800 (PST)
In-Reply-To: <1201710175.3292.16.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Jan 30, 2008 5:22 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> ...
> Deciding what lives in userspace and what should be in the kernel lies
> at the very heart of architectural decisions.  However, the argument
> that "it should be in the kernel because that would make it faster" is
> pretty much a discredited one.  To prevail on that argument, you have to
> demonstrate that there's no way to enable user space to do the same
> thing at the same speed.  Further, it was the same argument used the
> last time around when the STGT vs SCST investigation was done.  Your own
> results on non-IB networks show that both architectures perform at the
> same speed.  That tends to support the conclusion that there's something
> specific about IB that needs to be tweaked or improved for STGT to get
> it to perform correctly.

You should know that given two different implementations in software of the
same communication protocol, differences in latency and throughput become
more visible as the network latency gets lower and the throughput gets higher.
That's why conclusions can only be drawn from the InfiniBand numbers, and
not from the 1 Gbit/s Ethernet numbers. Assuming that there is something
specific in STGT with regard to InfiniBand is speculation.

> Furthermore, if you have already decided before testing that SCST is
> right and that STGT is wrong based on the architectures, it isn't
> exactly going to increase my confidence in your measurement methodology
> claiming to show this, now is it?

I did not draw any conclusions from the architecture -- the only data I based my
conclusions on were my own performance measurements.

> ...
> These are both features being independently worked on, are they not?
> Even if they weren't, the combination of the size of SCST in kernel plus
> the problem of having to find a migration path for the current STGT
> users still looks to me to involve the greater amount of work.

My proposal was to have both the SCST kernel code and the STGT kernel
code in the mainstream Linux kernel. This would make it easier for current
STGT users to evaluate SCST. It's too early to choose one of the two
projects -- this choice can be made later on.

Bart.
