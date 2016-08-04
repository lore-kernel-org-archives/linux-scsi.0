From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 08/22] fcoe: make R_A_TOV and E_D_TOV configurable
Date: Thu, 4 Aug 2016 13:52:30 +0200
Message-ID: <20160804115230.of45ubpqsg47wlum@c203.arch.suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbcHDMDq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 08:03:46 -0400
Content-Disposition: inline
In-Reply-To: <1470230002-37737-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.com>

On Wed, Aug 03, 2016 at 03:13:08PM +0200, Hannes Reinecke wrote:
> The user might want to modify the values for R_A_TOV and E_D_TOV,
> so add new module parameters 'e_d_tov' and 'r_a_tov' for the
> 'fcoe' modules and allow to modify them via sysfs attributes.
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
