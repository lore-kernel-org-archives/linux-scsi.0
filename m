From: Matthew Jacob <mjacob@feral.com>
Subject: Re: qla2xxx and feral ISP updates in their respective BK trees
Date: Fri, 20 Jun 2003 10:25:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030620102448.O305@wonky.in0.lcl>
References: <1055971780.2075.484.camel@mulgrave>  <20030620101224.B305@wonky.in0.lcl>
 <1056129548.2102.19.camel@mulgrave>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from beppo.feral.com ([192.67.166.79]:19212 "EHLO beppo.feral.com")
	by vger.kernel.org with ESMTP id S263633AbTFTRMy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 13:12:54 -0400
In-Reply-To: <1056129548.2102.19.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <praka@san.rr.com>, Andrew Morton <akpm@digeo.com>



> On Fri, 2003-06-20 at 12:12, Matthew Jacob wrote:
> > HPMC?
>
> High Priority Machine Check.  They usually occur if the driver pokes a
> non-existent register using I/O cycles, or a DMA transfer overruns or
> something.  The parisc platform I use has an IOMMU as well.

Oh- is parisc like PPC and doesn't really support io space? That is,
prefers memory mapped registers?

-matt

