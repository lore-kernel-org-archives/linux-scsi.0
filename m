From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [ADVANSYS] Add basic highmem/DMA support
Date: 24 Jun 2004 08:00:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088082044.1959.2.camel@mulgrave>
References: <20040508003906.GA26338@gondor.apana.org.au>	<20040519103800.GA9891@gondor.a
	pana.org.au>	<1086026538.2004.7.camel@mulgrave>
	<40D69F56.2000307@torque.net>	<1087828082.1797.17.camel@mulgrave>
	<40D924A5.5020705@torque.net> 	<20040623141335.GA23365@infradead.org>
	<1088005899.1639.9.camel@mulgrave>  <40DAC485.2090404@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:23710 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264461AbUFXNBD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 09:01:03 -0400
In-Reply-To: <40DAC485.2090404@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>, Gene Heskett <gene.heskett@verizon.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-06-24 at 07:09, Douglas Gilbert wrote:
> Your patch fixed the PCI wide problem. The attached incorporates
> your fix and also fixes the ISA oops. So now all my advansys cards
> work.

Well, damn, I was afraid of that.

Unfortunately, that patch working is a symptom of deep malaise within
the driver.  It means that these segments are used in some way in its
internals and virt_to_bus and bus_to_virt translations occur all over
it.  It also means that the DMA API conversion really isn't effective.

James


