From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 06:52:36 -0700
Message-ID: <20090115135236.GB29283@parisc-linux.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org> <200901151824.38658.nickpiggin@yahoo.com.au> <84144f020901150146x72402ec4p7636d583cfd55b3e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35176 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbZAONwl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 08:52:41 -0500
Content-Disposition: inline
In-Reply-To: <84144f020901150146x72402ec4p7636d583cfd55b3e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@linux-foundation.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

On Thu, Jan 15, 2009 at 11:46:09AM +0200, Pekka Enberg wrote:
> It would also be nice if someone could do the performance analysis on
> the SLUB bug. I ran sysbench in oltp mode here and the results look
> like this:
> 
>   [ number of transactions per second from 10 runs. ]
> 
>                    min      max      avg      sd
>   2.6.29-rc1-slab  833.77   852.32   845.10   4.72
>   2.6.29-rc1-slub  823.61   851.94   836.74   8.57
> 
> And no, the numbers are not flipped, SLUB beats SLAB here. :(

Um.  More transactions per second is good.  Your numbers show SLAB
beating SLUB (even on your dual-CPU system).  And SLAB shows a lower
standard deviation, which is also good.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
