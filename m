From: jbarnes@sgi.com (Jesse Barnes)
Subject: Re: [PATCH] 2.6.3 qla2xxx driver -- use readX_relaxed
Date: Thu, 26 Feb 2004 08:47:59 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040226164759.GB27729@sgi.com>
References: <20040226040535.GA559454@sgi.com> <1077785550.4443.0.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:57981 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S262834AbUBZQsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2004 11:48:07 -0500
Content-Disposition: inline
In-Reply-To: <1077785550.4443.0.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, linux-scsi@vger.kernel.org, jbarnes@cthulhu.engr.sgi.com

On Thu, Feb 26, 2004 at 09:52:30AM +0100, Arjan van de Ven wrote:
> On Thu, 2004-02-26 at 05:05, Jeremy Higdon wrote:
> > I'm submitting a patch for comment and consideration.  The relaxed read
> > interface was added a few weeks back, and this patch lets the qla2xxx driver
> > take advantage of it.
> 
> please tell me we don't have to pee all over the drivers to add this
> everywhere now;(

Not everywhere.  Drivers will work fine without any changes, but will
work faster if readX is turned into readX_relaxed in the fast paths
where DMA completion isn't important.  In the lkml thread that discussed
this feature everyone seemed to agree on that approach.  Would you
rather have a different interface?

Thanks,
Jesse
