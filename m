From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 8/12] mpt2sas - mpi headers
Date: Thu, 13 Nov 2008 15:21:57 -0700
Message-ID: <660360F4F2570145BD872F298951B17A5CBE1A66@cosmail03.lsi.com>
References: <20081113214006.GA23895@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61886 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbYKMWWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2008 17:22:05 -0500
In-Reply-To: <20081113214006.GA23895@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thursday, November 13, 2008 2:40 PM, Christoph Hellwig wrote:
> On Thu, Nov 13, 2008 at 02:31:48PM -0700, Moore, Eric wrote:
> > The only typedefs in the entire driver are those found in
> the mpi subfolder.  The mpi subfolder contains headers that
> define the common message passing interface between device
> driver/application and firmware.  These headers are provided
> by the firmware group to every device driver and application
> writer.  There have been several revisions of the headers
> thru out the past year or so.    I think what your asking is
> an entire rewrite of all these headers.   I really don't
> think that is a good idea.
>
> We don't have to rewrite all of them, but you at least need to get the
> endian annotations right.  Easiest way to do that would be to just run
> a sed script over the version you get from the FW teams to use the
> proper __le types instead of the strange U* typedefs.
>
>

Ok, I misunderstood earlier.   So your concern is only over U16, U32, and U64, right?    I'll fix that up before I repost.

Eric
