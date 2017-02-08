From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v2 08/39] megaraid_sas: megasas_get_request_descriptor
 always return valid desc
Date: Wed, 8 Feb 2017 12:17:05 +0100
Message-ID: <52412297-76f1-f585-c843-e745c166f8a2@suse.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486546173-20713-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:55088 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753475AbdBHLiK (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 8 Feb 2017 06:38:10 -0500
In-Reply-To: <1486546173-20713-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/08/2017 10:29 AM, Shivasharan S wrote:
> fix in v2 - split patches into two. 
> discussed below 
> http://marc.info/?l=linux-scsi&m=148638999110404&w=2
> 
> No functional change. Code clean up. Removing error code which is not
> valid scenario.
> In megasas_get_request_descriptor we can remove the error handling
> which is not required.
> With fusion controllers, if there is a valid message frame available,
> we are guaranteed to get a corresponding request descriptor.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 24 ++----------------------
>  1 file changed, 2 insertions(+), 22 deletions(-)
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
