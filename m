From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.20 available
Date: Tue, 25 Jan 2005 21:40:13 +0000
Message-ID: <20050125214013.GA28707@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C12EA20@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52132 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262132AbVAYVkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 16:40:24 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EA20@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 20, 2005 at 11:26:00AM -0500, James.Smart@Emulex.Com wrote:
> > This sounds like a good idea, but I wonder if we have userland relying
> > on those attributes already.  But given that the fc transport class
> > was mostly a joke before you encehanced it it might be worth breaking
> > it..
> 
> You and James would have to give the approval for this one. I already
> encountered issues with these attributes when then went from scsi_device
> to scsi_target. The most significant hiccup was to udev and the projects
> depending on it... Also, given the potential amount of change may be
> needed to move to rports, I wouldn't want to pull the rug out from under
> the other drivers until they are ready...

James just returned from a long journey and he hasn't read the thread yet,
but after a short discussion we agree that it's better to move the attributes
over to the rnode.  If we're seeing compatiblity problems we'll have to
add symlinks.

> 
> 
> -- james s
---end quoted text---
