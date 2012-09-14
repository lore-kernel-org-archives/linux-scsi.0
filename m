From: Andi Kleen <ak@linux.intel.com>
Subject: Re: + sections-fix-section-conflicts-in-drivers-scsi.patch added to
 -mm tree
Date: Fri, 14 Sep 2012 06:50:43 -0700
Message-ID: <20120914135043.GF4092@tassilo.jf.intel.com>
References: <20120913233742.7287E100047@wpzn3.hot.corp.google.com>
 <1347609861.2794.1.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23224 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab2INNu7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 09:50:59 -0400
Content-Disposition: inline
In-Reply-To: <1347609861.2794.1.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

> > ------------------------------------------------------
> > From: Andi Kleen <ak@linux.intel.com>
> > Subject: sections: fix section conflicts in drivers/scsi
> 
> NAK this, please.  We're fixing all of this by removing CONFIG_HOTPLUG,
> so all __dev annotations become nops and there's little point changing
> any.

I would prefer to still put it in because it fixes my compilation.
You can still remove them then, but it's better to fix it first.

-Andi
