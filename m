From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 21/23] scsi_dh_alua: update all port states
Date: Tue, 1 Sep 2015 12:32:23 +0200
Message-ID: <20150901103223.GG9838@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-22-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34691 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbbIAKcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 06:32:25 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-22-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, Aug 27, 2015 at 02:41:19PM +0200, Hannes Reinecke wrote:
> When we read in the target port group state we should be
> updating all affected port groups, otherwise we risk
> running out of sync.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
