From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] xen: make pvscsi frontend dependant on xenbus frontend
Date: Tue, 23 Sep 2014 15:06:52 +0100
Message-ID: <alpine.DEB.2.02.1409231506390.15268@kaball.uk.xensource.com>
References: <1410756301-23340-1-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410756301-23340-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: jim.epost@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Sep 2014, Juergen Gross wrote:
> The pvscsi frontend driver requires the xenbus frontend driver. Reflect
> this in Kconfig.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

>  drivers/scsi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 9130df1..ff62dc1 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -579,6 +579,7 @@ config VMWARE_PVSCSI
>  config XEN_SCSI_FRONTEND
>  	tristate "XEN SCSI frontend driver"
>  	depends on SCSI && XEN
> +	select XEN_XENBUS_FRONTEND
>  	help
>  	  The XEN SCSI frontend driver allows the kernel to access SCSI Devices
>  	  within another guest OS (usually Dom0).
> -- 
> 1.8.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://secure-web.cisco.com/1jE8NNDhHwOASDbIzbn-azzuN8MKBMP1e4rCG2hGFpNvqSN8uwPwleK_Lmj9tzbaylXigSiLek5R_LJBvhlKaVWIjN_cB2SWcOB2WEXe4nDTKNaIEC6vNV5stEFM1SLzyMntl4a2YTHo6X7bvUsZQqYkXr5h_oDDR84iBHb2dum8/http%3A%2F%2Fwww.tux.org%2Flkml%2F
> 
