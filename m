From: Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Convert megaraid2 to compat_ioctl
Date: 3 Feb 2005 22:12:10 +0100
Message-ID: <20050203211210.GA53249@muc.de>
References: <0E3FA95632D6D047BA649F95DAB60E570366266B@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from colin2.muc.de ([193.149.48.15]:13575 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S263046AbVBCVMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2005 16:12:15 -0500
Date: Thu, 3 Feb 2005 22:12:10 +0100
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570366266B@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Thu, Feb 03, 2005 at 11:01:39AM -0500, Ju, Seokmann wrote:
> On Tuesday, January 18, 2005 6:17 AM, Andi wrote:
> > Convert megaraid2 driver to new compat_ioctl entry points.
> > 
> > I don't have easy access to hardware, so only compile tested.
> 
> Thanks for your feedback and appreciate changes you've made.
> The changes look great to me.  
> One question, though, any reason to have 'lock_kernel'?

It was hold before and I didn't want to audit all the code
to make sure it was safe to not hold it.

> Isn't it too huge to use, here?

Probably yes. If you're audited the code and feel confident
that it doesn't need it feel free to drop.

> It could lead system hung if ioctl goes to sleep for some reason.

No, lock_kernel is magically dropped on sleeps.

-Andi
