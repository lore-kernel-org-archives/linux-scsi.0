From: "James Daniel" <jdaniel@dakotacom.net>
Subject: [FIXED] Initio 9100u -- It lives
Date: Sun, 21 Dec 2003 04:09:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000b01c3c7b2$e815e140$0200000a@nightsky>
References: <Pine.LNX.4.44.0312190311160.27880-200000@dyn319634.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from breaker.dakotacom.net ([66.192.152.146]:34226 "EHLO
	breaker.dakotacom.net") by vger.kernel.org with ESMTP
	id S262714AbTLULI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Dec 2003 06:08:27 -0500
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

> On Fri, 19 Dec 2003, Mike Christie wrote:
> 
> > Ok, in the orginal patch I forgot to replace the shared buffer with a 
> > DMA-API equiv. This will take some time.
> > 
> 
> Here is another try. It should compile against 2.6.0-test11/2.6.0.

It appears to be working again. Mad props.

The card has left my server, however. I dug up a 2940u2w.
The ini9100u now resides in a test box which is still actively
using the card and actually has a monitor permanently attached,
so I'll be able to do much better diagnostics on it now. Currently
it's loaded as a module, not being used for root fs, and is reading
the drive attached to the card quite nicely. As soon as I have a
distro running 2.6 running a root partition via scsi, I'll be sure
to let the list know how it goes.

Thanks Mike =)

