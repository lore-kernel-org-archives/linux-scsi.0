From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [BK PATCH] SCSI updates for 2.6.11
Date: Wed, 16 Mar 2005 13:35:40 -0500
Message-ID: <42387C7C.9040407@pobox.com>
References: <1110934411.5685.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <1110934411.5685.39.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> This is my current tranch of patches that were waiting the transition
> from -rc to released (sorry it's late ... I've been on holiday).
> 
> The patch is available here:
> 
> bk://linux-scsi.bkbits.net/scsi-for-linus-2.6

Are my 3ware bugfixes in the queue?  Currently 3ware claims it handled 
the interrupt, even the interrupt is a shared one and the event was 
meant for another driver.

	Jeff
