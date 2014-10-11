From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: Concurrent SG_SCSI_RESET ioctls
Date: Sat, 11 Oct 2014 22:06:47 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CEB20A@G4W3202.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
 <20141011161110.GA16812@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:33939 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaJKWJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Oct 2014 18:09:12 -0400
In-Reply-To: <20141011161110.GA16812@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Saturday, 11 October, 2014 11:11 AM
> To: Elliott, Robert (Server Storage)
> Cc: James Bottomley (jbottomley@parallels.com); Christoph Hellwig;
> dgilbert@interlog.com; linux-scsi@vger.kernel.org; Don Brace (PMC); Scales,
> Webb
> Subject: Re: Concurrent SG_SCSI_RESET ioctls
> 
> Hi Robert,
> 
> can you take a look at the patches at:
> 
> http://git.infradead.org/users/hch/scsi.git/shortlog/refs/heads/scsi-ioctl
> 
> and confirm if they fix your issue?

Thanks.  That's a bit better, but sg_reset can now run into
"No such device" errors.

sg_reset: starting device reset
sg_reset: starting device reset
sg_reset: SG_SCSI_RESET failed: No such device
sg_reset: completed device (or target or bus or host) reset
sg_reset: starting device reset
sg_reset: completed device (or target or bus or host) reset
sg_reset: starting device reset
sg_reset: completed device (or target or bus or host) reset


---
Rob Elliott    HP Server Storage



