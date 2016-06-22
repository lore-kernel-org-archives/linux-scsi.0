From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] scsi: consolidate checking for VPD pages
Date: Wed, 22 Jun 2016 15:24:45 +0200
Message-ID: <20160622132445.GC6118@lst.de>
References: <1466405868-87720-1-git-send-email-hare@suse.de> <1466405868-87720-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51999 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbcFVNYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2016 09:24:47 -0400
Content-Disposition: inline
In-Reply-To: <1466405868-87720-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Looks fine, although I wonder if simple calling scsi_device_supports_vpd
in scsi_get_vpd_page wouldn't be even better.
