From: Bernd Schubert <bernd.schubert@pci.uni-heidelberg.de>
Subject: Re: aic79xx oops
Date: Tue, 13 Sep 2005 14:48:28 +0200
Message-ID: <200509131448.29219.bernd.schubert@pci.uni-heidelberg.de>
References: <200509091325.45620.bernd.schubert@pci.uni-heidelberg.de> <200509121258.26823.bernd.schubert@pci.uni-heidelberg.de> <1126534514.4825.5.camel@mulgrave>
Reply-To: bernd-schubert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:1948 "EHLO
	relay.uni-heidelberg.de") by vger.kernel.org with ESMTP
	id S932635AbVIMMse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 08:48:34 -0400
In-Reply-To: <1126534514.4825.5.camel@mulgrave>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -110,6 +110,7 @@ static struct {
>  	{"RELISYS", "Scorpio", NULL, BLIST_NOLUN},	/* responds to all lun */
>  	{"SANKYO", "CP525", "6.64", BLIST_NOLUN},	/* causes failed REQ SENSE,
> extra reset */ {"TEXEL", "CD-ROM", "1.06", BLIST_NOLUN},
> +	{"transtec", "T5008", "0001", BLIST_NOREPORTLUN },
>  	{"YAMAHA", "CDR100", "1.00", BLIST_NOLUN},	/* locks up */
>  	{"YAMAHA", "CDR102", "1.00", BLIST_NOLUN},	/* locks up */
>  	{"YAMAHA", "CRW8424S", "1.0", BLIST_NOLUN},	/* locks up */

Thanks, the patch works fine. We now switched back to 2.6.11 (with included 
patch) and didn't get an oops.

Thanks again,	
	Bernd

