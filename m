From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH] Fix error path when adding sysfs attributes
Date: Fri, 16 Jan 2004 14:33:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116193341.GU27591@localhost>
References: <20040116192801.GT27591@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:8343 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S265645AbUAPTdl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 14:33:41 -0500
Content-Disposition: inline
In-Reply-To: <20040116192801.GT27591@localhost>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org



On Fri, Jan 16, 2004 at 02:28:01PM -0500, Martin Hicks wrote:
> 
>  	
> @@ -380,11 +382,14 @@
>  					scsi_sysfs_sdev_attrs[i])) {
>  			error = device_create_file(&sdev->sdev_gendev,
>  					scsi_sysfs_sdev_attrs[i]);
> -			if (error)
> +			if (error) {
>  				scsi_remove_device(sdev);
> +				goto out;
> +			}
>  		}
>  	}
>  
> +	out:

This is tabbed stupidly.  Sorry about that.


mh

-- 
Martin Hicks || mort@bork.org || PGP/GnuPG: 0x4C7F2BEE
