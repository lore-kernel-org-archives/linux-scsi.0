From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 14 Nov 2003 10:50:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068832232.5539.69.camel@patrh9>
References: <Pine.LNX.4.44L0.0311141058290.1090-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:43489 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264614AbTKNRvL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:51:11 -0500
In-Reply-To: <Pine.LNX.4.44L0.0311141058290.1090-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

All clear now, thanks.

> we lose the ability to tell if a compliant
> device/media is write-protected.

Yes.

> different versions of Windows were so incompatible they 
> often couldn't communicate among themselves.

Yes.

> CDs, DVDs, etc. present their own set of problems.  For the moment I'm
> just concerned about disk-type devices, and the only reliable way I can
> see to deal with them is to avoid sending any MODE-SENSE commands over
> USB.

I'll stay tuned to see if eventually we choose to break sd write-protect
for the sake of blacklisting mode sense in ATAPI and 1394 as well.

Pat LaVarre


