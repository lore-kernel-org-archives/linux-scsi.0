From: Douglas Gilbert <dougg@torque.net>
Subject: Re: problems to expect with >2TB volumes
Date: Wed, 29 Nov 2006 15:55:37 -0500
Message-ID: <456DF3C9.6060004@torque.net>
References: <ekkmug$kmu$1@sea.gmane.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:62612 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S967672AbWK2Uzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Nov 2006 15:55:43 -0500
In-Reply-To: <ekkmug$kmu$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd-schubert@gmx.de>
Cc: linux-scsi@vger.kernel.org

Bernd Schubert wrote:
> Hi,
> 
> we have not bought the device yet, but presently in the process to do so.
> Before we buy it, I want to know about problems in advance...

None that I'm aware of from the point of view of the
Linux SCSI subsystem (starting at about half way through
the lk 2.4 series or 4 years ago).

> I'm somewhat worried about this problem report
> http://lists.freebsd.org/pipermail/aic7xxx/2006-January/thread.html#4280
> Especially as I don't see a final solution... 
> We also want to buy the very same raid device and also connect it to an
> already existing aic79xx controller.

On reviewing that thread, the original poster was
jumping to premature conclusions. Justin Gibbs told
him there was no such problem (and Justin is well
placed to know). Then the final post shows a trace
with READ(10) commands failing. They are 32 bit lba
read operations that have been the default for about
10 years in the SCSI subsystem. If those fail on that
transport it is probably a termination problem.
When Justin saw that he probably didn't bother
responding again.

Doug Gilbert
