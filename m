From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 19 Aug 2005 16:04:23 +0200
Message-ID: <20050819140423.GA12485@lst.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41176 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932593AbVHSOE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 10:04:57 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Thu, Aug 18, 2005 at 02:48:50PM -0400, James.Smart@Emulex.Com wrote:
> This is a heck of a statement... The customers don't see it as SAS vs FC
> vs SPI, they just see it as SCSI, and there's a lot of expectations on
> consistent behavior. We take a lot of heat defending the community's
> position, even from companies that you would have thought had signed on
> to the 2.6 behaviors.

Please forward such complaints to use (that is linux-scsi if possible,
else to James and me).

> I understand the need to push folks to the new 2.6 models, but I fully
> expect the same complaints to come from the users of SAS and iSCSI as well.
> 
> Please note that by implementing the consistent mappings, you are lessening
> the demands on the hba vendor to supply a non-upstream driver that works
> around the issue.

I think we fortunately have agreements with the distributors in place
to not make that happens, if the vendors decided to do it anyway it's
their fault.  We finally have the infrastructure for fully persistant
device names in place in the major distributions [1], so there's really
no need to do it anymore at the implementation detail level.

[1] http://www.kroah.com/log/2005/08/18/#2005_08_18-persistent
