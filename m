From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [BK PATCH] SCSI updates for 2.6.11
Date: Wed, 16 Mar 2005 15:31:19 -0500
Message-ID: <42389797.7000004@pobox.com>
References: <1110934411.5685.39.camel@mulgrave> <42387C7C.9040407@pobox.com> <1111003679.5635.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:58775 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262786AbVCPUbx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 15:31:53 -0500
In-Reply-To: <1111003679.5635.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Wed, 2005-03-16 at 13:35 -0500, Jeff Garzik wrote:
> 
>>Are my 3ware bugfixes in the queue?  Currently 3ware claims it handled 
>>the interrupt, even the interrupt is a shared one and the event was 
>>meant for another driver.
> 
> 
> Not in my queue ... you could try Adam Radford directly ...

More info?  Were they dropped on purpose, or just never arrived?
If dropped on purpose, what was the reason?

http://marc.theaimsgroup.com/?l=linux-scsi&m=110974795732192&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=110974807701325&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=110974812119775&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=110974869410494&w=2

	Jeff


