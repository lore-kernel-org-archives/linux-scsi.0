From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add spi attributes to qla1280
Date: Wed, 11 Aug 2004 23:05:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040811230555.A984@infradead.org>
References: <20040810230552.GA26569@sgi.com> <20040811081118.A26256@infradead.org> <20040811215651.GA30821@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:271 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268262AbUHKWF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 18:05:57 -0400
Content-Disposition: inline
In-Reply-To: <20040811215651.GA30821@sgi.com>; from jeremy@sgi.com on Wed, Aug 11, 2004 at 02:56:51PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Aug 11, 2004 at 02:56:51PM -0700, Jeremy Higdon wrote:
> The above is consistent with the rest of the driver in 2.6.8-rc2.
> So are you asking that I submit a patch to the driver in James's
> tree instead of to 2.6.8-rc2?

Yes.

> To avoid possibility of error, can you give me the URL for James's
> tree?  Is it a bk tree or a kernel.org tree?

bk://linux-scsi.bkbits.net/scsi-misc-2.6, it's also part of the
latest -mm tree.

> > No need to initialize to NULL here.
> 
> I thought about that.  What I did was take a patch that Martin Hicks
> submitted on March 10th and then make changes based on what I saw that
> James had done for the 53c700 driver, which has:
> 
> drivers/scsi/53c700.c:STATIC struct scsi_transport_template *NCR_700_transport_template = NULL;

needs fixing aswell :)

