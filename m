From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [ADVANSYS] Add basic highmem/DMA support
Date: 21 Jun 2004 09:28:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087828082.1797.17.camel@mulgrave>
References: <20040508003906.GA26338@gondor.apana.org.au>
		<20040519103800.GA9891@gondor.apana.org.au>
	<1086026538.2004.7.camel@mulgrave>  <40D69F56.2000307@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:51919 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266257AbUFUO20 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 10:28:26 -0400
In-Reply-To: <40D69F56.2000307@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Gene Heskett <gene.heskett@verizon.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Mon, 2004-06-21 at 03:41, Douglas Gilbert wrote:
> I just tested it in lk 2.6.7-bk2 and the advansys driver is
> broken. The disk access light stays on for several seconds
> while it tries to read the partition table after which it
> announces "unknown partition table". Since my rootfs is on
> that disk it's all downhill from there.

To be sure: the inquiry goes through and produces the correct result,
and the read capacity, but then the read partition table fails?

If so, I think that sounds like a failure in the use_sg != 0 path.

James


