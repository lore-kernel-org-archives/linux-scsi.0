From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] remove scsi_assign_lock
Date: Fri, 13 Jan 2006 11:37:36 -0700
Message-ID: <20060113183736.GQ19769@parisc-linux.org>
References: <20060113182543.GA4148@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44524 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1422817AbWAMShi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:37:38 -0500
Content-Disposition: inline
In-Reply-To: <20060113182543.GA4148@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Fri, Jan 13, 2006 at 07:25:43PM +0100, Christoph Hellwig wrote:
> We finally fixed all drivers to not require this hack, so let's get rid
> of it before people reintroduce uses (vendor drivers seem to be very
> eager to use it for no obvious reason)

Although of course they'll now just assign to host_lock direectly.
Presumably you intend to remove that in the near future, but didn't do
that now because it would introduce too much code churn?
