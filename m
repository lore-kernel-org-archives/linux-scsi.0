From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: + sections-fix-section-conflicts-in-drivers-scsi.patch added to
 -mm tree
Date: Fri, 14 Sep 2012 15:03:49 +0100
Message-ID: <1347631429.2450.11.camel@dabdike.int.hansenpartnership.com>
References: <20120913233742.7287E100047@wpzn3.hot.corp.google.com>
	 <1347609861.2794.1.camel@dabdike.int.hansenpartnership.com>
	 <20120914135043.GF4092@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58650 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160Ab2INOD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 10:03:56 -0400
In-Reply-To: <20120914135043.GF4092@tassilo.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2012-09-14 at 06:50 -0700, Andi Kleen wrote:
> > > ------------------------------------------------------
> > > From: Andi Kleen <ak@linux.intel.com>
> > > Subject: sections: fix section conflicts in drivers/scsi
> > 
> > NAK this, please.  We're fixing all of this by removing CONFIG_HOTPLUG,
> > so all __dev annotations become nops and there's little point changing
> > any.
> 
> I would prefer to still put it in because it fixes my compilation.
> You can still remove them then, but it's better to fix it first.

Just for curiosity, how?  You're compiling for x86-64, right?  There
aren't actually any defined configs for that arch with it disabled.  I
thought non-hotplug x86 configs weren't really meaningful (because USB
requires it and all modern x86 configs are USB).

James



