From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: remove CDROM not ready printk
Date: Thu, 29 May 2008 08:51:31 -0600
Message-ID: <20080529145131.GS22636@parisc-linux.org>
References: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain> <20080529004154.bbc7b1d4.akpm@linux-foundation.org> <1212069932.3428.1.camel@localhost.localdomain> <75b57c110805290735i493eca0fp882f4a38901a416c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51355 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYE2Ovc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2008 10:51:32 -0400
Content-Disposition: inline
In-Reply-To: <75b57c110805290735i493eca0fp882f4a38901a416c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerb Stralko <gerb.stralko@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, May 29, 2008 at 10:35:08AM -0400, Gerb Stralko wrote:
> On Thu, May 29, 2008 at 10:05 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > That's correct.  cgc is the data from the packet command that was sent
> > in from the ioctl.  The user application is actually the one that
> > decides whether you get to see the message or not.  Modern apps like hal
> > set it because they take care of all state updates and notifications
> > themselves.  Which is the application that's doing this (because it
> > probably needs updating).
> 
> So is that printk really needed?  Should the kernel even need to print
> a message like that, esp. if user-space is handling state updates and
> notifications.  Or do i need to configure hald to be quietier?   FWIW
> I'm using fedora core 9 and hald version:
> -bash-3.2$ /usr/sbin/hald --version
> HAL package version: 0.5.11

I think you misunderstood.  James is saying that an app like HAL will
set the ->quiet flag.  You must be using some other application that
isn't setting the ->quiet flag.  Any idea what this other application
is?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
