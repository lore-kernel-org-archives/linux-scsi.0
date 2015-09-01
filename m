From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 22/23] scsi_dh_alua: Send TEST UNIT READY to poll for
	transitioning
Date: Tue, 1 Sep 2015 12:34:27 +0200
Message-ID: <20150901103427.GH9838@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-23-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34697 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbbIAKe3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 06:34:29 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-23-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, Aug 27, 2015 at 02:41:20PM +0200, Hannes Reinecke wrote:
> Sending a 'REPORT TARGET PORT GROUP' command is a costly operation,
> as the array has to gather information about all ports.
> So instead of using RTPG to poll for a status update when a port
> is in transitioning we should be sending a TEST UNIT READY, and
> wait for the sense code to report success.

The extra state variabe doesn't really help you as it might be stale
just as quickly.

But otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
