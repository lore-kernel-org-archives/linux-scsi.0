From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 13:26:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412E1D3E.2050307@pobox.com>
References: <412DFFA9.8030504@wasp.net.au> <8746466a0408260852205a7842@mail.gmail.com> <412E1039.7030508@pobox.com> <412E135B.1030605@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:43472 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269271AbUHZR0e
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 13:26:34 -0400
In-Reply-To: <412E135B.1030605@wasp.net.au>
List-Id: linux-scsi@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Dave <dave.jiang@gmail.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>

Brad Campbell wrote:
> In which case, these drives need to be knocked back to UDMA66 to 
> function properly on anything later than 2.6.6. Don't know why.
> I have tried multiple drives (I have 5 of them), multiple cables (lots 
> of those) and multiple bridge boards (I have 6 of those). There is no 
> combination that is reliable on the VIA controller with any transfer 
> larger than about 0x80 sectors *OR* speeds greater than UDMA66 *OR* 
> Kernel 2.6.6 or prior.


We could always eliminate lba48 max-sectors increase on VIA controllers...

	Jeff


