From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 0/3] Fix 3ware irq handling
Date: Wed, 02 Mar 2005 02:18:39 -0500
Message-ID: <422568CF.3060307@pobox.com>
References: <20050224015859.55191.qmail@web40910.mail.yahoo.com> <421D3D33.9060707@pobox.com> <20050226193255.GA6256@ime.usp.br> <4220D9DE.10904@pobox.com> <42234279.6030004@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:48349 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262208AbVCBHS4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 02:18:56 -0500
In-Reply-To: <42234279.6030004@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, linuxraid@amcc.com
Cc: Mark Lord <liml@rtr.ca>

Mark Lord wrote:
>  >"irq XX: nobody cared" is a screaming interrupt situation, which could 
> have 1001 causes.
> 
> Speaking of which.  The 3ware drivers appear to have a bug
> in their handling of this.  They *always* report "handled=1"
> from their interrupt routines, regardless of whether it was
> their hardware or not that was signalling for attention.

Thanks for pointing this out, Mark.

What follows is a patch series to clean this up:

patch 1: only report IRQ_HANDLED when needed
patch 2: remove bogus "my irq == my irq" test
patch 3: fix indentation, after patch #2's change

