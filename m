From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v2 10/39] megaraid_sas: NVME Interface detection and prop
 settings
Date: Wed, 8 Feb 2017 12:59:35 +0100
Message-ID: <514eef89-94b6-1175-bbe4-2f2f6e4afb30@suse.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486546173-20713-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:46420 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932147AbdBHMUi (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 8 Feb 2017 07:20:38 -0500
In-Reply-To: <1486546173-20713-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/08/2017 10:29 AM, Shivasharan S wrote:
> New functionality
> Adding detection logic for NVME device attached behind Ventura controller.
> Driver set HostPageSize in IOC_INIT frame to inform about page size for NVME devices.
> Firmware reports NVME page size to the driver.
> PD INFO DCMD provide new interface type NVME_PD. Driver set property of NVME device.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  23 ++--
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 170 ++++++++++++++++++++--------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   6 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |   2 +-
>  4 files changed, 142 insertions(+), 59 deletions(-)
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
