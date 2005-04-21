From: "Drew Winstel" <DWinstel@Miltope.com>
Subject: RE: Perform uncached reads on SCSI drives?
Date: Thu, 21 Apr 2005 16:41:42 -0500
Message-ID: <66F9227F7417874C8DB3CEB0577274170450FD@MILEX0.Miltope.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from firewall.miltope.com ([208.12.184.221]:43892 "EHLO
	smtp.miltope.com") by vger.kernel.org with ESMTP id S261182AbVDUVlE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 17:41:04 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: "Linux-scsi (E-mail)" <linux-scsi@vger.kernel.org>

Hello, Patrick, and thanks for the reply.

>You could try setting read cache disable, I don't know if that setting
>must be honored, or how ATA/SATA handle it. See mode page 8 for SCSI block
>commands. 

Hmm, that's definitely worth a shot.  I'll try it and let you know how it
works.

>The sg utilities sg_modes can probably set it.

As would the new sdparm, I imagine.  

>Better yet, do IO to more locations on the disk, not just the very
>beginning and the very end.

In our seek tests, we do (in order) full-stroke, one-third capacity, and random
seeks.  The random seeks appear to be reasonably well-behaved, although still 
lower than what we're used to seeing (read time is roughly 75% of the seek time 
on an average of four runs of 100 seeks each).  

>-- Patrick Mansfield

Drew
