From: Anton Blanchard <anton@samba.org>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: Mon, 15 Mar 2004 03:01:33 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314160133.GI19737@krispykreme>
References: <20040314082444.GA3416@linux.local.home> <1079275768.2022.1.camel@mulgrave> <20040314145142.GL6955@suse.de> <1079276396.2022.8.camel@mulgrave> <20040314151809.GG19737@krispykreme> <1079278279.2022.34.camel@mulgrave> <20040314154713.GH19737@krispykreme> <1079279732.2108.40.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:39393 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S263384AbUCNQC6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 11:02:58 -0500
Content-Disposition: inline
In-Reply-To: <1079279732.2108.40.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

 
> Because on this type of failure, the driver will return
> SCSI_MLQUEUE_HOST_BUSY from its queuecommand routine.  This will tell
> the mid layer not to try any more commands for the entire host until an
> outstanding one returns (thus hopefully freeing up enough resources).

That makes sense, it sounds like the qlogic could do that and remove
the SG limit.

Anton
