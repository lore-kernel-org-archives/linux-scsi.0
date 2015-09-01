From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/23] scsi_dh_alua: switch to scsi_execute_req_flags()
Date: Tue, 1 Sep 2015 12:07:14 +0200
Message-ID: <20150901100714.GB9838@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-13-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34575 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbbIAKHQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 06:07:16 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-13-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

Looks good fine, but please add a comment explaining why the
REQ_QUIET and REQ_PREEMPT flags added by scsi_execture are fine,
or in fact desireable.

Reviewed-by: Christoph Hellwig <hch@lst.de>
