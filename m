From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 6000] New: aic7xxx causes panic under heavy
 use
Date: Thu, 2 Feb 2006 16:43:35 -0800
Message-ID: <20060202164335.62316d0f.akpm@osdl.org>
References: <200602022339.k12Ndwht009365@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32966 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751161AbWBCAlo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2006 19:41:44 -0500
In-Reply-To: <200602022339.k12Ndwht009365@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, other@signalsguru.net

bugme-daemon@bugzilla.kernel.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=6000
> 
>            Summary: aic7xxx causes panic under heavy use
>     Kernel Version: 2.6.15.1
>             Status: NEW
>           Severity: high
>              Owner: scsi_drivers-aacraid@kernel-bugs.osdl.org
>          Submitter: other@signalsguru.net
> 
> 
> Most recent kernel where this bug did not occur:
> Distribution:Gentoo
> Hardware Environment:aaa-131 scsi raid, dual athlon mp
> Software Environment:gentoo linux (smp, no preempt), patched with 16k stack (but
> same behavior on original kernel)
> Problem Description:
> For a description and a kernel trace see
> http://forums.gentoo.org/viewtopic-t-429240-highlight-16k+stack.html
> 
> Steps to reproduce:
> Happens frequently during an emerge.  The raid drive has to be rebuilt afterwords.
> 

I think we fixed this
(http://www.signalsguru.net/articles/builtpc/kernoops.jpg) post-2.6.15?

James, it might be worth doing a 2.6.15.x fix if it's simple&safe enough.

