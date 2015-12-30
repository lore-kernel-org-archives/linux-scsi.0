From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/20] revert commit a8e5a2d593cb ("[SCSI]
	scsi_dh_alua: ALUA handler attach should succeed while TPG is
	transitioning")
Date: Wed, 30 Dec 2015 12:22:20 +0100
Message-ID: <20151230112220.GD14156@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49224 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbbL3LWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 06:22:21 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

Maybe this should be folded into the next patch?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
