From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: queue depth help!!
Date: 31 Dec 2003 10:26:56 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072888017.1893.2.camel@mulgrave>
References: <3FF4A594@webmail.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:11733 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265196AbTLaQ1F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 11:27:05 -0500
In-Reply-To: <3FF4A594@webmail.colostate.edu>
List-Id: linux-scsi@vger.kernel.org
To: jshankar <jshankar@CS.ColoState.EDU>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2003-12-31 at 10:23, jshankar wrote:
> On issuing a scsi command write, does the  data needs to be written 
> succesfully 
> to disk before issuing a scsi response. Is there a chance that the previous 
> command's data is still cached on scsi controller and the next command issued 
> is executed.

That depends on the drive cache setting.  For a write back cache,
no--status will be sent before the command reaches the medium (as long
as the FUA bit isn't set); for all other cache settings, yes.

> Please let me know if there are any  good tools for scsi analyzer.

I don't actually have one of these, so I'll let others answer...

James


