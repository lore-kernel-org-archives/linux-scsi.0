From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sym53c500_cs PCMCIA SCSI driver (round 5)
Date: Sat, 8 May 2004 16:10:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040508161045.A9590@infradead.org>
References: <20040504060451.5BA10DBDE@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:25353 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263169AbUEHPKu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 May 2004 11:10:50 -0400
Content-Disposition: inline
In-Reply-To: <20040504060451.5BA10DBDE@gherkin.frus.com>; from rct@gherkin.frus.com on Tue, May 04, 2004 at 01:04:51AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@infradead.org

On Tue, May 04, 2004 at 01:04:51AM -0500, Bob Tracy wrote:
> Support for additional sysfs class device attributes has been added:
> two are read-only (irq, ioport),

sorry to bother you again, but I don't think these belong into a scsi
LLDD.  it's attributes for the underlying bus.  For pci you get these
information already, but the pcmcia infrastructure isn't quite ready
yet.

> one is read-write (fast_pio).  The
> read-write attribute is a per-instance flag indicating the PIO speed
> of the particular HBA: valid values are 1 (enabled -- default) and 0
> (disabled).

this one is nice.

