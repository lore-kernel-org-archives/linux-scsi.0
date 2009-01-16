From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Mainline kernel OLTP performance update
Date: Fri, 16 Jan 2009 21:21:07 +1100
Message-ID: <200901162121.09128.nickpiggin@yahoo.com.au>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <20090115135236.GB29283@parisc-linux.org> <84144f020901160216q17f1b558q955d5b8fb7c528c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:49088 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932126AbZAPKVb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 05:21:31 -0500
In-Reply-To: <84144f020901160216q17f1b558q955d5b8fb7c528c0@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Christoph Lameter <cl@linux-foundation.org>

On Friday 16 January 2009 21:16:31 Pekka Enberg wrote:
> On Thu, Jan 15, 2009 at 11:46:09AM +0200, Pekka Enberg wrote:
> >> It would also be nice if someone could do the performance analysis on
> >> the SLUB bug. I ran sysbench in oltp mode here and the results look
> >> like this:
> >>
> >>   [ number of transactions per second from 10 runs. ]
> >>
> >>                    min      max      avg      sd
> >>   2.6.29-rc1-slab  833.77   852.32   845.10   4.72
> >>   2.6.29-rc1-slub  823.61   851.94   836.74   8.57

> I had lockdep enabled in my config so I ran the tests again with
> x86-64 defconfig and I'm back to square one:
>
>   [ number of transactions per second from 10 runs, bigger is better ]
>
>                    min      max      avg      sd
>   2.6.29-rc1-slab  802.02   805.37   803.93   0.97
>   2.6.29-rc1-slub  807.78   811.20   809.86   1.05

Hm, I wonder why it is going slower with lockdep disabled?
Did something else change?

