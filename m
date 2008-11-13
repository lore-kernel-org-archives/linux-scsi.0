From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/12] mpt2sas - mpi headers
Date: Thu, 13 Nov 2008 17:23:23 -0500
Message-ID: <20081113222323.GA7995@infradead.org>
References: <20081113214006.GA23895@infradead.org> <660360F4F2570145BD872F298951B17A5CBE1A66@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37686 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbYKMWXY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2008 17:23:24 -0500
Content-Disposition: inline
In-Reply-To: <660360F4F2570145BD872F298951B17A5CBE1A66@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Nov 13, 2008 at 03:21:57PM -0700, Moore, Eric wrote:
> Ok, I misunderstood earlier.   So your concern is only over U16, U32, and U64, right?    I'll fix that up before I repost.

Yes.  The other typedefs and upper case are also ugly, but not as bad as
missing endianess annotations.  Please also make sure to actually test
the annotations using sparse, see Documentation/sparse.txt for details.

