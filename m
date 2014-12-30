From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: Using common code for csiostor.
Date: Tue, 30 Dec 2014 04:23:33 -0800
Message-ID: <20141230122333.GJ32187@infradead.org>
References: <24C222ADD7729F4FB5113B41FF0028A1BC8C12@nice.asicdesigners.com>
 <1418832615.3052.36.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41196 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaL3MXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2014 07:23:34 -0500
Content-Disposition: inline
In-Reply-To: <1418832615.3052.36.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Praveen Madhavan <praveenm@chelsio.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Dec 17, 2014 at 08:10:15AM -0800, James Bottomley wrote:
> The usual way to do this is to make the common hardware function a base
> module and make all drivers that use it depend on it.  Like iwldvm ->
> iwlwifi -> mac80211 etc.
> 
> We really wouldn't want to do the link and build because that will
> create two identical binary copies of the interface (one in SCSI and one
> in net) which is a waste of text space.

Agreed.  If the amount of shared code is really small a header with
inlines might be an alternative as there is some overhead creating a new
module.
