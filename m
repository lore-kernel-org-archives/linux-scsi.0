From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [ADVANSYS] Add basic highmem/DMA support
Date: Tue, 22 Jun 2004 10:35:34 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D77ED6.3080305@torque.net>
References: <20040508003906.GA26338@gondor.apana.org.au>		<20040519103800.GA9891@gondor.apana.org.au>	<1086026538.2004.7.camel@mulgrave>  <40D69F56.2000307@torque.net> <1087828082.1797.17.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:32261 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S266535AbUFVAgN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 20:36:13 -0400
In-Reply-To: <1087828082.1797.17.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Gene Heskett <gene.heskett@verizon.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

James Bottomley wrote:
> On Mon, 2004-06-21 at 03:41, Douglas Gilbert wrote:
> 
>>I just tested it in lk 2.6.7-bk2 and the advansys driver is
>>broken. The disk access light stays on for several seconds
>>while it tries to read the partition table after which it
>>announces "unknown partition table". Since my rootfs is on
>>that disk it's all downhill from there.
> 
> 
> To be sure: the inquiry goes through and produces the correct result,
> and the read capacity, but then the read partition table fails?

Precisely.

> If so, I think that sounds like a failure in the use_sg != 0 path.

Yes. Grub is installed on the MBR of the SCSI disk in
question so it loads ok. The Advansys 2uw HBA works
ok in lk 2.6.7 but not lk 2.6.7-bk2 . I checked the
disk on another system (with a aic7xxx based controller)
and the disk does have a partition table and works ok.

Doug Gilbert

