From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Fri, 4 Jul 2014 20:14:28 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B86718@G9W0745.americas.hpqcorp.net>
References: <1404474875-109997-1-git-send-email-hare@suse.de>
 <1404474875-109997-2-git-send-email-hare@suse.de>
 <53B70404.9080303@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:52293 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaGDUSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 16:18:42 -0400
In-Reply-To: <53B70404.9080303@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Douglas Gilbert
> Sent: Friday, 04 July, 2014 2:44 PM
> To: Hannes Reinecke; James Bottomley
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
> 
> On 14-07-04 07:54 AM, Hannes Reinecke wrote:
> > SCSI-2 defines only up to 256 LUNs with a flat namespace.
> 
> My SCSI-2 draft (revision 10b from August 1989) only has
> 3 bit LUNs placed in byte 1 of the command block, in the top
> 3 bits. There are also things called LUNTARs and LUNTRNs
> at the message level.
> 
> 8 bit LUNs do ring a distant bell, perhaps after SCSI-2?
> 
> Doug Gilbert

The hierarchical LUN structures have some limited size
LUN subfields:
* the peripheral device addressing method includes an 8-bit 
  TARGET OR LUN subfield, which specifies an 8-bit LUN at the 
  current level (if the BUS IDENTIFIER field is 0)
* the logical unit addressing method has a 5-bit LUN subfield


---
Rob Elliott    HP Server Storage



