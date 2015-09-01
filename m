From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 20/23] scsi_dh_alua: Recheck state on unit attention
Date: Tue, 1 Sep 2015 12:31:26 +0200
Message-ID: <20150901103126.GF9838@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34683 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbbIAKb3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 06:31:29 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

> -			alua_check(sdev);
> -			return ADD_TO_MLQUEUE;
> +			alua_check(sdev, false);
> +			return NEEDS_RETRY;

What's the reason for the change in return value here?
