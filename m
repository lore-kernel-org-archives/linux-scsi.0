From: Meelis Roos <mroos@linux.ee>
Subject: Re: panic while doing lots of IO on lpfc
Date: Thu, 9 Oct 2008 17:39:50 +0300 (EEST)
Message-ID: <Pine.SOC.4.64.0810091737430.5106@math.ut.ee>
References: <Pine.SOC.4.64.0810091714230.5106@math.ut.ee>
 <200810101233.18726.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:60796 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYJIOjv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Oct 2008 10:39:51 -0400
In-Reply-To: <200810101233.18726.nickpiggin@yahoo.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

> > Bad page state in process 'dd'
> > page:ffffe200005130c0 flags:0x4000000000000009 mapping:0000000000000000
> > mapcount:0 count:0
> > Trying to fix it up, but a reboot is needed
> 
> Tried to lock a free page. Is the address of the page always the same,
> and the first bit in flags always set after each reboot? Does the
> machine pass a memtest?

The machine has worked transporting lots of data and compiling many 
kernels a week, but I haven't done a memtest in more than a year.

The messages have scrolled away in other cases.

> It could be that someone actually tried to lock the page, though...
> You could try putting a BUG_ON(!page_count(page)) at the start of
> the trylock_page function.
> 
> Some more messages might provide more clues.

Will try netconsole after haveing finished the same test with Qlogic 
HBA.

-- 
Meelis Roos (mroos@linux.ee)
