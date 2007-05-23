From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] Fixup LLDDs to check for valid hostdata pointer
Date: Wed, 23 May 2007 15:09:00 +0100
Message-ID: <20070523140900.GA22770@infradead.org>
References: <20070523085538.1764ED44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60027 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbXEWOJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 10:09:03 -0400
Content-Disposition: inline
In-Reply-To: <20070523085538.1764ED44CB@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Wed, May 23, 2007 at 10:55:38AM +0200, Hannes Reinecke wrote:
> 
> slave_destory() is now called asynchronously, hence we have to
> check if the ->hostdata pointer is valid before accessing it.
> Fixup all LLDDs to verify the hostdata pointer.

No way we're going to put this in.  This just creates a complete mess
in the drivers.  Please rework your patch series to avoid this issue.
