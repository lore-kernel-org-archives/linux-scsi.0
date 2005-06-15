From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Wed, 15 Jun 2005 16:17:42 +0100
Message-ID: <20050615151742.GA24061@infradead.org>
References: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:18404 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261163AbVFOPRo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 11:17:44 -0400
Content-Disposition: inline
In-Reply-To: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, haren@us.ibm.com, gregkh@suse.de

On Wed, Jun 15, 2005 at 10:15:22AM -0500, brking@us.ibm.com wrote:
> 
> 
> James,
> Haren found this in some recent kexec testing. Without this fix, the
> ipr adapter's write cache never gets flushed. I'd like to see this
> pushed into 2.6.12 if possible.

Umm, there's tons of other drivers doing this. Greg, please revert
your pci-layer ->shutdown thing for 2.6.12 and make convert all drivers
when re-introducing it.  Or even better make sure it doesn't break
drivers setting ->shutdown themselves.

