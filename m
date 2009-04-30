From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: Re: [PATCH 5/5] USB: Wait for USB and SCSI block boot devices
Date: Wed, 29 Apr 2009 19:35:26 -0600
Message-ID: <20090430013526.GD8822@parisc-linux.org>
References: <20090430001255.GA3897@cuplxvomd02.corp.sa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090430001255.GA3897-CFZJ1or75eBPWxJt6d6B6bQa8qPdvLwY@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David VomLehn <dvomlehn-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-l3A5Bk7waGM@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 29, 2009 at 05:12:55PM -0700, David VomLehn wrote:
>  	scsi_finish_async_scan(data);
> +	bootdev_probe_done(BOOTDEV_BLOCK_MASK);
>  	return 0;
>  }
>  
> @@ -1855,6 +1856,7 @@ void scsi_scan_host(struct Scsi_Host *shost)
>  		return;
>  	}
>  
> +	bootdev_found(BOOTDEV_BLOCK_MASK);
>  	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
>  	if (IS_ERR(p))

Where are the definitions of these functions to be found?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
