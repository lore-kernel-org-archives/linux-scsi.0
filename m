From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 2/3] be2iscsi: Fixing the number of SGE's
Date: Wed, 06 Jan 2010 14:10:32 -0800
Message-ID: <20100106221032.6104c233@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail142.messagelabs.com ([216.82.249.99]:37730 "EHLO
	mail142.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265Ab0AFWHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2010 17:07:30 -0500
In-Reply-To: 4B44F2FC.9060903@cs.wisc.edu
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

It is used in be_main.c (num_sge_per_io). 

The FW expects and sglist with 32 SGE's but 2 are used internally.


-Jay


--
  _____  
From: Mike Christie [mailto:michaelc@cs.wisc.edu]
To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de
Sent: Wed, 06 Jan 2010 12:30:52 -0800
Subject: Re: [PATCH 2/3] be2iscsi: Fixing the number of SGE's

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

