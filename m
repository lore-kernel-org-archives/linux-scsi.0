From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/5] AACRAID driver update
Date: Sun, 16 May 2010 22:54:23 -0400
Message-ID: <1274064863.14187.134.camel@mulgrave.site>
References: <C42A9BA25D0AB74D81491EF544ED520973D0D9DFC5@ADPE2K704.adaptec.com>
	 <1272740581.4570.92.camel@mulgrave.site>
	 <C42A9BA25D0AB74D81491EF544ED520973D1140BDD@ADPE2K704.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43729 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab0EQCyh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 May 2010 22:54:37 -0400
In-Reply-To: <C42A9BA25D0AB74D81491EF544ED520973D1140BDD@ADPE2K704.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rajashekhara, Mahesh" <Mahesh_Rajashekhara@adaptec.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, AACRAID <AACRAID@adaptec.com>

On Mon, 2010-05-10 at 04:12 -0700, Rajashekhara, Mahesh wrote:

This subject line [PATCH X/5] AACRAID driver update isn't descriptive of
the patch ... I interpolated proper subject lines from the description.


> ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
> handling of patch attachments (inline gets damaged, please use
> attachment).

The inline seemed to work mostly (lucky, because there are no
attachments).

> diff -ru a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> --- a/drivers/scsi/aacraid/aacraid.h	2010-05-13 12:35:40.020534512 -0700
> +++ b/drivers/scsi/aacraid/aacraid.h	2010-05-13 12:37:21.823058176 -0700
> @@ -12,7 +12,7 @@
>   *----------------------------------------------------------------------------*/
>  
>  #ifndef AAC_DRIVER_BUILD
> -# define AAC_DRIVER_BUILD 24702

All of your patches remove this same version number.  That makes each of
the patches after the first reject here when applied in sequence.  I
just stripped this out and updated the version number in the final
patch.

James


