From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: 13 Jun 2004 12:21:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087150872.18099.27.camel@patibmrh9>
References: <1086710016.3647.4.camel@patibmrh9><40C8FB79.1050706@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:31707 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265237AbUFMSVY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2004 14:21:24 -0400
In-Reply-To: <40C8FB79.1050706@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

Willem R:

> > ide-scsi ... usb-storage .... sbp2 ...
> > technical complex ...
>
> ... actually works very well for me currently.
> (That's not to say there couldn't still be
> issues with other hardware). If you have
> specific problems I'll be happy to try and
> help.

ide-scsi trouble is now interesting again, if observed since 2.6.5,
especially if observed with ATAPI devices other than DVD/ CD.

is my guess of what we mean after reading this thread and the discussion
of ide-scsi changes at:

http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.5

> > From: Douglas Gilbert ...
> > ...
> > In lk 2.6 the ide-scsi driver
> > is "deprecated" for cd/dvd device types
> > but not other device types
> > that use the ATAPI protocol.

Thank you I needed that education.  Therefore another advantage for PDT
x05 among RMB is that SCSI pass thru started working earlier in lk 2.6.

Pat LaVarre


