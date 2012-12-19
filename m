From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 0/2] Change type-2 dif to use rq embedded 32 byte cdb
Date: Wed, 19 Dec 2012 17:28:45 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40294CD1339A@G9W0745.americas.hpqcorp.net>
References: <201212191034.qBJAY3gk007148@d01av04.pok.ibm.com>
 <yq1fw327zi5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:21465 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab2LSR3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2012 12:29:47 -0500
In-Reply-To: <yq1fw327zi5.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Scott Guthridge <guthridg@us.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen
> Sent: Wednesday, 19 December, 2012 10:56 AM
> To: Scott Guthridge
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 0/2] Change type-2 dif to use rq embedded 32 byte cdb
> 
> >>>>> "Scott" == Scott Guthridge <guthridg@us.ibm.com> writes:
> 
> Scott,
> 
> Scott> I don't know if the reason that "sd" went with the mempool for
> Scott> 32-byte commands was binary compatibility with modules, concerns
> Scott> about memory usage on small/embedded systems, or both.
> 
> The latter. Type 2 is an edge case and we didn't want to penalize
> everybody on the planet by doubling the default command size.
> 
> 
> Scott> All of the SCSI drives we're seeing now come from the vendor
> Scott> formatted with PI type 2.  Linux automatically detects the format
> Scott> and uses PI, so it's no longer a corner case -- it's now the
> Scott> normal case.
> 
> Drives don't come as Type 2 by default. You have to ask for them to be
> formatted that way. All the drives we ship at Oracle are Type 1.
> 

And all the SCSI drives we ship at HP have no DIF whatsoever.

Same for all ATA drives from all companies, since DIF isn't even defined in ATA, and all USB drives (although SCSI based, the consumer market doesn't use this feature).

---
Rob Elliott    HP Server Storage



