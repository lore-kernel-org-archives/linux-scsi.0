From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: blk-mq vs kmemleak
Date: Fri, 3 Jul 2015 13:07:17 -0400
Message-ID: <20150703170717.GA10928@codemonkey.org.uk>
References: <20150703161137.GA10438@codemonkey.org.uk>
 <5596C080.4050009@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:43707 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbbGCRH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 13:07:26 -0400
Content-Disposition: inline
In-Reply-To: <5596C080.4050009@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jul 03, 2015 at 10:04:00AM -0700, Bart Van Assche wrote:
 > On 07/03/15 09:11, Dave Jones wrote:
 > > After a fuzzing run recently, I noticed that the machine had oom'd, and
 > > killed everything, but there was still 3GB of memory still in use, that
 > > I couldn't even reclaim with /proc/sys/vm/drop_caches
 > > ...
 > > I'm wondering if there's just some annotation missing to appease kmemleak,
 > > because I'm seeing thousands of these.
 > >
 > > Or it could be a real leak, but it seems surprising no-one else is complaining.
 > 
 > Dave, with which kernel version has this behavior been observed ?

Linus' current tree

	Dave

