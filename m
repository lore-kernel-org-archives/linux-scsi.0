From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Assigning tag values?
Date: Sat, 19 Jul 2003 23:04:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F1A06D0.4040000@pobox.com>
References: <3F174A6D.8050702@pobox.com> <20030718070024.GV833@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:51662 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270609AbTGTCuJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jul 2003 22:50:09 -0400
In-Reply-To: <20030718070024.GV833@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Jens Axboe wrote:
> On Thu, Jul 17 2003, Jeff Garzik wrote:
> 
>>Is there a standard scsi way to assign tag values?
>>
>>Can I use the block layer helpers, or do those not work for scsi?
> 
> 
> Which kernel? In 2.5 you can get the scsi mid layer to do it for you
> (via the block layer helpers), by calling scsi_activate_tcq(scsi_device,
> depth). See scsi_tcq.h and 53c700.c for a working example.


That's what I was looking for, thanks.

for 2.4, multiple people told me "yeah, you have to make up your own tag 
values"

	Jeff



