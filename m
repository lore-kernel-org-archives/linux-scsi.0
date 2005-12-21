From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.15-rc6
Date: Wed, 21 Dec 2005 17:23:43 -0600
Message-ID: <1135207423.3533.88.camel@mulgrave>
References: <1135205667.3533.79.camel@mulgrave>
	 <Pine.LNX.4.64.0512211508500.4827@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:7312 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964970AbVLUXXz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2005 18:23:55 -0500
In-Reply-To: <Pine.LNX.4.64.0512211508500.4827@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2005-12-21 at 15:09 -0800, Linus Torvalds wrote:
> > Hopefully these are the final two bug fixes before 2.6.15 (hint, hurry
> > up!).
> 
> Heh. That's a new strategy. Not "ok, we're now as bug-clean as we can be", 
> but instead the "please please release soon, so that we won't have time to 
> fix anything else" ;)

Well practically, we're never bug free.  What happens is that as the
tree stabilises, the arrival rate of the critical bugs increases fairly
exponentially.  I measure this interval to be about 6 days now, so if
you release a kernel in the next six days I won't have to run around
like a mad thing trying to delay the kernel so I can QA and submit the
bug fix, whatever it is.

Of course, if you want to wait for all the critical bug fixes, there'll
be one in six days ... then twelve days after that ... then twenty
four ...

James


