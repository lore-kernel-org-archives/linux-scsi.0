From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] 2.6 aacraid: Fix for controller load based timeouts
Date: Fri, 8 Jul 2005 14:00:01 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01642D18@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:47795 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262738AbVGHSBa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2005 14:01:30 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ryan@autoweb.net, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Martin Drab <drab@kepler.fjfi.cvut.cz>

Yes containers will go offline, but this fix is for a recent change to
the driver; if it was 6 months ago, it was a totally different problem.
You probably can resolve your problems by making sure you have the
latest Firmware. I don't believe there are any changes in the driver in
the past 6 months that would have worked around any
Firmware/Hardware/Compatibility issues.

Sadly, anything that goes wrong (including card, power supply, drives)
can cause containers to go offline; it is a pretty generic symptom to a
multitude of possible problems. Martin's initial problems were
associated with using the WD JD drives, which are not compatible with
RAID cards because their internal error recovery paths.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Ryan Anderson [mailto:ryan@autoweb.net] 
Sent: Friday, July 08, 2005 1:42 PM
To: Mark Haverkamp
Cc: James Bottomley; Salyzyn, Mark; linux-scsi; Martin Drab
Subject: Re: [PATCH] 2.6 aacraid: Fix for controller load based timeouts

On Fri, 2005-07-08 at 10:36 -0700, Mark Haverkamp wrote:
> Martin Drab found that he could get aacraid timeouts with high load on
> his controller / disk drive combinations.  After some experimentation
> Mark Salyzyn has come up with a patch to reduce the default
max_sectors
> to something that will keep the controller from being overloaded and
> will eliminate the timeout issues.

Would hitting this timeout issue cause the container to go offline?

If so, I think this may fix the issues I was having 6 months ago.  (We
ended up taking the aacraid controller out of our production
environment, in frustration.)

I'll try to get some testing time in on this next week, though, the
problems I've run into were very hard to reproduce on demand.

-- 
Ryan Anderson
AutoWeb Communications, Inc.
email: ryan@autoweb.net

