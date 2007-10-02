From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: fix SSP IU status print-out
Date: Tue, 02 Oct 2007 09:46:13 -0500
Message-ID: <1191336373.3530.62.camel@localhost.localdomain>
References: <20070930140317.GA7134@havoc.gtf.org>
	 <4702399A.9010708@garzik.org>
	 <1191334857.3530.39.camel@localhost.localdomain>
	 <47025743.3070100@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54592 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751151AbXJBOqO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 10:46:14 -0400
In-Reply-To: <47025743.3070100@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2007-10-02 at 10:35 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > On Tue, 2007-10-02 at 08:29 -0400, Jeff Garzik wrote:
> >> James, what is the upstream status of my two aic94xx bug fixes?
> >>
> >> Have they been sent to Linus yet?
> >>
> >> Since you seem M.I.A., I'll send them upstream if I do not hear from you 
> >> today.
> > 
> > They're hardly -rc8 critical bug fixes, since no-one has noticed their
> > effects for about 5 kernel releases.  I'll stick them into scsi-misc
> > with the rest of the pending stuff.
> 
> Except for those people who want SMP to work, on platforms where 
> TODEVICE actually matters.

And the number of bug reports on this?

> I'll send them upstream myself.

No, you won't; because that would be completely irresponsible.  You
don't turn code for no reason at the last minute unless it's essential
because of the danger of introducing inadvertent bugs along with the
changes.  Since there are no users affected, there's zero benefit and
there is a potential non-zero detriment to the code turn.

There's absolutely no reason to rush these into the release at the last
minute.  The correct path is via scsi-misc and then to be backported
into the stable series once we're sure they're OK.

> > And going away for the Weekend is hardly MIA.
> 
> A week has gone by since any SCSI commit, and longer than that if you 
> actually look at the send-date of the most recent patch applied.

If you follow the linux-scsi mailing list, you'll see fairly active
participation after that, I think.

James


