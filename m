From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATCH 2.6.11-rc4 rename IOMAPPED config option
Date: Sun, 20 Feb 2005 21:16:31 -0500
Message-ID: <20050221021631.GA23161@havoc.gtf.org>
References: <20050221010758.GC30800@colo.lackof.org> <4219355E.1000807@pobox.com> <20050221020221.GA28741@parcelfarce.linux.theplanet.co.uk> <20050221020936.GA22713@havoc.gtf.org> <20050221021405.GB28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from atlmail.prod.rxgsys.com ([64.74.124.160]:43941 "EHLO
	bastet.signetmail.com") by vger.kernel.org with ESMTP
	id S261410AbVBUCQn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 21:16:43 -0500
Content-Disposition: inline
In-Reply-To: <20050221021405.GB28741@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>, willy@parisc-linux.org, linux-scsi@vger.kernel.org

On Mon, Feb 21, 2005 at 02:14:05AM +0000, Matthew Wilcox wrote:
> On Sun, Feb 20, 2005 at 09:09:36PM -0500, Jeff Garzik wrote:
> > Incorrect.  <linux/config.h> is not a standard include; you need to
> > include linux/config.h in each file that uses a CONFIG_xxx define.
> 
> sym_hipd.c includes "sym_glue.h"
> sym_glue.h includes <linux/config.h>
> There is no problem.

Irrelevant.  Go look at how config.h stuff works.

linux/config.h is a special case with special rules.

The rule is:  include linux/config.h _in the file_ where CONFIG_xxx
symbol is used.

	Jeff



