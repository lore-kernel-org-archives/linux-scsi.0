From: Benny Halevy <bhalevy@tonian.com>
Subject: Re: [osd-dev] [patch] [SCSI] libosd: remover duplicate __bitwise
 annotation
Date: Wed, 17 Apr 2013 11:32:51 +0300
Message-ID: <516E5E33.1090506@tonian.com>
References: <20130417071905.GE7923@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48040 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965758Ab3DQIc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 04:32:56 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq17so2688430wib.17
        for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 01:32:55 -0700 (PDT)
In-Reply-To: <20130417071905.GE7923@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, kernel-janitors@vger.kernel.org, osd-dev@open-osd.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 2013-04-17 10:19, Dan Carpenter wrote:
> __be32 is already a __bitwise type so we don't need the second __bitwise
> here.  It causes a Sparse error:
> include/scsi/osd_protocol.h:110:26: error: invalid modifier
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

ACK

> 
> diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
> index a6026da..25ac628 100644
> --- a/include/scsi/osd_protocol.h
> +++ b/include/scsi/osd_protocol.h
> @@ -107,7 +107,7 @@ enum osd_attributes_mode {
>   *		int exponent: 04;
>   *	}
>   */
> -typedef __be32 __bitwise osd_cdb_offset;
> +typedef __be32 osd_cdb_offset;
>  
>  enum {
>  	OSD_OFFSET_UNUSED = 0xFFFFFFFF,
> _______________________________________________
> osd-dev mailing list
> osd-dev@open-osd.org
> http://mailman.open-osd.org/mailman/listinfo/osd-dev
> 
