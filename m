From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Sat, 28 Aug 2004 02:39:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040828093945.GB137773@sgi.com>
References: <40CE9B6F.8000301@torque.net> <20040615074137.GA179379@sgi.com> <40CF10AA.3050509@pobox.com> <20040615213458.GC182050@sgi.com> <20040615221558.GA181797@sgi.com> <20040826070935.GA126538@sgi.com> <412DA2F8.8080607@torque.net> <20040827011252.GA131916@sgi.com> <20040827081024.GA133749@sgi.com> <41301339.1020108@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:6023 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267327AbUH1Jky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 05:40:54 -0400
Content-Disposition: inline
In-Reply-To: <41301339.1020108@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

On Sat, Aug 28, 2004 at 03:08:09PM +1000, Douglas Gilbert wrote:
> Jeremy Higdon wrote:
> >On Thu, Aug 26, 2004 at 06:12:53PM -0700, Jeremy Higdon wrote:
> >
> >
> >This is one of those days when I seem to be working against myself.
> >It turns out that our RAID vendor modified their agent to trim
> >the "reply_len" field for write commands, but did not trim the
> >"count" field for read commands.  So in this case, sg actually
> >guesses correctly when it needs to, and the app works.  Only with
> >this patch, /var/log/messages gets filled with this new error
> >message.
> >
> >Doug, what do you think is the right thing to do?
> 
> Jeremy,
> You could use a (block scope) static and only print out
> the warning the first time it is detected.
> 
> Doug Gilbert

Yes, that's a good idea -- I'll add a rate limiter and also print
out the process name like James does in his recent deprecated
ioctl warning patch.  I'll send a new patch out later this weekend.
Sorry for the churn.

thanks

jeremy
