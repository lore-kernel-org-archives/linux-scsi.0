From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [TRIVIAL] Re: aic7xxx gcc3 warning fix
Date: Fri, 26 Jul 2002 10:17:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020726101754.A6596@infradead.org>
References: <20020726071547.F2B6D4806@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020726071547.F2B6D4806@lists.samba.org>; from rusty@rustcorp.com.au on Fri, Jul 26, 2002 at 04:38:32PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@transmeta.com>, dledford@redhat.com, linux-scsi@vger.kernel.org

On Fri, Jul 26, 2002 at 04:38:32PM +1000, Rusty Trivial Russell wrote:
>  MODULE_LICENSE("Dual BSD/GPL");
>  #endif
>  MODULE_PARM(aic7xxx, "s");
> -MODULE_PARM_DESC(aic7xxx, "period delimited, options string.
> -	verbose			Enable verbose/diagnostic logging
> -	no_probe		Disable EISA/VLB controller probing
> -	no_reset		Supress initial bus resets
> -	extended		Enable extended geometry on all controllers
> -	periodic_otag		Send an ordered tagged transaction periodically
> -				to prevent tag starvation.  This may be
> -				required by some older disk drives/RAID arrays. 
> -	reverse_scan		Sort PCI devices highest Bus/Slot to lowest
> -	tag_info:<tag_str>	Set per-target tag depth
> -	seltime:<int>		Selection Timeout(0/256ms,1/128ms,2/64ms,3/32ms)
> -
> -	Sample /etc/modules.conf line:
> -		Enable verbose logging
> -		Disable EISA/VLB probing
> -		Set tag depth on Controller 2/Target 2 to 10 tags
> -		Shorten the selection timeout to 128ms from its default of 256
> -
> -	options aic7xxx='\"verbose.no_probe.tag_info:{{}.{}.{..10}}.seltime:1\"'
> -");
> +MODULE_PARM_DESC(aic7xxx, "period delimited, options string.\n\
> +	verbose			Enable verbose/diagnostic logging\n\
> +	no_probe		Disable EISA/VLB controller probing\n\
> +	no_reset		Supress initial bus resets\n\
> +	extended		Enable extended geometry on all controllers\n\
> +	periodic_otag		Send an ordered tagged transaction periodically\n\
> +				to prevent tag starvation.  This may be\n\
> +				required by some older disk drives/RAID arrays. \n\
> +	reverse_scan		Sort PCI devices highest Bus/Slot to lowest\n\
> +	tag_info:<tag_str>	Set per-target tag depth\n\
> +	seltime:<int>		Selection Timeout(0/256ms,1/128ms,2/64ms,3/32ms)\n\
> +\n\
> +	Sample /etc/modules.conf line:\n\
> +		Enable verbose logging\n\
> +		Disable EISA/VLB probing\n\
> +		Set tag depth on Controller 2/Target 2 to 10 tags\n\
> +		Shorten the selection timeout to 128ms from its default of 256\n\
> +\n\
> +	options aic7xxx='\"verbose.no_probe.tag_info:{{}.{}.{..10}}.seltime:1\"'\n"
> +);
>  #endif


Can't we just remove this stupid option parsing entirely in 2.5 and make it
take sane module options?  


