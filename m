From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/12] mpt2sas - mpi headers
Date: Thu, 13 Nov 2008 16:16:48 -0500
Message-ID: <20081113211648.GA20581@infradead.org>
References: <20081103083933.GA3390@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYKMVQt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2008 16:16:49 -0500
Content-Disposition: inline
In-Reply-To: <20081103083933.GA3390@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 03, 2008 at 01:39:41AM -0700, Eric Moore wrote:
> This contains Common MPI (Message Passing Interface) Firmware Headers.

Neither checkpatch.pl nor sparse don't like this one.  Please get rid of
all the nasty typedefs and just use standard __le* types and verify with
sparse that you have got the endianess handling right.

