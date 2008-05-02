From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
Date: Fri, 02 May 2008 10:03:45 -0500
Message-ID: <1209740625.3121.27.camel@localhost.localdomain>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
	 <20080501142305.77433e50.akpm@linux-foundation.org>
	 <481A3781.8080100@gmail.com>
	 <1209679559.14864.33.camel@localhost.localdomain>
	 <20080501153048.2a8d356f.akpm@linux-foundation.org>
	 <1209740170.3121.24.camel@localhost.localdomain>
	 <481B2CB8.2000307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56072 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756289AbYEBPDs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 11:03:48 -0400
In-Reply-To: <481B2CB8.2000307@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 17:01 +0200, Jiri Slaby wrote:
> James Bottomley napsal(a):
> >>> could we not at least make the machinery do something vaguely
> >>> useful and expand it to confine the pm routines to sections which can be
> >>> discarded if CONFIG_PM is n?
> >> a) it would need to be discarded at link-time, ideally.
> > 
> > Yes, the same way the exit sections are: as linker discards.  We also
> > have the mechanics for runtime discards which is useful for modules
> 
> No it doesn't, exits are discarded at runtime only. At least on x86.

No what doesn't?  I said we have the mechanics to discard both at link
and at run time.

I think you'll find that .exitcall.exit is link time discarded on x86
and the others are runtime discarded.

James


