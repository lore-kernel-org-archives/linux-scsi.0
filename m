From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_device refcounting and list lockdown
Date: Tue, 28 Oct 2003 17:37:38 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028173738.A5097@infradead.org>
References: <20031027155713.GA28140@lst.de> <20031028023235.GE1151@beaverton.ibm.com> <20031028090755.GB7370@lst.de> <1067356364.1862.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:17423 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264059AbTJ1Rhk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 12:37:40 -0500
Content-Disposition: inline
In-Reply-To: <1067356364.1862.5.camel@mulgrave>; from James.Bottomley@steeleye.com on Tue, Oct 28, 2003 at 09:52:42AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Oct 28, 2003 at 09:52:42AM -0600, James Bottomley wrote:
> On Tue, 2003-10-28 at 03:07, Christoph Hellwig wrote:
> > > Don't we still want to set SDEV_DEL to keep callers to scsi_device_get
> > > from do more gets.
> > 
> > Indeed!  James, can you add this back when applying?
> 
> OK, this should be in place on the scsi-bugfixes-2.6 tree if you could
> check it out.

Looks fine to me.

