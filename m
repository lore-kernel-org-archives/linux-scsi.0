From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 16/39] megaraid_sas: reduce size of fusion_context and use
 vmalloc if kmalloc fails
Date: Mon, 6 Feb 2017 12:18:15 +0100
Message-ID: <6aca1e02-4495-a58b-d8cc-bb694f1784d3@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:59169 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750956AbdBFLSS (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:18:18 -0500
In-Reply-To: <1486375212-17329-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> Currently fusion context has fixed array load_balance_info. Use dynamic allocation.
> In few places, driver do not want physically contigious memory.
> Attempt to use vmalloc if physical contiguous memory is not available.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  2 +
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 15 ++----
>  drivers/scsi/megaraid/megaraid_sas_fp.c     |  3 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 71 +++++++++++++++++++++++++++--
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |  3 +-
>  5 files changed, 76 insertions(+), 18 deletions(-)
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
