From: Christoph Hellwig <hch@lst.de>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Fri, 2 Oct 2015 15:34:23 +0200
Message-ID: <20151002133423.GA15867@lst.de>
References: <20150925121636.GC12540@fergus.ozlabs.ibm.com> <20150925151802.GB20282@lst.de> <1443202278.2188.13.camel@HansenPartnership.com> <20150930151449.GC26299@lst.de> <20150930215303.GI2627@mtj.duckdns.org> <1443652494.2185.57.camel@HansenPartnership.com> <20151002125608.GB14899@lst.de> <1443792301.2209.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44098 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbbJBNeZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 09:34:25 -0400
Content-Disposition: inline
In-Reply-To: <1443792301.2209.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org

On Fri, Oct 02, 2015 at 06:25:01AM -0700, James Bottomley wrote:
> That doesn't matter: if you modprobe alua after all devices are
> discovered, it will attach correctly to all potential devices from the
> alua module_init.  This means the effect is the same whether the
> request_module is sync or async ... the object is to get the device
> attached to alua if it is an alua device.

No, in 4.3-rc it won't.  We removed that feature.
