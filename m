From: "Ma, Chinang" <chinang.ma@intel.com>
Subject: RE: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 12:44:16 -0700
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E8003175EB45B@azsmsx501.amr.corp.intel.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>
	 <20090114163557.11e097f2.akpm@linux-foundation.org>
	 <20090115012147.GW29283@parisc-linux.org>
	 <20090114180431.f4a96543.akpm@linux-foundation.org>
	 <1232028766.5966.10.camel@localhost.localdomain>
	 <20090115094442.b6394544.akpm@linux-foundation.org>
	 <20090115180052.GG29283@parisc-linux.org>
 <1232043287.21980.65.camel@localhost.localdomain>
 <496F8421.3070703@novell.com>
 <CAC4B8726E86A142B27A9E9A2F2F12479D4403CE@rrsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758465AbZAOTo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 14:44:27 -0500
In-Reply-To: <CAC4B8726E86A142B27A9E9A2F2F12479D4403CE@rrsmsx505.amr.corp.intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Gregory Haskins <ghaskins@novell.com>, Steven Rostedt <srostedt@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Kleen, Andi" <andi.kleen@intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Chilukuri, Harita" <harita.chilukuri@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Gregory. 
I will test the resched-ipi instrumentation patch with our OLTP if you can post the patch and some instructions.
Thanks,
-Chinang

>-----Original Message-----
>From: Wilcox, Matthew R
>Sent: Thursday, January 15, 2009 10:47 AM
>To: Gregory Haskins; Steven Rostedt
>Cc: Matthew Wilcox; Andrew Morton; James Bottomley; Ma, Chinang; linux-
>kernel@vger.kernel.org; Tripathi, Sharad C; arjan@linux.intel.com; Kleen,
>Andi; Siddha, Suresh B; Chilukuri, Harita; Styner, Douglas W; Wang, Peter
>Xihong; Nueckel, Hubert; chris.mason@oracle.com; linux-scsi@vger.kernel.org;
>Andrew Vasquez; Anirban Chakraborty
>Subject: RE: Mainline kernel OLTP performance update
>
>Gregory Haskins [mailto:ghaskins@novell.com] wrote:
>> > On Thu, 2009-01-15 at 11:00 -0700, Matthew Wilcox wrote:
>> >> So if the reschedule interrupt is happening twice as often, and the
>> >> context switch rate is basically unchanged, I guess that means the
>> >> scheduler is doing a lot more work to get approximately the same
>> >> results.  And that seems like a bad thing.
>>
>> I would be very interested in gathering some data in this area.  One
>> thing that pops to mind is to instrument the resched-ipi with
>> ftrace_printk() and gather a trace of this system in action.  I assume
>> that I wouldn't have access to this OLTP suite, so I may need a
>> volunteer to try this for me.  I could put together an instrumentation
>> patch for the testers convenience if they prefer.
>
>I don't know whether Novell have an arrangement with the Well-Known
>Commercial Database and the Well-Known OLTP Benchmark to do runs like this.
>Chinang is normally only too happy to build his own kernels with patches
>from people who are interested in helping, so that's probably the best way
>to do it.
>
>I'm leaving for LCA in an hour or so, so further responses from me to this
>thread are unlikely ;-)
