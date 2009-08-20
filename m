From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Thu, 20 Aug 2009 02:10:04 +0100
Message-ID: <20090820011004.GC14005@shareable.org>
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <20090820010552.GA22107@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:49996 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbZHTBK3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2009 21:10:29 -0400
Content-Disposition: inline
In-Reply-To: <20090820010552.GA22107@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com

Christoph Hellwig wrote:
> > So i'm torn about the 'syscall versus ioctl' issue, i'd 
> > like to avoid making interface design mistakes and i'd 
> > like to solicit some opinions about this. I've attached 
> > the perfcounters ioctl patch below.
> 
> Only add a syscall if it has _one_ clear defined purpose,
> which has kernel-wide meaning.

One clear defined purpose which comes to mind is a "trim" or "punch"
system call, for making holes in files as well as trimming block
devices.  Several other OSes have that capability on files.

I don't remember - does TRIM guarantee the blocks read zeros afterwards?

It would be tidy if it does, as it could have the same meaning with files.

-- Jamie

