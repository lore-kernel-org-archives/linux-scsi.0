From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/10] Re-implement am53c974 driver
Date: Fri, 21 Nov 2014 11:26:39 +0100
Message-ID: <20141121102639.GA31016@lst.de>
References: <1416562077-105715-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59138 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaKUK0t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:26:49 -0500
Content-Disposition: inline
In-Reply-To: <1416562077-105715-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, davem@davemloft.net, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

On Fri, Nov 21, 2014 at 10:27:47AM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> having found some issues with the current tmscsim driver
> I looked at the code and found is really awkward to clean
> up.
> Seeing that the am53c974 chip is actually based on the
> 'ESP' chip design I've re-implemented it based on the
> common esp_scsi routines. This new driver
> (cunningly named 'am53c974') provides all features
> found on the tmscsim driver, with the goal of obsoleting
> the old tmscsim driver.
> Tested with Tekram DC390 and qemu esp-scsi.

This looks very nice!

Three high level comments:

 - please Cc Dave for changes to esp_scsi
 - please Cc Guennadi as the tmscsim maintainer
 - this probably should deprecated and/or remove the tmscsim driver
