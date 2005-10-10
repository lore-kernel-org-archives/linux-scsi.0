From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Sun, 9 Oct 2005 22:05:54 -0700
Message-ID: <20051010050554.GA5822@us.ibm.com>
References: <20051005231912.79866.qmail@web31807.mail.mud.yahoo.com> <1128647235.4623.28.camel@mulgrave> <4346EA4C.3020602@adaptec.com> <1128781859.4824.14.camel@mulgrave> <4349448F.6040309@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:35539 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932345AbVJJFFy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Oct 2005 01:05:54 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id j9A54fkj011384
	for <linux-scsi@vger.kernel.org>; Mon, 10 Oct 2005 01:04:41 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j9A56ZkZ543318
	for <linux-scsi@vger.kernel.org>; Sun, 9 Oct 2005 23:06:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j9A55mXE027809
	for <linux-scsi@vger.kernel.org>; Sun, 9 Oct 2005 23:05:49 -0600
Content-Disposition: inline
In-Reply-To: <4349448F.6040309@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, ltuikov@yahoo.com, Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

Luben Tuikov <luben_tuikov@adaptec.com> wrote:
> On 10/08/05 10:30, James Bottomley wrote:
> > But it doesn't represent a SCSI domain; it represents a particular type
> > of SCSI domain (as you say yourself, SAS or SATA).  I'm trying to eject
> 
> That's true.
> 
> > transport specific knowledge from the mid-layer, so a domain device that
> > would be used in the mid-layer should be capable of representing any
> > SCSI domain (FC/SPI/SBP etc ..).  I suppose in the worst case, anything
> > that comes back to the mid-layer from the transports should be relevant
> > to at least two separate transports.
> 
> struct scsi_domain_device { ... }; (to be created) is your friend.
> 
> The only way that that design
> 	"should be capable of representing any 
> 	 SCSI domain (FC/SPI/SBP etc ..)"
> 
> Is if it _does not_ have any knowlege about the underlying
> physical domain -- just as it is shown in SAM (and that is the whole point).
> Else you get in this neverending cat-and-mouse game.  If you have the
> abstraction right, then whatever new transport comes along, it would
> be properly represented.
> 
> > Let Jeff come up with the incorporation scheme and see how it looks.
> 
> Hmm, I haven't seen or heard anything from Jeff.  Have you?
> 
> I have no idea what his plans are.  If the idea is to create
> struct scsi_domain_device { ... }; and start from there,
> then I'd like to be involved since this was what I'd wanted
> for SCSI since 2002.
> 

I would also be interested in the incorporation work. I have been running
Luben's patches on a couple of x460s. I was also reading, hacking, and
experimenting on the two sas classes to understand them better and would
like to help if I can.

-andmike
--
Michael Anderson
andmike@us.ibm.com
