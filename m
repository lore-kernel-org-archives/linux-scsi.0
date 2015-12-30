From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/20] scsi_dh_alua: separate out alua_stpg()
Date: Wed, 30 Dec 2015 12:06:47 +0100
Message-ID: <20151230110647.GA13951@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49146 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbbL3LGt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 06:06:49 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

The stpg variable could be a bool.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
