From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: qla2xxx and feral ISP updates in their respective BK trees
Date: 20 Jun 2003 13:17:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056133068.1804.22.camel@mulgrave>
References: <1055971780.2075.484.camel@mulgrave>
	<20030620101224.B305@wonky.in0.lcl> <1056129548.2102.19.camel@mulgrave>
	<20030620102448.O305@wonky.in0.lcl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.114.3.137] ([65.114.3.137]:17925 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263897AbTFTSEY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 14:04:24 -0400
In-Reply-To: <20030620102448.O305@wonky.in0.lcl>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <praka@san.rr.com>, Andrew Morton <akpm@digeo.com>

On Fri, 2003-06-20 at 12:25, Matthew Jacob wrote:
> Oh- is parisc like PPC and doesn't really support io space? That is,
> prefers memory mapped registers?

Well, it does, for PCI (since it's required to by the spec).  However,
the cost of generating an I/O cycle is very high (you essentially go via
some memory mapped registers in the bus controller).  Parisc certainly
prefers memory mapped registers.

James


