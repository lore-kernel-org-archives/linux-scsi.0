From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 06/21] lpfc: Fix host reset escalation killing all IOs.
Date: Sat, 07 Mar 2015 08:56:34 -0800
Message-ID: <1425747394.2969.8.camel@HansenPartnership.com>
References: <1423164232.7917.30.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41863 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbbCGQ4f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2015 11:56:35 -0500
In-Reply-To: <1423164232.7917.30.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2015-02-05 at 14:23 -0500, James Smart wrote:
> ---

This one really requires more than a one-line explanation because the
one liner doesn't really describe what you've done.

It looks like the description should be:

Only the SLI rev 4 card has a host reset capability, so only activate it
in the host template for that card.

Which leads me to two questions:

     1. Is the if condition the right way around?  It seems from the
        previous code that SLI rev < 4 do support a host reset handler.
        At the very least, if the if clause is correct, explain how it
        relates to 27b01b8 [SCSI] lpfc 8.3.31: Fixed system crash due to
        not providing SCSI error-handling host reset handler.
     2. Is this only a problem of SLI rev 4, so == is justified, or
        should it be 4 and above?

James


