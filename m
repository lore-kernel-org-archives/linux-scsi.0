From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b4).
Date: Fri, 18 Jul 2003 14:53:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EC80@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:10810 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S271846AbTGRViw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 17:38:52 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

Lars,

> Please come and attend the multipath session at the Kernel Summit
> and/or the Ottawa Linux Symposium next week to learn why this is a
> bad idea and how it can be done better ->
> http://www.linuxsymposium.org/
> 

I would have really liked to be in Ottawa for the kernel-summit.
Unfortunately, the earliest I can arrive is on Tuesday night.  BTW:
Duane Grigsby (from QLogic), will also be attending.  I look forward
to the event.

> However, for backwards compatibility with 2.4, I assume it might
> still be needed in 2.5/2.6, but _only_ with the clear intend of
> phasing it out within 2.6 and dropping it in 2.7.
> 
> QLogic is reasonably good already in that it can be disabled via a
> module parameter (ql2xfailover=0), allowing the higher level
> solutions to operate.
> 

I believe that will have to be the best we can offer, for those that
do not want failover functionality, just disable it.

Regards,
Andrew Vasquez
