From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: PATCH 2.6.11-rc4 rename IOMAPPED config option
Date: Wed, 23 Feb 2005 13:55:20 -0700
Message-ID: <20050223205520.GB26124@colo.lackof.org>
References: <20050221010758.GC30800@colo.lackof.org> <4219355E.1000807@pobox.com> <20050221020221.GA28741@parcelfarce.linux.theplanet.co.uk> <20050221020936.GA22713@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from colo.lackof.org ([198.49.126.79]:39586 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S261579AbVBWUyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 15:54:25 -0500
Content-Disposition: inline
In-Reply-To: <20050221020936.GA22713@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org

On Sun, Feb 20, 2005 at 09:09:36PM -0500, Jeff Garzik wrote:
> Irrelevant.  It matters to automated patch snarfers, lkml.org users, etc.

Jeff,
I just cut the patch using standard cvs diff.
I know SubmittingPatches wants -p0 but I also knew
that willy doesn't mind -p1 and he's the maintainer.

> Incorrect.  <linux/config.h> is not a standard include; you need to
> include linux/config.h in each file that uses a CONFIG_xxx define.

ok - I prefer files directly include the headers they depend on.
I'll add that and resubmit next week. Then willy can reject that
if he wants. :^)

thanks,
grant
