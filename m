From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] sdev_printk for ULDs, example with sd
Date: 22 Jan 2004 15:08:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074802104.1877.58.camel@mulgrave>
References: <200401191355.37522.dsteklof@us.ibm.com>
	<200401221144.48488.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:54218 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266320AbUAVUI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 15:08:27 -0500
In-Reply-To: <200401221144.48488.dsteklof@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Daniel Stekloff <dsteklof@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-01-22 at 14:44, Daniel Stekloff wrote:
> In my recent post concerning sdev_printk I mentioned sdev_printk was useful 
> for the mid-layer and LLDs. The macro is also useful for Upper Level Drivers 
> as well. He's a patch adding sdev_printk to sd. Sample output includes:

Well, the thing about this is that it's a slippery slope that leads into
posix logging.  This recently came up in network as well (for
netdev_printk()):

http://marc.theaimsgroup.com/?t=107454443000004&r=1&w=2

The principle is sound, but I think the framework for doing it would
have to cross all subsystems and be nicely extensible.  I'd really like
to see us have some idea of the back end infrastructure before we do
something that we'll then have to change again.

James


