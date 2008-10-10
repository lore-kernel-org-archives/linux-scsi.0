From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: panic while doing lots of IO on lpfc
Date: Fri, 10 Oct 2008 14:01:40 +1100
Message-ID: <200810101401.41124.nickpiggin@yahoo.com.au>
References: <Pine.SOC.4.64.0810091714230.5106@math.ut.ee> <200810101233.18726.nickpiggin@yahoo.com.au> <Pine.SOC.4.64.0810091919260.5106@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754868AbYJJDB7@vger.kernel.org>
In-Reply-To: <Pine.SOC.4.64.0810091919260.5106@math.ut.ee>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 10 October 2008 03:21, Meelis Roos wrote:
> > Tried to lock a free page. Is the address of the page always the same,
> > and the first bit in flags always set after each reboot? Does the
> > machine pass a memtest?
>
> No, the machine does not pass memtest :(
> Thanks for the reminder.
>
> So please ignore this thread - if I find any errors with good RAM, I
> will open a new thread.

Thanks for the report anyway. Hardware errors can creep up and it
isn't always easy to distinguish them (struct page only covers < 1%
of RAM, and struct page checking often only covers a small portion
of memory -- chances would be much lager to have seen completely
random corruption).
