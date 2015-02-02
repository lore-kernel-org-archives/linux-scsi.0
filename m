From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] phy: qcom-ufs: export symbols needed by main drivers
Date: Mon, 2 Feb 2015 17:26:48 +0100
Message-ID: <20150202162648.GA20465@lst.de>
References: <1840882.huchmEIh5K@wuerfel> <1422891069.2103.1.camel@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44603 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384AbbBBQ0w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2015 11:26:52 -0500
Content-Disposition: inline
In-Reply-To: <1422891069.2103.1.camel@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>, "dovl@codeaurora.org" <dovl@codeaurora.org>, "ygardi@codeaurora.org" <ygardi@codeaurora.org>, "kishon@ti.com" <kishon@ti.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Feb 02, 2015 at 03:30:27PM +0000, James Bottomley wrote:
> Cc added for linux-scsi, since this is the origin of the problem.  How
> important is bisectability in this?  It won't affect any non-embedded
> user, since most don't build with UFS, so I can go either way on folding
> or just applying as an extra patch.

The CRYPTO_DEV_QCOM_ICE symbol was never defined in the scsi trees, and
would have needed something else from linux-next to even compile.  So I
don't think the revert is a problem at all, and I'll add it to the
scsi-for-3.20 branch ASAP.
