From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] check non-scsi part of status in
	scsi_status_is_good
Date: 30 Oct 2003 09:35:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067531731.4250.11.camel@pathost1.iomegacorp.com>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:40649 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262617AbTJ3Qfs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 11:35:48 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: patmans@us.ibm.com, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

> > With the patch, the MODE SENSE page 3f len 4 fails, so we try a MODE SENSE
> > page 0 len 4 and it hangs ...
> > If the first MODE SENSE were 10 bytes your device would probably work OK,
> > but per comments in sd.c, we should not increase this. 
> > 
> > But, the 2.4 code used only a 255 byte MODE SENSE request. ...
>
> IMO, this is exactly the sort of thing that has been causing us so much 
> pain.  Some device doesn't accept the standard commands, dies when it gets 
> them, and will only work with some idiosyncratic combination of 
> parameters.
> 
> I can't think of any way to deal with this other than special-purpose 
> per-device code, the simplest of which is blacklisting.

Not idiosyncratic, if in fact -y "5A 00 08:00:00:00 00 00:1C 00" -i x1C
does work.

If that test works, then instead here we have a quiet unwitting
insistence that all hosts fit within the narrow, massively-distributed,
binary-code-only Windows redefinition of SCSI, as opposed to the dreamy
fiction published at t10.org and elsewhere.

I feel sympathy for the device because from 1994 to 1999 for pay I wrote
device firmware.  I never wrote anything this broken only because I
wrote my own tests to step outside of what Windows tries.  Because I was
writing my own tests in confidence, I did ship misinterpretations where
my initial understanding of the merely English specifications differed
from what turned out to be the more broadly accepted understanding.

As far as I know, all the companies who have tried to write such tests
for pay have gone out of business after a few years.

Pat LaVarre


