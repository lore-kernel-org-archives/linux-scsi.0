From: "hch@lst.de" <hch@lst.de>
Subject: Re: sort out the ->eh_timed_out mess
Date: Wed, 1 Feb 2017 10:39:01 +0100
Message-ID: <20170201093901.GA1336@lst.de>
References: <1485778739-29036-1-git-send-email-hch@lst.de> <1485794746.2712.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34068 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751519AbdBAJjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Feb 2017 04:39:02 -0500
Content-Disposition: inline
In-Reply-To: <1485794746.2712.5.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>

On Mon, Jan 30, 2017 at 04:46:00PM +0000, Bart Van Assche wrote:
> Patches 1, 2 and 4 of this series are a real improvement in my opinion.
> However, I'm not sure whether patch 3 is the best way to avoid that drivers
> have to re-override the transport template timeout handler. Have you
> considered to modify the SCSI EH such that the host timeout handler has
> priority over the transport timeout handler? I think that would result in
> a much smaller patch 3/4.

It's not too much of a difference in patch size, and I think it's
the cleaner model to only have the method once.

However if there is a consensus against this version I can respin
a patch that just changes the precendence.
