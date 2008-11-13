From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/12] mpt2sas - mpi headers
Date: Thu, 13 Nov 2008 16:40:06 -0500
Message-ID: <20081113214006.GA23895@infradead.org>
References: <20081113211648.GA20581@infradead.org> <660360F4F2570145BD872F298951B17A5CBE1A2A@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbYKMVkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2008 16:40:07 -0500
Content-Disposition: inline
In-Reply-To: <660360F4F2570145BD872F298951B17A5CBE1A2A@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Nov 13, 2008 at 02:31:48PM -0700, Moore, Eric wrote:
> The only typedefs in the entire driver are those found in the mpi subfolder.  The mpi subfolder contains headers that define the common message passing interface between device driver/application and firmware.  These headers are provided by the firmware group to every device driver and application writer.  There have been several revisions of the headers thru out the past year or so.    I think what your asking is an entire rewrite of all these headers.   I really don't think that is a good idea.

We don't have to rewrite all of them, but you at least need to get the
endian annotations right.  Easiest way to do that would be to just run
a sed script over the version you get from the FW teams to use the
proper __le types instead of the strange U* typedefs.

