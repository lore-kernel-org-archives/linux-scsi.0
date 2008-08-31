From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] lib: add generic helper to print sizes rounded to the correct SI range
Date: Sun, 31 Aug 2008 09:51:34 -0600
Message-ID: <20080831155124.GL1239@parisc-linux.org>
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain> <20080830174516.GD1239@parisc-linux.org> <48B9B552.8060406@simon.arlott.org.uk> <48B9B588.7060709@simon.arlott.org.uk> <1220147947.3615.18.camel@localhost.localdomain> <20080831025412.GJ1239@parisc-linux.org> <1220195310.4021.4.camel@localhost.localdomain> <1220195634.4021.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36857 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYHaPwY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2008 11:52:24 -0400
Content-Disposition: inline
In-Reply-To: <1220195634.4021.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Aug 31, 2008 at 10:13:54AM -0500, James Bottomley wrote:
> +int string_get_size(u64 size, const enum string_size_units units,
> +		    char *buf, int len)
> +{
> +	const char *units_10[] = { "B", "KB", "MB", "GB", "TB", "PB",
> +				   "EB", "ZB", "YB", NULL};
> +	const char *units_2[] = {"B", "Kib", "MiB", "GiB", "TiB", "PiB",

Typo for KiB?

Should this be another %p extension instead?  %pB and %piB perhaps?
That would seem easier for the callers than futzing around with managing
their own string buffers.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
