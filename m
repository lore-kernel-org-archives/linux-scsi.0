From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: Sat, 17 Jan 2004 18:43:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040118024326.GA381527@sgi.com>
References: <1074382860.1756.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:20673 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S266220AbUARCnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 21:43:31 -0500
Content-Disposition: inline
In-Reply-To: <1074382860.1756.20.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jes Sorensen <jes@wildopensource.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Jan 17, 2004 at 06:40:58PM -0500, James Bottomley wrote:
> 
> @@ -2393,16 +2420,6 @@
>  	/* Disable RISC load of firmware. */
>  	ha->flags.disable_risc_code_load =
>  		nv->cntr_flags_1.disable_loading_risc_code;
> -
> -#ifdef QLA_64BIT_PTR
> -	/* Enable 64bit addressing for OS/System combination supporting it   */
> -	/* actual NVRAM bit is: nv->cntr_flags_1.enable_64bit_addressing     */
> -	/* but we will ignore it and use BITS_PER_LONG macro to setup for    */
> -	/* 64 or 32 bit access of host memory in all x86/ia-64/Alpha systems */
> -	ha->flags.enable_64bit_addressing = 1;
> -#else
> -	ha->flags.enable_64bit_addressing = 0;
> -#endif
>  
>  	if (ha->flags.enable_64bit_addressing) {
>  		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",


What is the reason for this change?  Is there an alternate way that this
gets set?

jeremy
