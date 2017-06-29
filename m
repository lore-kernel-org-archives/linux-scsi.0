From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 3/3] cxlflash: Update debug prints in reset handlers
Date: Thu, 29 Jun 2017 07:58:56 +0200
Message-ID: <bd2f0bf6-b63a-ad7d-89fc-e6fbe19a2494@suse.com>
References: <1498669929-39684-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1498670077-39845-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:55475 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdF2F7A (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Thu, 29 Jun 2017 01:59:00 -0400
In-Reply-To: <1498670077-39845-1-git-send-email-mrochs@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 06/28/2017 07:14 PM, Matthew R. Ochs wrote:
> The device and host reset handler contain debug prints to help
> identify the entities being reset. Today these reset handlers
> are based on a SCSI EH design that uses a SCSI command reference
> as a means of identifying the target entity. As such, the debug
> trace includes the SCSI command pointer and associated CDB. This
> is not necessary as the SCSI command is simply the messenger in
> these scenarios.
> 
> Refactor the debug prints in the host and reset handlers to only
> present information that is applicable given the function scope.
> 
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/main.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
