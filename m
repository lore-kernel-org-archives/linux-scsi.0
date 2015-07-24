From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/20] scsi_dh_alua: Improve error handling
Date: Fri, 24 Jul 2015 16:48:02 +0200
Message-ID: <20150724144802.GA29096@lst.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55828 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbbGXOsE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 10:48:04 -0400
Content-Disposition: inline
In-Reply-To: <1436346378-96518-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

This seems to be a bit of a catchall.  Can you split the logging changes
from actual error code logic changes and describe the latter in more detail?
