From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 37/39] megaraid_sas: Indentation and smatch warning fixes
Date: Mon, 6 Feb 2017 12:30:34 +0100
Message-ID: <58171a34-c7bc-fea7-f469-5c52ad1f9b52@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-38-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:55603 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751603AbdBFLah (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:30:37 -0500
In-Reply-To: <1486375212-17329-38-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

On 02/06/2017 11:00 AM, Shivasharan S wrote:
> Fix indentation issues and smatch warning reported by Dan Carpenter
> for previous series as discussed below.
> http://www.spinics.net/lists/linux-scsi/msg103635.html
> http://www.spinics.net/lists/linux-scsi/msg103603.html
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 10 ++--
>  drivers/scsi/megaraid/megaraid_sas_fp.c     | 57 +++++++++---------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 92 ++++++++++++++---------------
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 +-
>  5 files changed, 80 insertions(+), 83 deletions(-)
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
