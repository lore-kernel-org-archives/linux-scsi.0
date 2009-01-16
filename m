From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Mainline kernel OLTP performance update
Date: Fri, 16 Jan 2009 12:31:03 +0200
Message-ID: <84144f020901160231k9e896d2o672079c1a2973632@mail.gmail.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <20090115135236.GB29283@parisc-linux.org>
	 <84144f020901160216q17f1b558q955d5b8fb7c528c0@mail.gmail.com>
	 <200901162121.09128.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:38709 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbZAPKbF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jan 2009 05:31:05 -0500
In-Reply-To: <200901162121.09128.nickpiggin@yahoo.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Christoph Lameter <cl@linux-foundation.org>

On Friday 16 January 2009 21:16:31 Pekka Enberg wrote:
>> I had lockdep enabled in my config so I ran the tests again with
>> x86-64 defconfig and I'm back to square one:
>>
>>   [ number of transactions per second from 10 runs, bigger is better ]
>>
>>                    min      max      avg      sd
>>   2.6.29-rc1-slab  802.02   805.37   803.93   0.97
>>   2.6.29-rc1-slub  807.78   811.20   809.86   1.05

On Fri, Jan 16, 2009 at 12:21 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Hm, I wonder why it is going slower with lockdep disabled?
> Did something else change?

I don't have the exact config for the previous tests but it's was just
my laptop regular config whereas the new tests are x86-64 defconfig.
So I think I'm just hitting some of the other OLTP regressions here,
aren't I? There's some scheduler related options such as
CONFIG_GROUP_SCHED and CONFIG_FAIR_GROUP_SCHED enabled in defconfig
that I didn't have in the original tests. I can try without them if
you want but I'm not sure it's relevant for SLAB vs SLUB tests.

                                Pekka
