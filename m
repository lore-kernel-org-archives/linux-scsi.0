From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/3] be2iscsi: Fixing the number of SGE's
Date: Wed, 06 Jan 2010 14:30:52 -0600
Message-ID: <4B44F2FC.9060903@cs.wisc.edu>
References: <20100106202052.GA19928@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59669 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab0AFUbF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jan 2010 15:31:05 -0500
In-Reply-To: <20100106202052.GA19928@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 01/06/2010 02:21 PM, Jayamohan Kallickal wrote:
> 	The number of SGE's supported is fixed to what the
> chip expects. Also, the max sectors set to tested values
>
> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
> ---
>   drivers/scsi/be2iscsi/be_main.h |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
> index 4cde8f6..13ff02c 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -56,10 +56,10 @@
>   #define BE2_DEFPDU_DATA_SZ	8192
>
>   #define MAX_CPUS		31
> -#define BEISCSI_SGLIST_ELEMENTS	BE2_SGE
> +#define BEISCSI_SGLIST_ELEMENTS	30

BE2_SGE is now not used, so you can kill it.
