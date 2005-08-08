From: Ashok Raj <ashok.raj@intel.com>
Subject: Re: 2.6.13-rc5-mm1 doesnt boot on x86_64
Date: Mon, 8 Aug 2005 10:39:24 -0700
Message-ID: <20050808103924.A18250@unix-os.sc.intel.com>
References: <20050808094818.A17579@unix-os.sc.intel.com> <20050808171126.GA32092@muc.de> <1123522409.5019.0.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr22.intel.com ([143.183.121.14]:53660 "EHLO
	scsfmr002.sc.intel.com") by vger.kernel.org with ESMTP
	id S932143AbVHHRkS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 13:40:18 -0400
Content-Disposition: inline
In-Reply-To: <1123522409.5019.0.camel@mulgrave>; from James.Bottomley@SteelEye.com on Mon, Aug 08, 2005 at 12:33:29PM -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andi Kleen <ak@muc.de>, Ashok Raj <ashok.raj@intel.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Aug 08, 2005 at 12:33:29PM -0500, James Bottomley wrote:
> On Mon, 2005-08-08 at 19:11 +0200, Andi Kleen wrote:
> > Looks like a SCSI problem. The machine has an Adaptec SCSI adapter, right?
> 
> The traceback looks pretty meaningless.
> 
> What was happening on the machine before this.  i.e. was it booting up,
> in which case can we have the prior dmesg file; or was the aic79xxx
> driver being removed?

I can get the trace again, but basically the system was booting. 

AIC_7XXX was defined in defconfig, but my system doesnt have it. Seems like
the senario was the driver tried to probe, found nothing, and tries
to de-reg resulting in the BUG().

I will try to get the recompile and entire dmesg log in the meantime.
> 
> James
> 
> 

-- 
Cheers,
Ashok Raj
- Open Source Technology Center
