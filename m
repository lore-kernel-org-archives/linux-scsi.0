From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] advansys: use request_firmware
Date: Sat, 20 Dec 2008 08:32:58 -0700
Message-ID: <20081220153258.GU19967@parisc-linux.org>
References: <1229786727.15438.5.camel@jaswinder.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1229786727.15438.5.camel@jaswinder.satnam>
Sender: linux-next-owner@vger.kernel.org
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, willy@linux.intel.com, LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, sfr@canb.auug.org.au, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 20, 2008 at 08:55:27PM +0530, Jaswinder Singh wrote:
> diff --git a/firmware/WHENCE b/firmware/WHENCE
> index 299301f..27105bc 100644
> --- a/firmware/WHENCE
> +++ b/firmware/WHENCE
> @@ -363,3 +363,16 @@ Licence: Allegedly GPLv2+, but no source visible. Marked:
>    Copyright (C) 2001 Qlogic Corporation (www.qlogic.com)
>  
>  --------------------------------------------------------------------------
> +
> +Driver: SCSI_ADVANSYS - AdvanSys SCSI
> +
> +File: advansys/mcode.bin
> +File: advansys/3550.bin
> +File: advansys/38C0800.bin
> +File: advansys/38C1600.bin
> +
> +Licence: Allegedly GPLv2+, but no source visible.
> +
> +Found in hex form in kernel source.

I thought we discussed this before.  If you take it from an earlier
version of the driver, you can get it under a disjunction of BSD and
GPL, and take the BSD option.

As far as I know, no source code has been published.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
