From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [BK PATCH] SCSI updates for 2.6.11
Date: Wed, 16 Mar 2005 15:07:59 -0500
Message-ID: <1111003679.5635.3.camel@mulgrave>
References: <1110934411.5685.39.camel@mulgrave> <42387C7C.9040407@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:52700 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262777AbVCPUIN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 15:08:13 -0500
In-Reply-To: <42387C7C.9040407@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2005-03-16 at 13:35 -0500, Jeff Garzik wrote:
> Are my 3ware bugfixes in the queue?  Currently 3ware claims it handled 
> the interrupt, even the interrupt is a shared one and the event was 
> meant for another driver.

Not in my queue ... you could try Adam Radford directly ...

James


