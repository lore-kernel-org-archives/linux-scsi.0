From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: qla2xxx and feral ISP updates in their respective BK trees
Date: 20 Jun 2003 12:19:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056129548.2102.19.camel@mulgrave>
References: <1055971780.2075.484.camel@mulgrave>
	<20030620101224.B305@wonky.in0.lcl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:60932 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263535AbTFTRFR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 13:05:17 -0400
In-Reply-To: <20030620101224.B305@wonky.in0.lcl>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <praka@san.rr.com>, Andrew Morton <akpm@digeo.com>

On Fri, 2003-06-20 at 12:12, Matthew Jacob wrote:
> HPMC?

High Priority Machine Check.  They usually occur if the driver pokes a
non-existent register using I/O cycles, or a DMA transfer overruns or
something.  The parisc platform I use has an IOMMU as well.

James


