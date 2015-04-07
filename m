From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2] libsas: Fixup transport protocol definition in
	sas_get_ata_info()
Date: Tue, 7 Apr 2015 17:45:50 +0200
Message-ID: <20150407154550.GA18837@lst.de>
References: <1428396547-87814-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58922 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbbDGPpw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2015 11:45:52 -0400
Content-Disposition: inline
In-Reply-To: <1428396547-87814-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Apr 07, 2015 at 10:49:07AM +0200, Hannes Reinecke wrote:
> 'tproto' specifies the transport protocol, not the device type.
> So use the correct definitions here.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

This looks correct, but opens up questions:

 - how did you find this?
 - why didn't we notice earlier?

Also I wonder if we should move to more __bitwise types for these
kinds of things..
