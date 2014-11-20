From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Add Intel Multi-Flex to scsi scan blacklist
Date: Thu, 20 Nov 2014 06:08:43 -0800
Message-ID: <20141120140843.GB13685@infradead.org>
References: <1416338612.13492.17.camel@hfg-karlsruhe.de>
 <20141120064606.GB5928@infradead.org>
 <20141120121058.Horde.TOmtlQZW4WfH4rWoXm9iVg3@webmail.hfg-karlsruhe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaKTOIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 09:08:44 -0500
Content-Disposition: inline
In-Reply-To: <20141120121058.Horde.TOmtlQZW4WfH4rWoXm9iVg3@webmail.hfg-karlsruhe.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christian.suenkenberg@hfg-karlsruhe.de
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, Nov 20, 2014 at 12:10:58PM +0100, christian.suenkenberg@hfg-karlsruhe.de wrote:
> Hello,
> 
> On Wed, 19 Nov 2014 22:46:06 -0800, Christoph Hellwig wrote:
> >Looks reasonable.  Btw, that is the Intel Multi-Flex? A search seems to
> >b pointing to ethernet switches..
> 
> it's a volume manager / multiplexer that comes with the Intel Modular
> Server Chassis (MFSYS25 / MFSYS35 / MFSYS25V2). It allows you to create
> RAID volumes on a shared storage controller and attach them to up to
> six compute blades. Compute blades then see the volumes as LUs of an
> Intel Multi-Flex device attached to their LSI SAS 1064E.
> 
> I'd also like to ask whether this patch could land in stable,
> as one needs a very patient initramfs or rootdelay at the moment
> to boot distributions post Linux 3.6 on these machines.

Yes, this should go into -stable.
