From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] 2.5.73 add mode sense 10 byte to aacraid driver
Date: Wed, 25 Jun 2003 14:16:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030625181609.GA1804@gtf.org>
References: <1056561660.747.7.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:37823
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S264870AbTFYSB6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2003 14:01:58 -0400
Content-Disposition: inline
In-Reply-To: <1056561660.747.7.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jun 25, 2003 at 10:21:00AM -0700, Mark Haverkamp wrote:
> The aacraid driver didn't have a case for the 10 byte mode sense
> command.  This was causing the driver to fail.  I added a case in
> aac_scsi_cmd for the 10 byte mode sense.  I also replaced the aacraid
> definitions for scsi commands with the ones from scsi.h.  I have tested
> this on my aacraid hardware here at osdl.
> 
> ===== drivers/scsi/aacraid/aachba.c 1.17 vs edited =====
> --- 1.17/drivers/scsi/aacraid/aachba.c	Thu Jun 19 17:06:21 2003
> +++ edited/drivers/scsi/aacraid/aachba.c	Wed Jun 25 08:24:48 2003

In addition to James's comments...

Please separate the cleanup (private -> scsi.h constants)
from the MODE SENSE 10 stuff, into two separate patches.

That way we can apply the cleanup, while discussioning the other stuff.

	Jeff



