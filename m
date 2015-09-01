From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/10] scsi_dh: move 'dh_state' sysfs attribute to
	generic code
Date: Tue, 1 Sep 2015 11:35:58 +0200
Message-ID: <20150901093558.GA9485@lst.de>
References: <1440677823-11695-1-git-send-email-hare@suse.de> <1440677823-11695-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34424 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbbIAJgA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 05:36:00 -0400
Content-Disposition: inline
In-Reply-To: <1440677823-11695-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

On Thu, Aug 27, 2015 at 02:17:03PM +0200, Hannes Reinecke wrote:
> As scsi_dh.c is now always compiled in we should be moving
> the 'dh_state' attribute to the generic code.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
