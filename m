From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 06/22] libfc: Debug PRLI failures
Date: Thu, 4 Aug 2016 13:21:16 +0200
Message-ID: <20160804112116.u6nkpksju2lytgm4@c203.arch.suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbcHDLVS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 07:21:18 -0400
Content-Disposition: inline
In-Reply-To: <1470230002-37737-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.com>

On Wed, Aug 03, 2016 at 03:13:06PM +0200, Hannes Reinecke wrote:
> The initial PRLI is errored out with these messages:
> [ 5424.530686] host8: rport 001a1e: Received a PRLI accept
> [ 5424.530687] host8: rport 001a1e: PRLI spp_flags = 0x0
> [ 5424.530688] host8: rport 001a1e: Error -131938289606656 in state PRLI, retrying
> 
> 'spp_flags=0' is decidedly dodgy, as we should always return a valid PRLI
> state here.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
