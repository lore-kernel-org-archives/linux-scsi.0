From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDB cmds with sense info
Date: Fri, 22 Feb 2008 09:24:46 -0700
Message-ID: <20080222162446.GG16995@parisc-linux.org>
References: <9738BCBE884FDB42801FAD8A7769C26501F6979B@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33073 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591AbYBVQYs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2008 11:24:48 -0500
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501F6979B@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Kolli, Neela" <Neela.Kolli@lsi.com>

On Fri, Feb 22, 2008 at 09:17:33AM -0700, Yang, Bo wrote:
> James,
> 
> What is the status for this patch?  We need to submit more patches based
> on the acceptance of this patch.

I've NAKed it.  You need to use compat_ioctl.  That way your code will
work even if you run a 32-bit x86 application on ia64 (or a 64-bit
application on x86).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
