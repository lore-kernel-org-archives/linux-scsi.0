From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Fri, 25 Apr 2003 17:56:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425175630.A4720@infradead.org>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com> <20030425111227.B28577@infradead.org> <3EA94263.1020902@rogers.com> <20030425095055.B8776@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:25356 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263369AbTDYQoX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 12:44:23 -0400
Content-Disposition: inline
In-Reply-To: <20030425095055.B8776@beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Apr 25, 2003 at 09:50:55AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Luben Tuikov <tluben@rogers.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Apr 25, 2003 at 09:50:55AM -0700, Patrick Mansfield wrote:
> On Fri, Apr 25, 2003 at 10:12:51AM -0400, Luben Tuikov wrote:
> 
> > 1. Use the cache *first*, and if it's depleted, *then*
> > use the spare command struct.
> 
> Then we would allocate and almost never use the spare. This is a bit
> different as compared to the per-host spare, when we shoulid use the
> spare only as a last resort.

Again, it's no more a spare if you use it first, it's a cache then
and will always be gone when you need it.

