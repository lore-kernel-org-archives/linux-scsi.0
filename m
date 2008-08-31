From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH 1/2] lib: add generic helper to print sizes rounded to
 the	correct SI range
Date: Sun, 31 Aug 2008 16:20:36 +0100
Message-ID: <48BAB6C4.20007@simon.arlott.org.uk>
References: <48B9546B.4010004@simon.arlott.org.uk>	 <1220117091.3615.3.camel@localhost.localdomain>	 <20080830174516.GD1239@parisc-linux.org>	 <48B9B552.8060406@simon.arlott.org.uk>	 <48B9B588.7060709@simon.arlott.org.uk>	 <1220147947.3615.18.camel@localhost.localdomain>	 <20080831025412.GJ1239@parisc-linux.org>	 <1220195310.4021.4.camel@localhost.localdomain> <1220195634.4021.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxima.lp0.eu ([85.158.45.36]:48357 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbYHaPUk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Aug 2008 11:20:40 -0400
In-Reply-To: <1220195634.4021.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 31/08/08 16:13, James Bottomley wrote:
> This patch adds the ability to print sizes in either units of 10^3 (SI)
> or 2^10 (Binary) units.  It rounds up to three significant figures and
> can be used for either memory or storage capacities.

> +	const char *units_2[] = {"B", "Kib", "MiB", "GiB", "TiB", "PiB",

I think this should have been "KiB".
I'd prefer an option to display these without the "i"...

Oh and you need to store the original capacity before it's re-scaled to 
512 bytes. Outputting sdkp->capacity at that stage it'll be a count of 
512-byte sectors.

-- 
Simon Arlott
