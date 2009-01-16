From: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Mainline kernel OLTP performance update
Date: Fri, 16 Jan 2009 14:59:28 -0600 (CST)
Message-ID: <Pine.LNX.4.64.0901161458420.27283@quilx.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
  <20090115135236.GB29283@parisc-linux.org>
 <84144f020901160216q17f1b558q955d5b8fb7c528c0@mail.gmail.com>
 <200901162121.09128.nickpiggin@yahoo.com.au>
 <84144f020901160231k9e896d2o672079c1a2973632@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:45111 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937527AbZAPVAd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jan 2009 16:00:33 -0500
In-Reply-To: <84144f020901160231k9e896d2o672079c1a2973632@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

On Fri, 16 Jan 2009, Pekka Enberg wrote:

> aren't I? There's some scheduler related options such as
> CONFIG_GROUP_SCHED and CONFIG_FAIR_GROUP_SCHED enabled in defconfig
> that I didn't have in the original tests. I can try without them if
> you want but I'm not sure it's relevant for SLAB vs SLUB tests.

I have seen CONFIG_GROUP_SCHED to affect latency tests in significant
ways.

