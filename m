From: Christoph Hellwig <hch@sgi.com>
Subject: Re: [PATCH] scsi sysfs update (upper 2/3)
Date: Thu, 7 Nov 2002 18:29:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107182947.B15350@sgi.com>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021107073943.GB1390@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Nov 06, 2002 at 11:39:43PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 11:39:43PM -0800, Mike Anderson wrote:
> +	.scsi_driverfs_driver   = {
> +		.name   = "sd",
> +	},

can we changhe scsi_driverfs_driver to something saner? E.g. gen_driver?

>  static struct scsi_disk *sd_find_by_sdev(Scsi_Device *sd)
> @@ -1346,7 +1349,7 @@
>  	if (!majors)
>  		return -ENODEV;
>  
> -	rc = scsi_register_device(&sd_template);
> +	rc = scsi_bus_driver_register(&sd_template);

Umm, no.  We don't register a bus.  Just leave the name unchanged until
we there is some commonly agreed upon upper layer terminology.
