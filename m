From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: queue depth help!!
Date: 27 Dec 2003 15:46:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072561593.1757.48.camel@mulgrave>
References: <3FF514CE@webmail.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:33940 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264605AbTL0Vql (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Dec 2003 16:46:41 -0500
In-Reply-To: <3FF514CE@webmail.colostate.edu>
List-Id: linux-scsi@vger.kernel.org
To: jshankar <jshankar@CS.ColoState.EDU>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2003-12-27 at 15:38, jshankar wrote:
> if the scsi target queue depth is 1, does it mean that i can handle only one
> outstanding command  at a time.

Yes

> Does it mean if another command is issued( queue depth=1), it has to wait till
> the previous command is done.

Yes.

The mid-layer will start the queued command as soon as the one occupying
the device returns...this is often why untagged devices actually set
their depth to 2 so they can have another command all prepared and ready
to roll as soon as the in-progress one returns.

James


