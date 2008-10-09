From: Meelis Roos <mroos@linux.ee>
Subject: Re: panic while doing lots of IO on lpfc
Date: Thu, 9 Oct 2008 19:21:19 +0300 (EEST)
Message-ID: <Pine.SOC.4.64.0810091919260.5106@math.ut.ee>
References: <Pine.SOC.4.64.0810091714230.5106@math.ut.ee>
 <200810101233.18726.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759803AbYJIQVq@vger.kernel.org>
In-Reply-To: <200810101233.18726.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Tried to lock a free page. Is the address of the page always the same,
> and the first bit in flags always set after each reboot? Does the
> machine pass a memtest?

No, the machine does not pass memtest :(
Thanks for the reminder.

So please ignore this thread - if I find any errors with good RAM, I 
will open a new thread.

-- 
Meelis Roos (mroos@linux.ee)
