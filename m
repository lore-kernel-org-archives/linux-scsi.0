From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 05/24] libfc: sanitize E_D_TOV and R_A_TOV setting
Date: Thu, 13 Oct 2016 15:42:59 +0200
Message-ID: <20161013134259.jdonyqnjo3jodgv5@linux-x5ow.site>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
 <1476364260-12191-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42241 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbcJMNol (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:44:41 -0400
Content-Disposition: inline
In-Reply-To: <1476364260-12191-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, Oct 13, 2016 at 03:10:41PM +0200, Hannes Reinecke wrote:
> When setting the FCP timeout we need to ensure a lower boundary
> for E_D_TOV and R_A_TOV, otherwise we'd be getting spurious I/O
> issues due to the fcp timer firing too early.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

Acked-by: Johannes Thumshirn <jth@kernel.org>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
