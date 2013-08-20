From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: SCSI core patches for kernel 3.12
Date: Tue, 20 Aug 2013 13:38:04 -0700
Message-ID: <1377031084.5302.54.camel@haakon3.risingtidesystems.com>
References: <52135B99.2000102@acm.org>
	 <1377015091.5302.47.camel@haakon3.risingtidesystems.com>
	 <52139608.5040608@acm.org>
	 <1377018283.5302.48.camel@haakon3.risingtidesystems.com>
	 <5213AEBD.2020303@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57488 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3HTUbQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 16:31:16 -0400
In-Reply-To: <5213AEBD.2020303@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2013-08-20 at 20:00 +0200, Bart Van Assche wrote:
> On 08/20/13 19:04, Nicholas A. Bellinger wrote:
> > On Tue, 2013-08-20 at 18:15 +0200, Bart Van Assche wrote:
> >> On 08/20/13 18:11, Nicholas A. Bellinger wrote:
> >>> On Tue, 2013-08-20 at 14:05 +0200, Bart Van Assche wrote:
> >>>> This patch series consists of four patches that address device removal
> >>>> issues and three patches that improve performance of the SCSI mid-layer.
> >>>
> >>> Perhaps it would be useful to know what the performance improvement
> >>> actually is..?  Eg: fio numbers before and after.
> >>
> >> The optimizations in this patch series are micro-optimizations. Their
> >> performance impact is small but measurable. Peak IOPS results are
> >> improved by about 1% by each of these performance improvements for a
> >> low-latency transport.
> >
> > So that is 250K to 252.5K per LUN, or what..?
> 
> The exact numbers depend on the number of CPU's in the initiator system, 
> the number of CPU's in the target system, the transport type, HCA model, 
> SCSI target stack configuration, target storage medium etc. If you want 
> to verify yourself the impact of this patch without all these 
> dependencies, that's possible by running a test against the scsi_debug 
> driver.
> 

<yawn>, I only care about the performance against upstream code, so that
would mean scsi_debug here.  Typically the onus of demonstrating a
performance improvement is on the patch submitter (eg: not the
reviewer).

But it would be at least useful to know the actual benefit with results
as an incremental step, short of avoiding this code entirely for
scsi-mq.

--nab

