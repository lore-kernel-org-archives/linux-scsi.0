From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 09/19] be2iscsi: Adding crashdump support
Date: Thu, 22 Jul 2010 17:26:21 -0500
Message-ID: <4C48C58D.5000805@cs.wisc.edu>
References: <20100721225442.GA9517@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60795 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab0GVWWs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2010 18:22:48 -0400
In-Reply-To: <20100721225442.GA9517@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 07/21/2010 05:54 PM, Jayamohan Kallickal wrote:
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 67a7e3f..1a22125 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -41,6 +41,8 @@
>   static unsigned int be_iopoll_budget = 10;
>   static unsigned int be_max_phys_size = 64;
>   static unsigned int enable_msix = 1;
> +static unsigned int gcrashmode = 0;
> +static unsigned int num_hba = 0;
>

You do not need to init to 0 when they are static (checkpatch.pl can 
find this stuff for you).

I think it is ok to fix this on a later patch so the rest can go in.
