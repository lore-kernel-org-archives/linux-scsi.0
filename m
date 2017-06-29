From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 2/3] cxlflash: Update send_tmf() parameters
Date: Thu, 29 Jun 2017 07:58:39 +0200
Message-ID: <9145e63e-ba23-0dee-c3e2-953a735f1543@suse.com>
References: <1498669929-39684-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1498670070-39805-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:35506 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdF2F6m (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Thu, 29 Jun 2017 01:58:42 -0400
In-Reply-To: <1498670070-39805-1-git-send-email-mrochs@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 06/28/2017 07:14 PM, Matthew R. Ochs wrote:
> The current send_tmf() implementation is based on the caller providing
> a SCSI command reference. In reality all that is needed is a SCSI device
> reference as the routine uses a private command.
> 
> Refactor send_tmf() to pass the private adapter configuration reference
> and a SCSI device reference. As a nice side effect, this will ease the
> burden of converting caller routines to be based solely off of a SCSI
> device reference.
> 
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/main.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
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
