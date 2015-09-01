From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/23] scsi_dh_alua: Pass buffer as function argument
Date: Tue, 1 Sep 2015 11:55:00 +0200
Message-ID: <20150901095500.GG9485@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34514 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbbIAJzB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 05:55:01 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, Aug 27, 2015 at 02:41:08PM +0200, Hannes Reinecke wrote:
> Pass in the buffer as a function argument for submit_rtpg().

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
