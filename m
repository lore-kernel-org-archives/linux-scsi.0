From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH 1/1] include/scsi/osd_protocol.h: remove unnecessary __constant
Date: Sun, 01 Jun 2014 18:47:13 +0300
Message-ID: <538B4B01.1090805@gmail.com>
References: <1401631613-25359-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:63789 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaFAPrR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Jun 2014 11:47:17 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so4121966wes.27
        for <linux-scsi@vger.kernel.org>; Sun, 01 Jun 2014 08:47:15 -0700 (PDT)
In-Reply-To: <1401631613-25359-1-git-send-email-fabf@skynet.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@primarydata.com>

On 06/01/2014 05:06 PM, Fabian Frederick wrote:
> __constant_cpu_to_be16 converted to cpu_to_be16
> 
> This patch fixes checkpatch warnings:
> 
> "WARNING: __constant_cpu_to_be16 should be cpu_to_be16"
> 
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: Benny Halevy <bhalevy@primarydata.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Ack-by: Boaz Harrosh <bharrosh@panasas.com>

James please apply
Thanks
Boaz

> ---
>  include/scsi/osd_protocol.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
> index 25ac628..a2594af 100644
> --- a/include/scsi/osd_protocol.h
> +++ b/include/scsi/osd_protocol.h
> @@ -263,16 +263,16 @@ static inline struct osd_cdb_head *osd_cdb_head(struct osd_cdb *ocdb)
>   * Ex name = FORMAT_OSD we have OSD_ACT_FORMAT_OSD && OSDv1_ACT_FORMAT_OSD
>   */
>  #define OSD_ACT___(Name, Num) \
> -	OSD_ACT_##Name = __constant_cpu_to_be16(0x8880 + Num), \
> -	OSDv1_ACT_##Name = __constant_cpu_to_be16(0x8800 + Num),
> +	OSD_ACT_##Name = cpu_to_be16(0x8880 + Num), \
> +	OSDv1_ACT_##Name = cpu_to_be16(0x8800 + Num),
>  
>  /* V2 only actions */
>  #define OSD_ACT_V2(Name, Num) \
> -	OSD_ACT_##Name = __constant_cpu_to_be16(0x8880 + Num),
> +	OSD_ACT_##Name = cpu_to_be16(0x8880 + Num),
>  
>  #define OSD_ACT_V1_V2(Name, Num1, Num2) \
> -	OSD_ACT_##Name = __constant_cpu_to_be16(Num2), \
> -	OSDv1_ACT_##Name = __constant_cpu_to_be16(Num1),
> +	OSD_ACT_##Name = cpu_to_be16(Num2), \
> +	OSDv1_ACT_##Name = cpu_to_be16(Num1),
>  
>  enum osd_service_actions {
>  	OSD_ACT_V2(OBJECT_STRUCTURE_CHECK,	0x00)
> 

