From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/35] ibmvfc: Do not call fc_block_scsi_eh() on host
        reset
Date: Wed, 28 Jun 2017 01:55:20 +0200
Message-ID: <20170627235520.GD13988@lst.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de> <1498222975-71858-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46491 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753975AbdF0XzV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jun 2017 19:55:21 -0400
Content-Disposition: inline
In-Reply-To: <1498222975-71858-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
