From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] some more entries for the largelun list
Date: Wed, 2 Apr 2003 08:08:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030402080822.A25301@beaverton.ibm.com>
References: <20030327160744.C10288@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030327160744.C10288@lst.de>; from hch@lst.de on Thu, Mar 27, 2003 at 04:07:44PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Mar 27, 2003 at 04:07:44PM +0100, Christoph Hellwig wrote:
> 
> --- 1.65/drivers/scsi/scsi_scan.c	Mon Mar 10 09:23:23 2003
> +++ edited/drivers/scsi/scsi_scan.c	Fri Mar 21 21:14:13 2003
> @@ -191,6 +191,13 @@
>  	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>  	{"SUN", "T300", "*", BLIST_SPARSELUN},
>  	{"SUN", "T4", "*", BLIST_SPARSELUN},
> +	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
> +	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
> +	{"SGI", "TP9100", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> +	{"SGI", "TP9300", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> +	{"SGI", "TP9400", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> +	{"SGI", "TP9500", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> +	{"MYLEX", "DACARMRB", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>  	{ NULL, NULL, NULL, 0 },
>  };

Can any of the above instead report as SCSI-3? That is a much better
solution, especially since these seem to be fibre attached, and SCSI-3
also enables report luns support.

Most disk arrays (and even some standard disk drives) can change the SCSI
level.

-- Patrick Mansfield
