From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/4] ibmvscsi: Send adapter info before login
Date: Mon, 08 Jun 2009 15:09:33 -0500
Message-ID: <1244491773.4079.595.camel@mulgrave.site>
References: <200906031454.n53EsIr8011153@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52114 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbZFHUJf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 16:09:35 -0400
In-Reply-To: <200906031454.n53EsIr8011153@d01av04.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, rcjenn@linux.vnet.ibm.com

On Wed, 2009-06-03 at 09:54 -0500, Brian King wrote:
> The ibmvscsi driver currently sends the SRP Login before sending the Adapter
> Info MAD, which can result in commands getting sent to the virtual adapter
> before we are ready for them. This results in a slight window where the target
> devices may not behave as expected. Change the order and close the window.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ibmvscsi/ibmvscsi.c |  173 +++++++++++++++++++--------------------
>  1 file changed, 85 insertions(+), 88 deletions(-)

This one just doesn't want to apply:

patching file drivers/scsi/ibmvscsi/ibmvscsi.c
Hunk #4 FAILED at 961.
Hunk #5 succeeded at 1279 (offset -3 lines).
Hunk #6 succeeded at 1289 (offset -3 lines).
1 out of 6 hunks FAILED -- saving rejects to file
drivers/scsi/ibmvscsi/ibmvscsi.c.rej

Could you check scsi-misc and see what's up?

Thanks,

James


