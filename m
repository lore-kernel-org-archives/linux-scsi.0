From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 20:12:10 -0800
Message-ID: <20090115201210.ca1a9542.akpm@linux-foundation.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	<200901151824.38658.nickpiggin@yahoo.com.au>
	<20090115162735.99277cc9.akpm@linux-foundation.org>
	<200901161503.13730.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753606AbZAPENK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2009 23:13:10 -0500
In-Reply-To: <200901161503.13730.nickpiggin@yahoo.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: matthew@wil.cx, matthew.r.wilcox@intel.com, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com

On Fri, 16 Jan 2009 15:03:12 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> I would like to see SLQB merged in mainline, made default, and wait for
> some number releases. Then we take what we know, and try to make an
> informed decision about the best one to take. I guess that is problematic
> in that the rest of the kernel is moving underneath us. Do you have
> another idea?

Nope.  If it doesn't work out, we can remove it again I guess.
