From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/14] qla2xxx: Modified the driver to pass the
 residaul UNDERRUN status
Date: Wed, 29 Jul 2009 14:07:26 -0500
Message-ID: <1248894446.3900.167.camel@mulgrave.site>
References: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
	 <1248890643-761-2-git-send-email-giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48112 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbZG2THa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 15:07:30 -0400
In-Reply-To: <1248890643-761-2-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: giridhar.malavali@qlogic.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Ravi Anand <ravi.anand@qlogic.com>

On Wed, 2009-07-29 at 11:03 -0700, giridhar.malavali@qlogic.com wrote:
> From: Ravi Anand <ravi.anand@qlogic.com>
> 
> to application for vendor specific commands.

This is a strange changelog, as is this:


> From: Santosh Vernekar <santosh.vernekar@qlogic.com>
> 
> lost.
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>

Could you redo the change logs so they're correct.  Also separating the
changelog from the signed-off-by by a single empty line is the current
convention.

Thanks,

James


