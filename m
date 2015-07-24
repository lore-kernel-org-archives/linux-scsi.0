From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/20] scsi_dh_alua: switch to scsi_execute()
Date: Fri, 24 Jul 2015 16:53:43 +0200
Message-ID: <20150724145343.GD29096@lst.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55876 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbbGXOxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 10:53:44 -0400
Content-Disposition: inline
In-Reply-To: <1436346378-96518-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

Seems like this should use scsi_execute_req_flags instead so that it doesn't
have to deal with the raw sense buffer.
