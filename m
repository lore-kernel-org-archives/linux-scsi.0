From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 01/39] Revert "scsi: megaraid_sas: Enable or Disable Fast
 path based on the PCI Threshold Bandwidth"
Date: Mon, 6 Feb 2017 11:24:35 +0100
Message-ID: <7b191b3c-a885-11b6-a5dd-704027d7e9dd@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:51559 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdBFKYi (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 05:24:38 -0500
In-Reply-To: <1486375212-17329-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> This reverts
> commit "3e5eadb1a881" ("scsi: megaraid_sas: Enable or Disable Fast path based on the PCI Threshold Bandwidth")
> 
> This patch was aimed to increase performance of R1 Write operation for large IO size.
> Since this method used timer approach, it turn on/off fast path did not work as expected.
> Patch 0011 describes new algorithm and performance number.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  8 -----
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 48 -----------------------------
>  drivers/scsi/megaraid/megaraid_sas_fp.c     |  7 -----
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 16 ++++------
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 +-
>  5 files changed, 7 insertions(+), 74 deletions(-)
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
