From: jbarnes@sgi.com (Jesse Barnes)
Subject: Re: [PATCH] 2.6.3 qla2xxx driver -- use readX_relaxed
Date: Tue, 2 Mar 2004 09:19:19 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040302171919.GA25454@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060EE25@AVEXCH02.qlogic.org> <20040302010227.GA583940@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:18422 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S261712AbUCBRUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2004 12:20:02 -0500
Content-Disposition: inline
In-Reply-To: <20040302010227.GA583940@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

On Mon, Mar 01, 2004 at 05:02:28PM -0800, Jeremy Higdon wrote:
> On Mon, Mar 01, 2004 at 04:45:49PM -0800, Andrew Vasquez wrote:
> > Sounds good, I just wish I had an Altix machine to test with.  You
> > seem to have covered most of the fast-path cases, I'll look some more
> > tonight for any others.  I guess my only nit-pick is the lowercase
> > _relaxed() suffix applied to RD_REG* #defines.

Cool, that would be nice.

> You can certainly change the #defines in the driver to match what you
> want.  If you want to change the underlying pci codes, we'd have to
> patch the kernel a bit.  If there's a good consensus that _relaxed
> is bad and something else is better, we could do that, right Jesse?  :-)

Sure, we can do a search and replace before there are too many users if
there's enough demand.

Jesse
