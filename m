From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v2 09/39] megaraid_sas: change issue_dcmd to return void
 from int
Date: Wed, 8 Feb 2017 12:17:59 +0100
Message-ID: <66b3b03f-e117-ec5d-eae9-ed21a8369710@suse.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486546173-20713-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:53344 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752061AbdBHLTA (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 8 Feb 2017 06:19:00 -0500
In-Reply-To: <1486546173-20713-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/08/2017 10:29 AM, Shivasharan S wrote:
> fix in v2 : 
> 1. split patches into two as discussed below 
> http://marc.info/?l=linux-scsi&m=148638999110404&w=2
> 2. issue_dcmd return type changed from int to void.
> 
> 
> With the changes to remove checks for a valid request descriptor,
> issue_dcmd will now always return DCMD_SUCCESS. This patch changes
> return type of issue_dcmd to void and change all callers
> appropriately.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 19 +++++++++++--------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  8 ++++----
>  3 files changed, 16 insertions(+), 13 deletions(-)
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
