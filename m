From: Andi Kleen <ak@linux.intel.com>
Subject: Re: + sections-fix-section-conflicts-in-drivers-scsi.patch added to
 -mm tree
Date: Fri, 14 Sep 2012 07:18:21 -0700
Message-ID: <20120914141821.GG4092@tassilo.jf.intel.com>
References: <20120913233742.7287E100047@wpzn3.hot.corp.google.com>
 <1347609861.2794.1.camel@dabdike.int.hansenpartnership.com>
 <20120914135043.GF4092@tassilo.jf.intel.com>
 <1347631429.2450.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25076 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2INOS2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 10:18:28 -0400
Content-Disposition: inline
In-Reply-To: <1347631429.2450.11.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Sep 14, 2012 at 03:03:49PM +0100, James Bottomley wrote:
> On Fri, 2012-09-14 at 06:50 -0700, Andi Kleen wrote:
> > > > ------------------------------------------------------
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > Subject: sections: fix section conflicts in drivers/scsi
> > > 
> > > NAK this, please.  We're fixing all of this by removing CONFIG_HOTPLUG,
> > > so all __dev annotations become nops and there's little point changing
> > > any.
> > 
> > I would prefer to still put it in because it fixes my compilation.
> > You can still remove them then, but it's better to fix it first.
> 
> Just for curiosity, how?  You're compiling for x86-64, right?  There

I compile allyes (and also random/no/normal/rhel6/opensuse configs) on 32bit
and 64bit. Most of the section fixes I did showed up as actual errors,
but I also did some greping some time ago, so there may be a few changes
in dead code. However the majority was live.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
