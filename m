From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] correct SCSI_WAIT_SCAN selection for non-modular SCSI_SCAN_ASYNC builds.
Date: Tue, 20 Mar 2007 12:48:16 -0700
Message-ID: <20070320194816.GB23476@dmccrory-d810.qlogic.org>
References: <20070320185632.GB22866@dmccrory-d810.qlogic.org> <1174417867.3522.35.camel@mulgrave.il.steeleye.com> <20070320191940.GB23330@dmccrory-d810.qlogic.org> <1174419153.3522.41.camel@mulgrave.il.steeleye.com> <1174419844.3522.44.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:15615 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbXCTTtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 15:49:20 -0400
Content-Disposition: inline
In-Reply-To: <1174419844.3522.44.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 20 Mar 2007, James Bottomley wrote:

> On Tue, 2007-03-20 at 14:32 -0500, James Bottomley wrote:
> > Is MODULE set to 'n'?  It looks like the symbol export is guarded by
> > #ifdef MODULE for some reason ... other than that, I can't explain this.
> 
> In fact, that's the bug ... the modular config is MODULES not MODULE.
> Can you try this:

Ahh, that makes sense.  Your patch fixes the mis-compilation.

Thanks,
Andrew Vasquez
