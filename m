From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] qla4xxx: remove two unused MSI-X related #defines
Date: Wed, 11 Jan 2017 14:29:21 +0100
Message-ID: <20170111132905.GG6286@linux-x5ow.site>
References: <1484141212-8637-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966603AbdAKN32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 08:29:28 -0500
Content-Disposition: inline
In-Reply-To: <1484141212-8637-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org

On Wed, Jan 11, 2017 at 02:26:52PM +0100, Christoph Hellwig wrote:
> Spotted while preparing qla2xxx changes as the symbols exist in both
> drivers (sigh..).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
